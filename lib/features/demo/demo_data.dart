/// Debug-only data for walking through the app on stage. Only reached from
/// code guarded by kDebugMode, so release builds drop it.
library;

import 'dart:math';

import 'package:drift/drift.dart';

import '../../core/economy_config.dart';
import '../../core/night_date.dart';
import '../../data/database.dart';
import '../../data/settings_repository.dart';
import '../../data/subject_color_repository.dart';
import '../../services/backup_service.dart';
import '../../theme/tokens.dart';

/// The demo starts here: late enough that pressing "เข้านอนแล้ว" gives a
/// full night that is also on time.
const int demoStartHour = 21;
const int demoStartMinute = 30;

DateTime _day(DateTime base, int offset, [int hour = 0, int minute = 0]) =>
    DateTime(base.year, base.month, base.day + offset, hour, minute);

/// Wipes everything and builds the demo state around [today]:
/// a week of classes, a red night tomorrow evening, 60 nights of history,
/// fire one point short of level 3, and coins for one blanket.
Future<void> resetDemoData(AppDatabase db, DateTime today) async {
  final start = _day(today, 0, demoStartHour, demoStartMinute);
  await db.transaction(() async {
    await BackupService(db).deleteAllData();
    final settings = SettingsRepository(db);
    await settings.ensureRowExists();
    await settings.markOnboardingCompleted(start);
    await _addSchedule(db, today);
    await _addHistory(db, today);
    await _addRewards(db, today);
    await _addSubjectColors(db);
    await _addTasksAndExam(db, today);
  });
}

/// Cases for checking the cycle bar. All wake at 06:30.
enum CycleDemo {
  sixCycles(
    'เป้า 8–9 ชม. ปัดเป็น 6 รอบได้',
    targetMin: 480,
    targetMax: 540,
  ),
  overTarget(
    'เป้า 8–8:45 ปัดแล้วเกิน จึงคงเดิม',
    targetMin: 480,
    targetMax: 525,
  ),
  beforeExam(
    'คืนก่อนสอบ เป้า 8–9 ชม.',
    targetMin: 480,
    targetMax: 540,
    exam: true,
  ),
  shortCycle(
    'รอบ 70 นาที เป้า 8–10 ชม.',
    targetMin: 480,
    targetMax: 600,
    cycleMinutes: 70,
  ),
  longCycle(
    'รอบ 100 นาที เป้า 8–10 ชม.',
    targetMin: 480,
    targetMax: 600,
    cycleMinutes: 100,
  );

  final String label;
  final int targetMin;
  final int targetMax;
  final int cycleMinutes;
  final bool exam;

  const CycleDemo(
    this.label, {
    required this.targetMin,
    required this.targetMax,
    this.cycleMinutes = 90,
    this.exam = false,
  });
}

/// Wipes everything and sets up one [CycleDemo] around [today]: a class at
/// 07:55 every day, so every wake time is 06:30.
Future<void> resetCycleDemo(
  AppDatabase db,
  DateTime today,
  CycleDemo demo,
) async {
  await db.transaction(() async {
    await BackupService(db).deleteAllData();
    final settings = SettingsRepository(db);
    await settings.ensureRowExists();
    await settings.markOnboardingCompleted(
      _day(today, 0, demoStartHour - 3),
    );
    await settings.updateTargetHours(
      minMinutes: demo.targetMin,
      maxMinutes: demo.targetMax,
    );
    await settings.updateCycles(minutes: demo.cycleMinutes);
    for (var day = DateTime.monday; day <= DateTime.sunday; day++) {
      await db
          .into(db.weeklyItems)
          .insert(
            WeeklyItemsCompanion.insert(
              title: 'คณิตศาสตร์',
              dayOfWeek: day,
              startMinutes: 7 * 60 + 55,
              endMinutes: 12 * 60,
              type: WeeklyItemType.classSession,
            ),
          );
    }
    if (demo.exam) {
      await db
          .into(db.oneTimeItems)
          .insert(
            OneTimeItemsCompanion.insert(
              title: 'สอบกลางภาค ฟิสิกส์',
              date: _day(today, 1),
              type: OneTimeItemType.exam,
              // In the afternoon: an exam over the morning class would
              // replace it and change the wake time.
              startMinutes: const Value(13 * 60),
              endMinutes: const Value(15 * 60),
            ),
          );
    }
  });
}

