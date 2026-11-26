import 'dart:async';

import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'countdown_strip.dart';
import '../../core/first_class.dart';
import '../../core/activity_guess.dart';
import '../../core/bed_press.dart';
import '../../core/economy_config.dart';
import '../../core/night_date.dart';
import '../../core/quests.dart';
import '../../core/quests.dart' as quests;
import '../../core/routine_builder.dart';
import '../../core/routine_config.dart';
import '../../core/schedule_load.dart';
import '../../core/schedule_models.dart';
import '../../core/sleep_calculator.dart';
import '../../data/check_in_repository.dart';
import '../../data/night_planning_repository.dart';
import '../../data/settings_repository.dart';
import '../../data/stats_repository.dart';
import '../../providers.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_fold.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/night_ring.dart';
import '../../theme/widgets/warning_bar.dart';
import '../card/my_card.dart';
import '../evening/evening_card.dart';
import '../evening/evening_screen.dart';
import '../routine/activity_card.dart';
import '../routine/routine_screen.dart';
import '../settings/setting_row.dart';
import '../share/share_screen.dart';
import '../shared/settings_button.dart';
import '../stats/heatmap.dart';
import '../stats/night_detail_sheet.dart';
import '../web/web_reminder_bars.dart';
import 'check_in_card.dart';
import 'check_in_result_screen.dart';
import '../../services/app_clock.dart';
import '../../services/home_widget_service.dart';

class TonightPlanData {
  final DateTime wakeDate;
  final NightPlanDraft draft;
  final EveningLoadResult load;
  final PendingCheckIn? pendingCheckIn;
  final int weeklyPassCount;
  final DateTime? inBedAt;
  final QuestMode mode;
  final bool lowEnergy;
  final bool canChangeLowEnergy;

  /// The saved chips, or the guess from today's schedule.
  final Set<DayActivityKind> activities;
  final bool activitiesConfirmed;

  /// When the activity card may appear this evening.
  final DateTime activityCardFrom;
  final bool routineEnabled;
  final bool eveningEnabled;

  /// This morning's usual or shortened prep time; null once the plan locked.
  final int? adjustablePrepMinutes;
  final Set<String> hiddenPoseIds;
  final bool routineDone;
  final ScheduleEntry? firstAppointment;
  final List<HeatmapCell> weekCells;

  const TonightPlanData({
    required this.wakeDate,
    required this.draft,
    required this.load,
    required this.pendingCheckIn,
    required this.weeklyPassCount,
    required this.inBedAt,
    required this.mode,
    required this.lowEnergy,
    required this.canChangeLowEnergy,
    required this.activities,
    required this.activitiesConfirmed,
    required this.activityCardFrom,
    required this.routineEnabled,
    required this.eveningEnabled,
    required this.adjustablePrepMinutes,
    required this.hiddenPoseIds,
    required this.routineDone,
    required this.firstAppointment,
    required this.weekCells,
  });
}

