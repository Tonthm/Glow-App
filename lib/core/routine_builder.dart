/// Picks tonight's stretches (CLAUDE.md section 13). Rules only, no AI.
library;

import 'dart:math';

import 'quests.dart';
import 'routine_config.dart';

int stretchCountFor(QuestMode mode) => switch (mode) {
  QuestMode.normal => 4,
  QuestMode.light => 2,
  QuestMode.minimum => 0,
};

/// The poses for the night ending on [wakeDate], ordered standing, sitting,
/// lying, and always ending with slow breathing. The same date and choices
/// give the same routine; another date may pick other poses.
List<Pose> buildRoutine({
  required DateTime wakeDate,
  required Set<DayActivityKind> activities,
  required QuestMode mode,
  Set<String> hiddenPoseIds = const {},
}) {
  final wanted = stretchCountFor(mode);
  final random = Random(
    wakeDate.year * 10000 + wakeDate.month * 100 + wakeDate.day,
  );

  // Parts used by several activities come first.
  final scores = <BodyPart, int>{};
  for (final activity in DayActivityKind.values) {
    if (!activities.contains(activity)) continue;
    for (final part in activityParts[activity]!) {
      scores[part] = (scores[part] ?? 0) + 1;
    }
  }
  if (scores.isEmpty) {
    for (final part in generalParts) {
      scores[part] = 1;
    }
  }

  final available = [
    for (final pose in poseLibrary)
      if (!hiddenPoseIds.contains(pose.id)) pose,
  ];

  final shuffled = BodyPart.values.toList()..shuffle(random);
  final tieBreak = {for (var i = 0; i < shuffled.length; i++) shuffled[i]: i};
  final ranked = BodyPart.values.toList()
    ..sort((a, b) {
      final byScore = (scores[b] ?? 0).compareTo(scores[a] ?? 0);
      return byScore != 0 ? byScore : tieBreak[a]!.compareTo(tieBreak[b]!);
    });

  final picked = <Pose>[];
  // One pose per part, wanted parts before the others, so a part is only
  // repeated when no other part is left.
  for (final part in ranked) {
    if (picked.length == wanted) break;
    final options = available.where((p) => p.part == part).toList();
    if (options.isEmpty) continue;
    picked.add(options[random.nextInt(options.length)]);
  }
  if (picked.length < wanted) {
    final leftovers = available.where((p) => !picked.contains(p)).toList()
      ..shuffle(random);
    picked.addAll(leftovers.take(wanted - picked.length));
  }

  picked.sort((a, b) => a.position.index.compareTo(b.position.index));
  return [...picked, breathingPose];
}

/// The routine quest is met when the set was finished with at most one pose
/// skipped.
bool routineCountsAsDone({required int total, required int skipped}) =>
    total > 0 && skipped <= 1 && skipped < total;