Future<void> _addSubjectColors(AppDatabase db) async {
  const colors = {
    'คณิตศาสตร์': 'ม่วง',
    'ฟิสิกส์': 'น้ำเงิน',
    'ภาษาอังกฤษ': 'ชมพู',
    'เคมี': 'เขียว',
    'ชีวะ': 'เหลือง',
    'ภาษาไทย': 'ส้ม',
  };
  final repo = SubjectColorRepository(db);
  for (final entry in colors.entries) {
    await repo.set(entry.key, GlowSubjectColors.all[entry.value]);
  }
}

/// One task of each kind the list can show, one with steps half done, and an
/// exam close enough to count down to.
Future<void> _addTasksAndExam(AppDatabase db, DateTime today) async {
  Future<int> task(String title, int minutes, int due, {bool done = false}) =>
      db
          .into(db.eveningTasks)
          .insert(
            EveningTasksCompanion.insert(
              title: title,
              minutes: minutes,
              kind: 0,
              planDate: _day(today, done ? -2 : 0),
              dueDate: Value(_day(today, due)),
              status: Value(done ? 1 : 0),
              doneMinutes: Value(done ? minutes : 0),
            ),
          );
  final report = await task('รายงานชีวะ', 60, 3);
  await task('ภาษาอังกฤษ', 30, 1);
  await task('ใบงานสังคม', 20, -1);
  await task('แบบฝึกหัดเคมี', 30, -1, done: true);
  const steps = [
    'หาข้อมูล',
    'ทำโครงร่าง',
    'เขียนเนื้อหา',
    'ใส่รูป',
    'ตรวจทาน',
  ];
  for (var i = 0; i < steps.length; i++) {
    await db
        .into(db.taskSteps)
        .insert(
          TaskStepsCompanion.insert(
            taskId: report,
            title: steps[i],
            position: i + 1,
            done: Value(i < 2),
          ),
        );
  }
  await db
      .into(db.oneTimeItems)
      .insert(
        OneTimeItemsCompanion.insert(
          title: 'สอบกลางภาค ฟิสิกส์',
          date: _day(today, 5),
          type: OneTimeItemType.exam,
          startMinutes: const Value(9 * 60),
          endMinutes: const Value(11 * 60),
        ),
      );
}

Future<void> _addSchedule(AppDatabase db, DateTime today) async {
  Future<void> weekly(String title, int day, int from, int to) => db
      .into(db.weeklyItems)
      .insert(
        WeeklyItemsCompanion.insert(
          title: title,
          dayOfWeek: day,
          startMinutes: from * 60,
          endMinutes: to * 60,
          type: WeeklyItemType.classSession,
        ),
      );
  const mornings = ['คณิตศาสตร์', 'ฟิสิกส์', 'ภาษาอังกฤษ', 'เคมี', 'ชีวะ'];
  const afternoons = ['ภาษาไทย', 'สังคม', 'พละ', 'ศิลปะ', 'คอมพิวเตอร์'];
  for (var day = DateTime.monday; day <= DateTime.friday; day++) {
    await weekly(mornings[day - 1], day, 8, 12);
    await weekly(afternoons[day - 1], day, 13, 15);
  }

  Future<void> once(String title, DateTime date, int from, int to) => db
      .into(db.oneTimeItems)
      .insert(
        OneTimeItemsCompanion.insert(
          title: title,
          date: date,
          type: OneTimeItemType.activity,
          startMinutes: Value(from * 60),
          endMinutes: Value(to * 60),
        ),
      );
  // If the demo falls near a weekend, keep the next mornings early too, so
  // the story plays the same on any day.
  for (var ahead = 1; ahead <= 2; ahead++) {
    final date = _day(today, ahead);
    if (date.weekday > DateTime.friday) {
      await once('เรียนพิเศษ', date, 8, 12);
    }
  }
  // Tomorrow evening runs past bedtime: that night is red.
  await once('ซ้อมละครเวที', _day(today, 1), 19, 23);
}