/// Recomputes whenever schedule or settings change — and, since it's the
/// only place that watches all three, also reschedules local notifications
/// then (CLAUDE.md section 5: "ลบแล้วตั้งใหม่ทั้งชุดเมื่อ...แก้ตารางหรือ
/// ตั้งค่า"). TonightScreen stays mounted under the bottom nav's
/// IndexedStack even when another tab is showing, so this keeps firing
/// regardless of which tab is visible.
final tonightPlanProvider = FutureProvider.autoDispose<TonightPlanData>((
  ref,
) async {
  ref.watch(weeklyItemsStreamProvider);
  ref.watch(oneTimeItemsStreamProvider);
  final settings = ref.watch(settingsStreamProvider).value;
  final repo = ref.watch(nightPlanningRepositoryProvider);
  final now = ref.watch(clockProvider)();

  final fireRepo = ref.watch(fireRepositoryProvider);
  final checkInRepo = ref.watch(checkInRepositoryProvider);
  final questRepo = ref.watch(questRepositoryProvider);
  // This provider can be rebuilt while an earlier run is still going; one
  // transaction keeps the two from applying the same reward or penalty twice.
  await ref.watch(databaseProvider).transaction(() async {
    await repo.lockElapsedNights(now);
    await fireRepo.grantFreeShieldIfNewWeek(now);
    await checkInRepo.sweepMissedNights(now);
    await questRepo.claimWeeklyRewardIfComplete(now);
    await questRepo.claimExamPeriodRewardsIfComplete(now);
  });

  if (ref.watch(clockOffsetProvider) != Duration.zero) {
    // Demo time travel: real reminders would fire at nonsense moments.
    await ref.watch(notificationServiceProvider).cancelAll();
  } else if (settings != null && settings.onboardingCompleted) {
    final notificationService = ref.watch(notificationServiceProvider);
    await notificationService.rescheduleAll(
      repo: repo,
      checkInRepo: ref.watch(checkInRepositoryProvider),
      now: now,
    );
    await notificationService.maybeSendRedNightAheadAlert(
      repo: repo,
      enabled: settings.notifyBusyNight,
      now: now,
    );
  }

  await ref.watch(eveningRepositoryProvider).carryOverLockedTasks(now);

  // The widgets follow every change to the plan, the press, and check-ins.
  final database = ref.watch(databaseProvider);
  if (ref.watch(platformCapabilitiesProvider).homeWidget) {
    unawaited(updateHomeWidgets(database, now));
  }

  final wakeDate = resolveTonightWakeDate(now);
  final draft = await repo.getOrLockPlan(wakeDate, now: now);
  final load = await repo.computeEveningLoad(draft);
  final pendingCheckIn = await ref
      .watch(checkInRepositoryProvider)
      .findPendingCheckIn(now);
  final weeklyPassCount = await questRepo.currentWeekPassCount(now);
  final planRow = await repo.getPlanRow(wakeDate);
  final routineRepo = ref.watch(routineRepositoryProvider);
  final savedActivities = await routineRepo.activitiesFor(wakeDate);
  final routineLog = await routineRepo.logFor(wakeDate);
  final lowEnergy = planRow?.lowEnergy ?? false;
  // "Today" for this night is the evening that leads into it.
  final eveningDate = DateTime(wakeDate.year, wakeDate.month, wakeDate.day - 1);
  final todaysEntries = await repo.entriesOn(eveningDate);
  return TonightPlanData(
    wakeDate: wakeDate,
    draft: draft,
    load: load,
    pendingCheckIn: pendingCheckIn,
    weeklyPassCount: weeklyPassCount,
    inBedAt: planRow?.inBedAt,
    mode: await repo.questModeFor(draft),
    lowEnergy: lowEnergy,
    canChangeLowEnergy:
        planRow?.isLocked != true &&
        // A red night is already down to one quest.
        (lowEnergy || load.level != EveningLoadLevel.red) &&
        quests.canChangeLowEnergy(
          now: now,
          lockTime: NightPlanningRepository.notifyTimeOf(draft),
          usedOnOtherNightsThisWeek: await repo.lowEnergyUsedElsewhere(
            wakeDate,
          ),
        ),
    activities: savedActivities?.activities ?? guessActivities(todaysEntries),
    activitiesConfirmed: savedActivities?.confirmed ?? false,
    activityCardFrom: activityCardFrom(eveningDate, todaysEntries),
    routineEnabled: settings?.routineEnabled ?? true,
    eveningEnabled: settings?.eveningEnabled ?? true,
    adjustablePrepMinutes: planRow?.isLocked == true || settings == null
        ? null
        : planRow?.prepOverrideMinutes ?? settings.prepMinutes,
    hiddenPoseIds: settings == null ? const {} : hiddenPoseSet(settings),
    routineDone: routineLog?.completed ?? false,
    firstAppointment: await repo.firstAppointment(wakeDate),
    weekCells: await ref
        .watch(statsRepositoryProvider)
        .rangeCells(
          mondayOfWeek(wakeDate),
          mondayOfWeek(wakeDate).add(const Duration(days: 6)),
        ),
  );
});

final _hasAnyScheduleProvider = Provider.autoDispose<bool>((ref) {
  final weekly = ref.watch(weeklyItemsStreamProvider).value ?? [];
  final oneTime = ref.watch(oneTimeItemsStreamProvider).value ?? [];
  // The earliest class time given at the start is enough to plan from.
  final earliestClass = ref
      .watch(settingsStreamProvider)
      .value
      ?.earliestClassMinutes;
  return weekly.isNotEmpty || oneTime.isNotEmpty || earliestClass != null;
});

