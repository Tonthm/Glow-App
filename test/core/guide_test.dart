/// What the guide may lead to, and the starter checklist (CLAUDE.md section
/// 21).
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/guide.dart';

const _all = GuideAccess(
  eveningEnabled: true,
  routineEnabled: true,
  aiVisible: true,
);

void main() {
  group('destinations', () {
    test('everything is open when nothing is switched off', () {
      for (final destination in Destination.values) {
        expect(canOpen(destination, _all), isTrue, reason: destination.name);
      }
    });

    Set<Destination> closed(GuideAccess access) => {
      for (final destination in Destination.values)
        if (!canOpen(destination, access)) destination,
    };

    test('a switched-off evening hides the evening and adding tasks', () {
      expect(
        closed(
          const GuideAccess(
            eveningEnabled: false,
            routineEnabled: true,
            aiVisible: true,
          ),
        ),
        {Destination.evening, Destination.addTask},
      );
    });

    test('a switched-off routine hides the routine', () {
      expect(
        closed(
          const GuideAccess(
            eveningEnabled: true,
            routineEnabled: false,
            aiVisible: true,
          ),
        ),
        {Destination.routine},
      );
    });

    test('hidden AI hides its settings and the picture import', () {
      expect(
        closed(
          const GuideAccess(
            eveningEnabled: true,
            routineEnabled: true,
            aiVisible: false,
          ),
        ),
        {Destination.aiSettings, Destination.importPicture},
      );
    });
  });

  group('starter checklist', () {
    test('has five steps, and none for a switched-off feature', () {
      expect(checklistSteps(_all), ChecklistStep.values);
      expect(ChecklistStep.values, hasLength(5));
      expect(
        checklistSteps(
          const GuideAccess(
            eveningEnabled: false,
            routineEnabled: false,
            aiVisible: false,
          ),
        ),
        [ChecklistStep.schedule, ChecklistStep.viewPlan, ChecklistStep.checkIn],
      );
    });

    test('ticks come from what the user really did', () {
      expect(
        stepsDoneBy(
          hasSchedule: false,
          hasEveningTask: false,
          hasRoutineRun: false,
          hasCheckIn: false,
        ),
        isEmpty,
      );
      expect(
        stepsDoneBy(
          hasSchedule: true,
          hasEveningTask: false,
          hasRoutineRun: true,
          hasCheckIn: false,
        ),
        {ChecklistStep.schedule, ChecklistStep.routine},
      );
    });

    test('shows until finished or closed', () {
      bool shows(Set<ChecklistStep> done, {bool dismissed = false}) =>
          showsChecklist(
            steps: checklistSteps(_all),
            done: done,
            dismissed: dismissed,
          );
      expect(shows({}), isTrue);
      expect(shows({ChecklistStep.schedule}), isTrue);
      expect(shows(ChecklistStep.values.toSet()), isFalse);
      expect(shows({}, dismissed: true), isFalse);
    });

    test('a switched-off step is not needed to finish', () {
      const access = GuideAccess(
        eveningEnabled: false,
        routineEnabled: false,
        aiVisible: false,
      );
      expect(
        showsChecklist(
          steps: checklistSteps(access),
          done: {
            ChecklistStep.schedule,
            ChecklistStep.viewPlan,
            ChecklistStep.checkIn,
          },
          dismissed: false,
        ),
        isFalse,
      );
    });

    test('saved steps survive unknown names', () {
      final saved = encodeSteps({ChecklistStep.checkIn, ChecklistStep.routine});
      expect(parseSteps(saved), {ChecklistStep.routine, ChecklistStep.checkIn});
      expect(parseSteps(''), isEmpty);
      expect(parseSteps('viewPlan,somethingNew'), {ChecklistStep.viewPlan});
    });
  });
}