Future<void> _addHistory(AppDatabase db, DateTime today) async {
  // A fixed seed gives the same heatmap on every reset.
  final random = Random(70);
  final monday = mondayOfWeek(today);
  var passedThisWeek = 0;

  for (var ago = 59; ago >= 0; ago--) {
    final wakeDate = _day(today, -ago);
    final bedtime = _day(wakeDate, -1, 21, 50);
    final wake = _day(wakeDate, 0, 6, 35);

    final roll = random.nextDouble();
    // The most recent week is a good one, to match the current streak.
    final result = ago < 7 || roll < 0.68
        ? CheckInResultDb.enough
        : roll < 0.84
        ? CheckInResultDb.almostEnough
        : roll < 0.93
        ? CheckInResultDb.notEnough
        : CheckInResultDb.over;
    final slept = switch (result) {
      CheckInResultDb.enough => 485 + random.nextInt(80),
      CheckInResultDb.almostEnough => 430 + random.nextInt(40),
      CheckInResultDb.notEnough => 330 + random.nextInt(80),
      CheckInResultDb.over => 610 + random.nextInt(40),
    };
    final lightsOff = wake.subtract(Duration(minutes: slept + 15));
    var onTime = lightsOff.difference(bedtime).inMinutes.abs() <= 45;
    // Leave this week's big quest unfinished, with room to grow.
    if (!wakeDate.isBefore(monday)) {
      if (onTime && result == CheckInResultDb.enough && passedThisWeek >= 2) {
        onTime = false;
      } else if (onTime && result == CheckInResultDb.enough) {
        passedThisWeek++;
      }
    }

    await db
        .into(db.nightPlans)
        .insert(
          NightPlansCompanion.insert(
            wakeDate: wakeDate,
            plannedWakeAt: wake,
            plannedBedtimeAt: bedtime,
            isPreExamNight: Value(ago % 23 == 11),
            isLocked: const Value(true),
            lockedAt: Value(bedtime.subtract(const Duration(hours: 1))),
            fireAppliedAt: Value(wake),
            inBedAt: Value(lightsOff),
            questMode: const Value(0),
          ),
        );
    // A few nights with no data keep the heatmap honest.
    if (ago > 7 && random.nextDouble() < 0.06) continue;
    await db
        .into(db.checkIns)
        .insert(
          CheckInsCompanion.insert(
            wakeDate: wakeDate,
            lightsOffAt: lightsOff,
            actualWakeAt: wake,
            result: result,
            onTime: onTime,
            usedShield: Value(
              result == CheckInResultDb.notEnough && ago % 2 == 0,
            ),
            checkedInAt: wake.add(const Duration(minutes: 20)),
            pressedInBed: const Value(true),
          ),
        );
  }

  // Last week's reward counts as already given.
  await db
      .into(db.weeklyQuestProgresses)
      .insert(
        WeeklyQuestProgressesCompanion.insert(
          weekStart: _day(monday, -7),
          rewardClaimed: const Value(true),
        ),
      );
}

Future<void> _addRewards(AppDatabase db, DateTime today) async {
  // Level 2 with 6 points: one more full night reaches level 3.
  await db
      .into(db.fireStates)
      .insert(
        FireStatesCompanion(
          id: const Value(0),
          points: const Value(6),
          level: const Value(2),
          shields: const Value(1),
          maxLevelEverReached: const Value(2),
          currentStreak: const Value(6),
          longestStreak: const Value(12),
          lastFreeShieldMonday: Value(mondayOfWeek(today)),
        ),
      );
  await db
      .into(db.wallets)
      .insert(
        WalletsCompanion(
          id: const Value(0),
          coins: Value(EconomyConfig.blankets.first.priceCoins),
        ),
      );
  // A card that already looks like someone's.
  await db
      .into(db.cardProfiles)
      .insert(
        const CardProfilesCompanion(
          id: Value(0),
          displayName: Value('น้องมายด์'),
          school: Value('โรงเรียนตัวอย่างวิทยา'),
          classYear: Value('ม.5'),
          stickerIds: Value('sticker_star'),
        ),
      );
  await db
      .into(db.ownedItems)
      .insert(
        OwnedItemsCompanion.insert(
          itemId: 'sticker_star',
          acquiredAt: _day(today, -12),
        ),
      );
  for (var level = 1; level <= 2; level++) {
    await db
        .into(db.ownedItems)
        .insert(
          OwnedItemsCompanion.insert(
            itemId: EconomyConfig.fireLevelRewardBlankets[level]!.id,
            acquiredAt: _day(today, -10),
          ),
        );
  }
}
