import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/quests.dart';
import 'package:glow/core/routine_builder.dart';
import 'package:glow/core/routine_config.dart';

final date = DateTime(2026, 11, 23);

List<Pose> build(
  Set<DayActivityKind> activities, {
  QuestMode mode = QuestMode.normal,
  Set<String> hidden = const {},
  DateTime? on,
}) => buildRoutine(
  wakeDate: on ?? date,
  activities: activities,
  mode: mode,
  hiddenPoseIds: hidden,
);

Set<BodyPart> parts(List<Pose> poses) => {
  for (final p in poses)
    if (p.part != null) p.part!,
};

void main() {
  test('the library has unique ids and 2-3 short steps per pose', () {
    final all = [...poseLibrary, breathingPose];
    expect(all.length, inInclusiveRange(15, 18));
    expect({for (final p in all) p.id}.length, all.length);
    for (final pose in all) {
      expect(pose.steps.length, inInclusiveRange(2, 3), reason: pose.id);
    }
  });

  test('every mapped body part has at least one pose', () {
    final covered = parts(poseLibrary);
    for (final entry in activityParts.entries) {
      expect(covered.containsAll(entry.value), isTrue, reason: '${entry.key}');
    }
  });

  test('one activity: its parts are chosen', () {
    expect(parts(build({DayActivityKind.screen})), {
      BodyPart.neck,
      BodyPart.shoulders,
      BodyPart.upperBack,
      BodyPart.wrists,
    });
  });

  test('parts shared by several activities are always chosen', () {
    // running and sport share calves, quads, hamstrings, ankles.
    for (var day = 1; day <= 14; day++) {
      final routine = build({
        DayActivityKind.running,
        DayActivityKind.sport,
      }, on: DateTime(2026, 11, day));
      expect(parts(routine), {
        BodyPart.calves,
        BodyPart.quads,
        BodyPart.hamstrings,
        BodyPart.ankles,
      });
    }
  });

  test('nothing picked uses the general set', () {
    expect(parts(build({}, mode: QuestMode.light)), {
      BodyPart.neck,
      BodyPart.lowerBack,
    });
  });

  test('pose count follows the night mode', () {
    final activities = {DayActivityKind.sitting};
    expect(build(activities).length, 5);
    expect(build(activities, mode: QuestMode.light).length, 3);
    expect(build(activities, mode: QuestMode.minimum), [breathingPose]);
  });

  test('no two poses stretch the same part', () {
    for (var day = 1; day <= 28; day++) {
      final routine = build({
        DayActivityKind.relaxed,
      }, on: DateTime(2026, 11, day));
      expect(parts(routine).length, routine.length - 1);
    }
  });

  test('hidden poses are never chosen, even if a part has none left', () {
    const hidden = {
      'childs_pose',
      'knees_to_chest',
      'lying_twist',
      'neck_side',
    };
    final routine = build({DayActivityKind.relaxed}, hidden: hidden);
    expect(routine.any((p) => hidden.contains(p.id)), isFalse);
    expect(routine.length, 5);
  });

  test('hiding every stretch still ends with breathing', () {
    final hidden = {for (final p in poseLibrary) p.id};
    expect(build({DayActivityKind.sport}, hidden: hidden), [breathingPose]);
  });

  test('the same day gives the same set', () {
    final activities = {DayActivityKind.sitting, DayActivityKind.screen};
    expect(build(activities), build(activities));
  });

  test('another day may pick another pose for the same part', () {
    final lowerBackPoses = {
      for (var day = 1; day <= 28; day++)
        build(
          {DayActivityKind.standing},
          on: DateTime(2026, 11, day),
        ).firstWhere((p) => p.part == BodyPart.lowerBack).id,
    };
    expect(lowerBackPoses, {'childs_pose', 'knees_to_chest', 'lying_twist'});
  });

  test('order is standing, sitting, lying, then breathing last', () {
    for (var day = 1; day <= 28; day++) {
      final routine = build({
        DayActivityKind.sport,
        DayActivityKind.screen,
      }, on: DateTime(2026, 11, day));
      expect(routine.last, breathingPose);
      final positions = [for (final p in routine) p.position.index];
      expect(positions, [...positions]..sort());
    }
  });

  test('finishing allows at most one skipped pose', () {
    expect(routineCountsAsDone(total: 5, skipped: 0), isTrue);
    expect(routineCountsAsDone(total: 5, skipped: 1), isTrue);
    expect(routineCountsAsDone(total: 5, skipped: 2), isFalse);
    expect(routineCountsAsDone(total: 1, skipped: 1), isFalse);
  });
}