class TonightScreen extends ConsumerStatefulWidget {
  const TonightScreen({super.key});

  @override
  ConsumerState<TonightScreen> createState() => _TonightScreenState();
}

class _TonightScreenState extends ConsumerState<TonightScreen> {
  bool? _notificationsOk;
  late final AppLifecycleListener _lifecycle;
  late final Timer _minuteTick;
  StreamSubscription<Uri?>? _widgetTaps;
  late final _notifications = ref.read(notificationServiceProvider);

  /// Chips picked since the plan was last loaded.
  Set<DayActivityKind>? _picked;
  DateTime? _pickedFor;

  /// True after the app is (re)opened, until answered. Pressing the button
  /// during this visit doesn't count as coming back.
  bool _cameBack = true;

  @override
  void initState() {
    super.initState();
    if (ref.read(platformCapabilitiesProvider).homeWidget) {
      _widgetTaps = widgetTaps().listen((_) {
        if (!mounted) return;
        Navigator.of(context).popUntil((route) => route.isFirst);
        ref.read(selectedTabIndexProvider.notifier).state = 0;
      }, onError: (_) {});
    }
    _notifications.routineRequested.addListener(_onRoutineRequested);
    _checkPermissions();
    _minuteTick = Timer.periodic(const Duration(seconds: 20), (_) {
      if (mounted) setState(() {});
    });
    // Coming back from the background counts as opening the app: the day may
    // have changed, and permissions may have been switched off meanwhile.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        setState(() => _cameBack = true);
        ref.invalidate(tonightPlanProvider);
        _checkPermissions();
      },
    );
  }

  @override
  void dispose() {
    _notifications.routineRequested.removeListener(_onRoutineRequested);
    _widgetTaps?.cancel();
    _minuteTick.cancel();
    _lifecycle.dispose();
    super.dispose();
  }

  /// "เริ่มท่าก่อนนอน" tapped on a reminder.
  Future<void> _onRoutineRequested() async {
    if (!_notifications.routineRequested.value) return;
    _notifications.routineRequested.value = false;
    final plan = await ref.read(tonightPlanProvider.future);
    if (!mounted || !plan.routineEnabled) return;
    Navigator.of(context).popUntil((route) => route.isFirst);
    ref.read(selectedTabIndexProvider.notifier).state = 0;
    await _startRoutine(plan);
  }

  Future<void> _checkPermissions() async {
    final ok = await ref
        .read(permissionsServiceProvider)
        .hasNotificationsPermission();
    if (mounted) setState(() => _notificationsOk = ok);
  }

  @override
  Widget build(BuildContext context) {
    final hasSchedule = ref.watch(_hasAnyScheduleProvider);
    // A task changed: its phone reminder has to follow.
    ref.listen(eveningTasksStreamProvider, (previous, next) {
      if (previous?.hasValue != true) return;
      if (ref.read(platformCapabilitiesProvider).localNotifications &&
          ref.read(settingsStreamProvider).value?.notifyDeadline == true) {
        ref.invalidate(tonightPlanProvider);
      }
    });
    final planAsync = ref.watch(tonightPlanProvider);

    return Scaffold(
      appBar: AppBar(
        // The one place that uses the wordmark font (THEME.md).
        title: const Text(
          'Glow',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share),
            tooltip: 'แชร์บัตร',
            onPressed: _shareCard,
          ),
          const SettingsButton(),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(tonightPlanProvider),
        child: ListView(
          padding: const EdgeInsets.all(GlowSpacing.pageMargin),
          children: [
            if (_notificationsOk == false) ...[
              const WarningBar(
                severity: WarningBarSeverity.red,
                message:
                    'สิทธิ์แจ้งเตือนถูกปิดอยู่ แจ้งเตือนจะไม่ทำงาน '
                    'เปิดได้ในตั้งค่าเครื่อง',
              ),
              const SizedBox(height: GlowSpacing.md),
            ],
            // The centre of the home screen. Tapping it opens dressing up.
            MyStudentCard(
              onTap: () =>
                  ref.read(selectedTabIndexProvider.notifier).state = 3,
            ),
            const SizedBox(height: GlowSpacing.lg),
            if (!hasSchedule)
              const _EmptyScheduleCard()
            else
              planAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('เกิดข้อผิดพลาด: $e'),
                data: _buildPlan,
              ),
            if (hasSchedule &&
                ref.watch(platformCapabilitiesProvider).calendarReminders) ...[
              const SizedBox(height: GlowSpacing.lg),
              const WebReminderBars(),
            ],
          ],
        ),
      ),
    );
  }

  void _shareCard() {
    final monday = mondayOfWeek(
      resolveTonightWakeDate(ref.read(clockProvider)()),
    );
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => ShareScreen(monday: monday)));
  }

  bool _canPressInBed(TonightPlanData plan) => canPressInBed(
    now: ref.read(clockProvider)(),
    notifyTime: NightPlanningRepository.notifyTimeOf(plan.draft),
    plannedWakeTime: plan.draft.wakeTime,
  );

  bool _asksIfStillUp(TonightPlanData plan) {
    if (!_cameBack || plan.inBedAt == null) return false;
    return ref
        .read(clockProvider)()
        .isBefore(bedPressWindowEnd(plan.draft.wakeTime));
  }

  /// "เข้านอนแล้ว". It is the screen's main button, except while a check-in
  /// card above it holds that place.
  Widget _buildBedButton(TonightPlanData plan, {required bool isMain}) {
    final textTheme = Theme.of(context).textTheme;
    final pressedAt = plan.inBedAt;
    final canPress = _canPressInBed(plan);
    final canUndo =
        pressedAt != null &&
        canUndoInBed(pressedAt: pressedAt, now: ref.read(clockProvider)());
    final opensAt = bedPressWindowStart(
      NightPlanningRepository.notifyTimeOf(plan.draft),
    );
    final label = pressedAt == null
        ? 'เข้านอนแล้ว'
        : 'เข้านอนแล้ว · ${_formatTime(pressedAt)}';
    final onPressed = pressedAt == null && canPress
        ? () => _goToBed(plan)
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isMain)
          GlowPrimaryButton(label: label, onPressed: onPressed)
        else
          OutlinedButton(onPressed: onPressed, child: Text(label)),
        if (pressedAt == null && !canPress)
          Padding(
            padding: const EdgeInsets.only(top: GlowSpacing.xs),
            child: Text(
              'ปุ่มเข้านอนกดได้ตั้งแต่ ${_formatTime(opensAt)}',
              textAlign: TextAlign.center,
              style: textTheme.labelSmall,
            ),
          ),
        if (canUndo)
          TextButton(
            onPressed: () => _undoInBed(plan),
            child: const Text('ยังไม่นอน'),
          ),
      ],
    );
  }

  /// Below the card: tonight's bedtime, one line of why, and the button.
  /// Everything else is folded away.
  Widget _buildPlan(TonightPlanData plan) {
    if (_pickedFor != plan.wakeDate) {
      _pickedFor = plan.wakeDate;
      _picked = null;
    }
    final pending = plan.pendingCheckIn;
    if (pending != null) {
      // An unanswered check-in stays open until 14:00 the next day; it must
      // not hide tonight's button once the evening comes round again. While
      // the card is about this same night, it replaces the button.
      final showBedButton =
          pending.wakeDate != plan.wakeDate &&
          (plan.inBedAt != null || _canPressInBed(plan));
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckInCard(
            key: ValueKey(pending.wakeDate),
            pending: pending,
            onSubmitted: (result, fireBefore, fireAfter) {
              ref.invalidate(tonightPlanProvider);
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CheckInResultScreen(
                    wakeDate: pending.wakeDate,
                    result: result,
                    fireBefore: fireBefore,
                    fireAfter: fireAfter,
                  ),
                ),
              );
            },
          ),
          if (showBedButton) ...[
            const SizedBox(height: GlowSpacing.lg),
            _buildBedButton(plan, isMain: false),
          ],
          const SizedBox(height: GlowSpacing.lg),
          _weekFold(plan),
        ],
      );
    }

    final showRoutine =
        plan.inBedAt == null &&
        plan.routineEnabled &&
        !ref.read(clockProvider)().isBefore(plan.activityCardFrom);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_asksIfStillUp(plan)) ...[
          _StillUpBar(
            onMove: () => _goToBed(plan),
            onDismiss: () => setState(() => _cameBack = false),
          ),
          const SizedBox(height: GlowSpacing.md),
        ],
        _TonightTime(plan: plan),
        const SizedBox(height: GlowSpacing.md),
        _buildBedButton(plan, isMain: true),
        const SizedBox(height: GlowSpacing.xl),
        ..._notices(plan),
        if (showRoutine) ...[
          GlowFold(
            icon: Icons.self_improvement,
            title: 'ท่าก่อนนอน',
            summary: plan.routineDone
                ? 'ทำแล้ว'
                : 'ประมาณ ${_routineMinutes(plan)} นาที',
            child: ActivityCard(
              key: ValueKey(plan.wakeDate),
              selected: _picked ?? plan.activities,
              confirmed: plan.activitiesConfirmed,
              onConfirm: () =>
                  _saveActivities(plan, _picked ?? plan.activities),
              done: plan.routineDone,
              minutes: _routineMinutes(plan),
              onChanged: (value) => setState(() => _picked = value),
              onStart: () => _startRoutine(plan),
            ),
          ),
          const SizedBox(height: GlowSpacing.md),
        ],
        if (plan.eveningEnabled && plan.inBedAt == null) ...[
          GlowFold(
            icon: Icons.checklist,
            title: 'ตารางเย็นนี้',
            child: EveningCard(onOpen: () => _openEvening(plan)),
          ),
          const SizedBox(height: GlowSpacing.md),
        ],
        _weekFold(plan),
      ],
    );
  }

  /// Warnings that shouldn't be folded away: a busy evening, a night the
  /// schedule cuts short, and an exam coming up.
  List<Widget> _notices(TonightPlanData plan) => [
    if (plan.load.level == EveningLoadLevel.yellow) ...[
      WarningBar(
        severity: WarningBarSeverity.yellow,
        message:
            'เย็นนี้แน่น ทำงานให้เสร็จก่อน '
            '${_formatTime(plan.load.notifyTime)}',
        onTap: plan.eveningEnabled ? () => _openEvening(plan) : null,
      ),
      const SizedBox(height: GlowSpacing.md),
    ],
    if (plan.load.level == EveningLoadLevel.red) ...[
      const WarningBar(
        severity: WarningBarSeverity.red,
        message:
            'คืนนั้นนอนครบไม่ได้ตามตาราง ลองย้ายกิจกรรม, '
            'ลดเวลาเตรียมตัววันนั้น, หรือเข้านอนเร็วขึ้นคืนก่อนหน้า',
      ),
      if (plan.adjustablePrepMinutes != null)
        TextButton(
          onPressed: () => _shortenPrep(plan),
          child: const Text('ลดเวลาเตรียมตัวพรุ่งนี้'),
        ),
      const SizedBox(height: GlowSpacing.md),
    ],
    const CountdownStrip(),
  ];

  /// The week's nights, tonight's quests, and "วันนี้หมดแรง".
  Widget _weekFold(TonightPlanData plan) {
    final textTheme = Theme.of(context).textTheme;
    final shields = ref.watch(fireStateStreamProvider).value?.shields ?? 0;
    return GlowFold(
      icon: Icons.emoji_events_outlined,
      title: 'สัปดาห์นี้และเควส',
      summary: 'ผ่าน ${plan.weeklyPassCount}/$weeklyQuestTarget คืน',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _WeekRings(cells: plan.weekCells, tonight: plan.wakeDate),
          const SizedBox(height: GlowSpacing.lg),
          Text(_modeLine(plan), style: textTheme.bodyLarge),
          Text(
            _questLine(plan.mode, routine: plan.routineEnabled),
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: GlowSpacing.sm),
          _QuestProgressDots(count: plan.weeklyPassCount),
          if (shields > 0)
            Text('มีโล่ $shields อัน', style: textTheme.bodyMedium),
          if (plan.canChangeLowEnergy && plan.inBedAt == null)
            TextButton(
              onPressed: () => _toggleLowEnergy(plan),
              child: Text(
                plan.lowEnergy ? 'ยกเลิก "วันนี้หมดแรง"' : 'วันนี้หมดแรง',
              ),
            ),
        ],
      ),
    );
  }

  List<Pose> _routineFor(TonightPlanData plan) => buildRoutine(
    wakeDate: plan.wakeDate,
    activities: _picked ?? plan.activities,
    mode: plan.mode,
    hiddenPoseIds: plan.hiddenPoseIds,
  );

  int _routineMinutes(TonightPlanData plan) {
    final seconds = _routineFor(plan).fold(0, (sum, p) => sum + p.seconds);
    return (seconds / 60).round();
  }

  Future<void> _shortenPrep(TonightPlanData plan) async {
    final usual = ref.read(settingsStreamProvider).value?.prepMinutes ?? 45;
    final picked = await showDurationSheet(
      context,
      title: 'เวลาเตรียมตัวพรุ่งนี้เช้า',
      initial: plan.adjustablePrepMinutes!,
      step: 5,
      min: 0,
      max: usual,
    );
    if (picked == null || !mounted) return;
    await ref
        .read(nightPlanningRepositoryProvider)
        .setPrepOverride(plan.wakeDate, picked == usual ? null : picked);
    if (mounted) ref.invalidate(tonightPlanProvider);
  }

  Future<void> _openEvening(TonightPlanData plan) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EveningScreen(
          onStartRoutine: plan.routineEnabled && plan.inBedAt == null
              ? () => _startRoutine(plan)
              : null,
        ),
      ),
    );
    if (mounted) ref.invalidate(tonightPlanProvider);
  }

  Future<void> _saveActivities(
    TonightPlanData plan,
    Set<DayActivityKind> value,
  ) async {
    await ref
        .read(routineRepositoryProvider)
        .saveActivities(plan.wakeDate, value, confirmed: true);
    if (mounted) ref.invalidate(tonightPlanProvider);
  }

  Future<void> _startRoutine(TonightPlanData plan) async {
    // Starting settles what today involved.
    await ref
        .read(routineRepositoryProvider)
        .saveActivities(
          plan.wakeDate,
          _picked ?? plan.activities,
          confirmed: true,
        );
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => RoutineScreen(
          wakeDate: plan.wakeDate,
          poses: _routineFor(plan),
          mode: plan.mode,
          onInBed: plan.inBedAt == null && _canPressInBed(plan)
              ? () => _goToBed(plan)
              : null,
        ),
      ),
    );
    if (mounted) ref.invalidate(tonightPlanProvider);
  }

  Future<void> _toggleLowEnergy(TonightPlanData plan) async {
    final turningOn = !plan.lowEnergy;
    final changed = await ref
        .read(nightPlanningRepositoryProvider)
        .setLowEnergy(plan.wakeDate, turningOn, now: ref.read(clockProvider)());
    if (!mounted) return;
    ref.invalidate(tonightPlanProvider);
    if (changed && turningOn) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('คืนนี้พักได้ เควสเหลือข้อเดียว: หลับตามแผน'),
        ),
      );
    }
  }

  Future<void> _goToBed(TonightPlanData plan) async {
    setState(() => _cameBack = false);
    final notifications = ref.read(notificationServiceProvider);
    HapticFeedback.lightImpact();
    await ref
        .read(nightPlanningRepositoryProvider)
        .markInBed(plan.wakeDate, ref.read(clockProvider)());
    await notifications.cancelBedtimeNotification(plan.wakeDate);
    if (!mounted) return;
    ref.invalidate(tonightPlanProvider);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('บันทึกแล้ว ฝันดีนะ')));
  }

  Future<void> _undoInBed(TonightPlanData plan) async {
    await ref.read(nightPlanningRepositoryProvider).undoInBed(plan.wakeDate);
    // Reloading also puts the bedtime reminder back.
    if (mounted) ref.invalidate(tonightPlanProvider);
  }
}

