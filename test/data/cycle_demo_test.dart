/// The demo cases for the cycle bar give the numbers their names promise.
library;

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/demo/demo_data.dart';

void main() {
  // Tonight ends on Wednesday 2026-12-02.
  final today = DateTime(2026, 12, 1);
  DateTime evening(int hour, int minute) =>
      DateTime(2026, 12, 1, hour, minute);

  // Bedtime, minutes earlier, and minutes asleep.
  final expected = {
    CycleDemo.sixCycles: (evening(21, 15), 30, 540),
    CycleDemo.overTarget: (evening(21, 45), 0, 510),
    CycleDemo.beforeExam: (evening(21, 15), 30, 540),
    CycleDemo.shortCycle: (evening(20, 55), 50, 560),
    CycleDemo.longCycle: (evening(20, 15), 90, 600),
  };

  for (final demo in CycleDemo.values) {
    test(demo.name, () async {
      final db = AppDatabase.forTesting(NativeDatabase.memory());
      await resetCycleDemo(db, today, demo);
      final planning = NightPlanningRepository(
        db,
        ScheduleRepository(db),
        SettingsRepository(db),
      );
      final draft = await planning.computeDraftForWakeDate(
        DateTime(2026, 12, 2),
      );
      final cycles = await planning.cyclesFor(draft);
      final (bedtime, shift, sleep) = expected[demo]!;
      expect(draft.wakeTime, DateTime(2026, 12, 2, 6, 30));
      expect(draft.bedtime, bedtime);
      expect((cycles.shiftMinutes, cycles.sleepMinutes), (shift, sleep));
      expect(cycles.cycleMinutes, demo.cycleMinutes);
      expect(draft.isPreExamNight, demo.exam);
      await db.close();
    });
  }
}
