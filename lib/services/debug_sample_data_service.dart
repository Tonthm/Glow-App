import 'dart:math';

import 'package:drift/drift.dart';

import '../data/database.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Debug-only: fills in [nights] days of fake check-ins (and the night-plan
/// rows the heatmap reads isPreExamNight from) so the heatmap has something
/// to show without waiting weeks of real use (PROMPTS.md phase 2 step 8).
/// Writes CheckIns/NightPlans directly — deliberately does not touch
/// FireStates, so it can't be used to inflate a real streak.
class DebugSampleDataService {
  final AppDatabase db;

  DebugSampleDataService(this.db);

  Future<void> generateSampleNights(DateTime now, {int nights = 60}) async {
    final random = Random();
    final today = _dateOnly(now);

    for (var i = 1; i <= nights; i++) {
      final wakeDate = today.subtract(Duration(days: i));
      final isPreExamNight = random.nextDouble() < 0.1;
      final plannedBedtime = wakeDate
          .subtract(const Duration(days: 1))
          .add(const Duration(hours: 22, minutes: 0));
      final plannedWake = wakeDate.add(const Duration(hours: 6, minutes: 30));

      await db
          .into(db.nightPlans)
          .insert(
            mode: InsertMode.insertOrReplace,
            NightPlansCompanion.insert(
              wakeDate: wakeDate,
              plannedWakeAt: plannedWake,
              plannedBedtimeAt: plannedBedtime,
              isPreExamNight: Value(isPreExamNight),
              isLocked: const Value(true),
              lockedAt: Value(
                plannedBedtime.subtract(const Duration(hours: 1)),
              ),
              fireAppliedAt: Value(now),
            ),
          );

      // Skip ~10% of nights entirely so "ไม่มีข้อมูล" shows up too.
      if (random.nextDouble() < 0.1) continue;

      final roll = random.nextDouble();
      final CheckInResultDb result;
      if (roll < 0.55) {
        result = CheckInResultDb.enough;
      } else if (roll < 0.75) {
        result = CheckInResultDb.almostEnough;
      } else if (roll < 0.9) {
        result = CheckInResultDb.notEnough;
      } else {
        result = CheckInResultDb.over;
      }
      final driftMinutes = random.nextInt(161) - 80; // ±80 min
      final lightsOffAt = plannedBedtime.add(Duration(minutes: driftMinutes));
      final sleepTargetMinutes = switch (result) {
        CheckInResultDb.enough => 480 + random.nextInt(90),
        CheckInResultDb.almostEnough => 420 + random.nextInt(50),
        CheckInResultDb.notEnough => 300 + random.nextInt(100),
        CheckInResultDb.over => 610 + random.nextInt(60),
      };
      final actualWakeAt = lightsOffAt.add(
        Duration(minutes: sleepTargetMinutes + 15),
      );
      final onTime = driftMinutes.abs() <= 45;

      await db
          .into(db.checkIns)
          .insert(
            mode: InsertMode.insertOrReplace,
            CheckInsCompanion.insert(
              wakeDate: wakeDate,
              lightsOffAt: lightsOffAt,
              actualWakeAt: actualWakeAt,
              result: result,
              onTime: onTime,
              usedShield: Value(
                result == CheckInResultDb.notEnough &&
                    random.nextDouble() < 0.3,
              ),
              checkedInAt: actualWakeAt.add(const Duration(minutes: 10)),
            ),
          );
    }
  }
}