/// Shown when Glow is opened again after "เข้านอนแล้ว". It never scolds.
class _StillUpBar extends StatelessWidget {
  final VoidCallback onMove;
  final VoidCallback onDismiss;

  const _StillUpBar({required this.onMove, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlowCard(
      pastel: GlowPastel.lilac,
      padding: const EdgeInsets.all(GlowSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('ยังไม่นอนเหรอ', style: theme.textTheme.bodyLarge),
          Wrap(
            children: [
              TextButton(
                onPressed: onMove,
                child: const Text('เลื่อนเวลาปิดไฟเป็นตอนนี้'),
              ),
              TextButton(
                onPressed: onDismiss,
                child: const Text('แค่เข้ามาดู'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The week's seven nights (THEME.md "วงคืนในสัปดาห์"). Tap one for details.
class _WeekRings extends StatelessWidget {
  final List<HeatmapCell> cells;
  final DateTime tonight;

  const _WeekRings({required this.cells, required this.tonight});

  static const _labels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final cell in cells)
            NightRing(
              dayLabel: _labels[cell.date.weekday - 1],
              result: toSleepResult(cell.checkIn),
              isTonight: cell.date == tonight,
              onTap: () => showGlowBottomSheet(
                context: context,
                builder: (_) => NightDetailSheet(
                  cell: cell,
                  fallAsleepMinutes:
                      ref
                          .read(settingsStreamProvider)
                          .value
                          ?.fallAsleepMinutes ??
                      15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyScheduleCard extends ConsumerWidget {
  const _EmptyScheduleCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GlowCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'ยังไม่มีตารางเรียน ใส่ตารางก่อนเพื่อให้ Glow แนะนำเวลานอนได้',
          ),
          const SizedBox(height: GlowSpacing.md),
          FilledButton(
            onPressed: () =>
                ref.read(selectedTabIndexProvider.notifier).state = 1,
            child: const Text('ไปตั้งตาราง'),
          ),
        ],
      ),
    );
  }
}

/// Tonight's bedtime, large, with one line saying where it comes from.
class _TonightTime extends StatelessWidget {
  final TonightPlanData plan;

  const _TonightTime({required this.plan});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final first = plan.firstAppointment;
    final firstLabel = first == null
        ? 'วันว่าง'
        : first.title == earliestClassTitle
        ? 'เรียนเช้าสุดที่บอกไว้ ${_formatTime(first.start)}'
        : '${switch (first.kind) {
            ItemKind.exam => 'สอบ',
            ItemKind.classSession => 'เรียนคาบแรก',
            _ => 'นัดแรก',
          }} ${_formatTime(first.start)}';

    return Column(
      children: [
        Text('เข้านอนคืนนี้', style: textTheme.bodyMedium),
        Text(_formatTime(plan.draft.bedtime), style: textTheme.displayLarge),
        Text(
          'ตื่น ${_formatTime(plan.draft.wakeTime)} · $firstLabel',
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

String _modeLine(TonightPlanData plan) => switch (plan.mode) {
  QuestMode.normal => 'คืนนี้โหมดปกติ',
  QuestMode.light => 'คืนนี้โหมดเบา: เย็นนี้แน่น ท่าก่อนนอนเป็นชุดสั้น',
  QuestMode.minimum =>
    plan.lowEnergy
        ? 'คืนนี้โหมดขั้นต่ำ: พักได้ เควสเหลือข้อเดียว'
        : 'คืนนี้โหมดขั้นต่ำ: ตารางแน่น เควสเหลือข้อเดียว',
};

String _questLine(QuestMode mode, {required bool routine}) =>
    mode == QuestMode.minimum
    ? 'หลับตามแผน +${EconomyConfig.sleepOnPlanCoins} เหรียญ'
    : [
        'นอนครบ +${EconomyConfig.dailyCompleteCoins}',
        'ตรงเวลา +${EconomyConfig.dailyOnTimeBonusCoins}',
        if (routine) 'ท่าก่อนนอน +${EconomyConfig.routineCoins}',
      ].join(' · ');

/// ●●●○○ weekly "ตรงเวลา 5 ใน 7" quest progress (CLAUDE.md section 8).
class _QuestProgressDots extends StatelessWidget {
  final int count;
  const _QuestProgressDots({required this.count});

  @override
  Widget build(BuildContext context) {
    final target = weeklyQuestTarget;
    final filled = count.clamp(0, target);
    final accent = Theme.of(context).colorScheme.primary;
    final empty = Theme.of(context).dividerColor;
    return Row(
      children: [
        for (var i = 0; i < target; i++)
          Padding(
            padding: const EdgeInsets.only(right: GlowSpacing.xs),
            child: Icon(
              Icons.circle,
              size: 12,
              color: i < filled ? accent : empty,
            ),
          ),
        const SizedBox(width: GlowSpacing.xs),
        Expanded(
          child: Text(
            'ผ่าน $count/$target คืนสัปดาห์นี้',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

String _formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
