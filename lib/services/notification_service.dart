import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

import '../core/sleep_calculator.dart';
import '../data/check_in_repository.dart';
import '../data/database.dart';
import '../data/night_planning_repository.dart';
import 'notification_actions.dart';
import 'permissions_service.dart';

enum NotificationKind { putPhoneDown, bedtime, checkIn, redNight }

const int _testNotificationId = 999999;

/// Stable per-night, per-kind notification ids so a reschedule can predict
/// and cancel exactly the ones it set before (e.g. when "เข้านอนแล้ว" is
/// pressed, section 5: "ไม่ส่งถ้ากด 'เข้านอนแล้ว' ไปแล้ว").
int notificationIdFor(NotificationKind kind, DateTime wakeDate) {
  final daysSinceEpoch = DateTime(
    wakeDate.year,
    wakeDate.month,
    wakeDate.day,
  ).difference(DateTime(2020, 1, 1)).inDays;
  return kind.index * 100000 + (daysSinceEpoch % 100000);
}

const _putPhoneDownMessages = [
  'ถึงเวลาวางมือถือแล้ว เริ่มเข้านอนได้เลย',
  'ใกล้เวลานอนแล้ว ลองปิดหน้าจอดูนะ',
  'อีกไม่นานถึงเวลานอน วางมือถือแล้วเตรียมตัวได้แล้ว',
];

/// Used while today's activities haven't been told yet.
const _askActivityMessages = [
  'ใกล้เวลานอนแล้ว บอกหน่อยว่าวันนี้ทำอะไรมา แล้วมายืดตัวกัน',
  'ได้เวลาพักแล้ว วันนี้ทำอะไรมาบ้าง Glow จะเลือกท่ายืดให้',
];

const _bedtimeMessages = [
  'ถึงเวลาเข้านอนแล้ว ฝันดีนะ',
  'เวลานอนมาถึงแล้ว ปิดไฟได้เลย',
  'ได้เวลาเข้านอนแล้ว พรุ่งนี้สดชื่นแน่นอน',
];

const _checkInMessages = [
  'เมื่อคืนนอนเป็นยังไง แวะเช็กอินหน่อยนะ',
  'อย่าลืมเช็กอินเมื่อคืนที่ผ่านมา',
  'เช็กอินตอนเช้าเพื่อดูผลการนอนเมื่อคืนนี้',
];

const _redNightMessages = [
  'คืนข้างหน้าตารางแน่นมาก นอนอาจไม่ครบ ลองดูทางเลือกในแอปได้นะ',
  'เจอคืนที่ตารางชนกับเวลานอน ลองปรับตารางหรือเข้านอนเร็วขึ้นคืนก่อนดูนะ',
];

String _randomMessage(List<String> messages) =>
    messages[Random().nextInt(messages.length)];

/// Schedules/cancels local notifications per CLAUDE.md section 5. Never
/// requests ignoreBatteryOptimizations via a popup — only exact-alarm and
/// notification permissions, via [PermissionsService].
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final PermissionsService permissions;
  bool _initialized = false;

  NotificationService(this.permissions);

  /// Set when "เริ่มท่าก่อนนอน" is tapped on a reminder; the Tonight screen
  /// opens the routine and clears it.
  final ValueNotifier<bool> routineRequested = ValueNotifier(false);

  void _onTap(NotificationResponse response) {
    if (response.actionId == startRoutineActionId) {
      routineRequested.value = true;
    }
  }

  /// Re-read on every reschedule so a timezone change is picked up without
  /// restarting the app.
  Future<void> _syncTimeZone() async {
    final localTz = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(localTz.identifier));
  }

  Future<void> init() async {
    if (_initialized) return;
    tz_data.initializeTimeZones();
    await _syncTimeZone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    await _plugin.initialize(
      settings: const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: _onTap,
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationAction,
    );
    // The app may have been started by tapping an action.
    final launch = await _plugin.getNotificationAppLaunchDetails();
    final response = launch?.notificationResponse;
    if (launch?.didNotificationLaunchApp == true && response != null) {
      _onTap(response);
    }
    _initialized = true;
  }

  /// Waits its turn behind any reschedule in progress, which would otherwise
  /// put reminders back after they were cancelled.
  Future<void> cancelAll() => _enqueue(() async {
    await init();
    await _plugin.cancelAll();
  });

  /// Cancels just the bedtime reminder for one night, called when the user
  /// taps "เข้านอนแล้ว" before it would have fired.
  Future<void> cancelBedtimeNotification(DateTime wakeDate) {
    return _plugin.cancel(
      id: notificationIdFor(NotificationKind.bedtime, wakeDate),
    );
  }

  /// Cancels the check-in reminder for one night, called once a check-in is
  /// recorded for it (section 5: "ไม่ส่งถ้าเช็กอินแล้ว").
  Future<void> cancelCheckInNotification(DateTime wakeDate) {
    return _plugin.cancel(
      id: notificationIdFor(NotificationKind.checkIn, wakeDate),
    );
  }

  Future<void> _queue = Future.value();

  /// Runs notification changes one at a time, so they can't interleave.
  Future<void> _enqueue(Future<void> Function() action) {
    final next = _queue.catchError((_) {}).then((_) => action());
    _queue = next;
    return next;
  }

  /// Clears and re-schedules the next 7 nights' put-phone-down and bedtime
  /// reminders, per section 5's "ลบแล้วตั้งใหม่ทั้งชุด" rule. Call this on
  /// app open, after editing schedule/settings, on boot, and on
  /// timezone/clock change.
  Future<void> rescheduleAll({
    required NightPlanningRepository repo,
    required CheckInRepository checkInRepo,
    required DateTime now,
  }) {
    return _enqueue(() => _reschedule(repo, checkInRepo, now));
  }

  Future<void> _reschedule(
    NightPlanningRepository repo,
    CheckInRepository checkInRepo,
    DateTime now,
  ) async {
    await init();
    await _syncTimeZone();
    // Only pending reminders: cancelAll() would also wipe an alert already in
    // the tray and a test notification that hasn't fired yet.
    for (final pending in await _plugin.pendingNotificationRequests()) {
      if (pending.id != _testNotificationId) {
        await _plugin.cancel(id: pending.id);
      }
    }

    // Read again: the caller's copy may predate a delete or an edit made
    // while this was waiting its turn.
    final settings = await checkInRepo.settingsRepo.get();
    // Nothing to remind about until onboarding is done (including right
    // after all data was deleted).
    if (!settings.onboardingCompleted) return;

    final exactAlarmsGranted = await permissions.hasExactAlarmPermission();
    final scheduleMode = exactAlarmsGranted
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    final today = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < 7; i++) {
      final wakeDate = today.add(Duration(days: i));
      final draft = await repo.currentPlan(wakeDate);
      final inBed = (await repo.getPlanRow(wakeDate))?.inBedAt != null;
      final alreadyCheckedIn =
          await checkInRepo.getForWakeDate(wakeDate) != null;
      final dayRow = await (repo.db.select(
        repo.db.dayActivities,
      )..where((t) => t.wakeDate.equals(wakeDate))).getSingleOrNull();
      await _scheduleNight(
        activitiesAnswered: dayRow?.confirmed == true,
        draft: draft,
        settings: settings,
        now: now,
        scheduleMode: scheduleMode,
        alreadyCheckedIn: alreadyCheckedIn,
        inBed: inBed,
      );
    }
  }

  Future<void> _scheduleNight({
    required NightPlanDraft draft,
    required SettingsRow settings,
    required DateTime now,
    required AndroidScheduleMode scheduleMode,
    required bool alreadyCheckedIn,
    required bool inBed,
    required bool activitiesAnswered,
  }) async {
    final notifyOffsetMinutes = draft.isPreExamNight ? 90 : 60;
    final notifyTime = draft.bedtime.subtract(
      Duration(minutes: notifyOffsetMinutes),
    );

    if (settings.notifyPutPhoneDown && !inBed && notifyTime.isAfter(now)) {
      await _zonedSchedule(
        id: notificationIdFor(NotificationKind.putPhoneDown, draft.wakeDate),
        at: notifyTime,
        title: 'Glow',
        body: _randomMessage(
          settings.routineEnabled && !activitiesAnswered
              ? _askActivityMessages
              : _putPhoneDownMessages,
        ),
        scheduleMode: scheduleMode,
        payload: draft.wakeDate.toIso8601String(),
        actions: [
          if (settings.routineEnabled)
            const AndroidNotificationAction(
              startRoutineActionId,
              'เริ่มท่าก่อนนอน',
              showsUserInterface: true,
            ),
        ],
      );
    }
    if (settings.notifyBedtime && !inBed && draft.bedtime.isAfter(now)) {
      await _zonedSchedule(
        id: notificationIdFor(NotificationKind.bedtime, draft.wakeDate),
        at: draft.bedtime,
        title: 'Glow',
        body: _randomMessage(_bedtimeMessages),
        scheduleMode: scheduleMode,
        payload: draft.wakeDate.toIso8601String(),
        actions: const [
          // Handled without opening the app.
          AndroidNotificationAction(inBedActionId, 'เข้านอนแล้ว'),
        ],
      );
    }
    final checkInTime = draft.wakeTime.add(const Duration(minutes: 30));
    if (settings.notifyCheckIn &&
        !alreadyCheckedIn &&
        checkInTime.isAfter(now)) {
      await _zonedSchedule(
        id: notificationIdFor(NotificationKind.checkIn, draft.wakeDate),
        at: checkInTime,
        title: 'Glow',
        body: _randomMessage(_checkInMessages),
        scheduleMode: scheduleMode,
      );
    }
  }

  Future<void> _zonedSchedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    required AndroidScheduleMode scheduleMode,
    String? payload,
    List<AndroidNotificationAction> actions = const [],
  }) async {
    await _plugin.zonedSchedule(
      id: id,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      title: title,
      body: body,
      androidScheduleMode: scheduleMode,
      payload: payload,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'glow_sleep_reminders',
          'การเตือนเรื่องการนอน',
          importance: Importance.high,
          priority: Priority.high,
          actions: actions,
        ),
      ),
    );
  }

  /// Section 5: red-night-ahead alert, shown immediately (not scheduled)
  /// when detected between 08:00-20:00, once per night.
  Future<void> maybeSendRedNightAheadAlert({
    required NightPlanningRepository repo,
    required bool enabled,
    required DateTime now,
  }) async {
    if (!enabled) return;
    if (now.hour < 8 || now.hour >= 20) return;

    final unalerted = await repo.findUnalertedRedNightsAhead(now);
    if (unalerted.isEmpty) return;

    await init();
    for (final night in unalerted) {
      await _plugin.show(
        id: notificationIdFor(NotificationKind.redNight, night.wakeDate),
        title: 'Glow',
        body: _randomMessage(_redNightMessages),
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'glow_busy_schedule',
            'เตือนตารางแน่น',
            importance: Importance.high,
            priority: Priority.high,
          ),
        ),
      );
      await repo.markRedAlertSent(night.wakeDate, now);
    }
  }

  Future<void> showTestNotification() async {
    await init();
    final exactAlarmsGranted = await permissions.hasExactAlarmPermission();
    final at = DateTime.now().add(const Duration(minutes: 1));
    await _zonedSchedule(
      id: _testNotificationId,
      at: at,
      title: 'Glow',
      body: 'นี่คือการแจ้งเตือนทดสอบ ตั้งไว้ล่วงหน้า 1 นาที',
      scheduleMode: exactAlarmsGranted
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );
  }
}
