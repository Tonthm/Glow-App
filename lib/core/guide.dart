/// The in-app guide (CLAUDE.md section 21): where it can lead, and the
/// "เริ่มต้นใช้งาน" checklist.
library;

/// Every place the guide, the tour and the checklist can lead to.
enum Destination {
  sleep,
  schedule,
  stats,
  card,
  evening,
  routine,
  addTask,
  addClass,
  importPicture,
  speakTimetable,
  editCard,
  shareStory,
  aiSettings,
  backup,
}

/// What this user can get into right now.
class GuideAccess {
  final bool eveningEnabled;
  final bool routineEnabled;

  /// False where there is no AI at all, or it is hidden because of age.
  final bool aiVisible;

  const GuideAccess({
    required this.eveningEnabled,
    required this.routineEnabled,
    required this.aiVisible,
  });
}

/// Nothing may lead to a place the user can't get into.
bool canOpen(Destination destination, GuideAccess access) =>
    switch (destination) {
      Destination.evening || Destination.addTask => access.eveningEnabled,
      Destination.routine => access.routineEnabled,
      Destination.aiSettings || Destination.importPicture => access.aiVisible,
      _ => true,
    };

enum ChecklistStep { schedule, viewPlan, eveningTask, routine, checkIn }

/// The steps to ask for: none for a feature that is switched off.
List<ChecklistStep> checklistSteps(GuideAccess access) => [
  for (final step in ChecklistStep.values)
    if (switch (step) {
      ChecklistStep.eveningTask => access.eveningEnabled,
      ChecklistStep.routine => access.routineEnabled,
      _ => true,
    })
      step,
];

/// The steps the saved data proves. [ChecklistStep.viewPlan] leaves nothing
/// behind, so the sleep tab records it itself.
Set<ChecklistStep> stepsDoneBy({
  required bool hasSchedule,
  required bool hasEveningTask,
  required bool hasRoutineRun,
  required bool hasCheckIn,
}) => {
  if (hasSchedule) ChecklistStep.schedule,
  if (hasEveningTask) ChecklistStep.eveningTask,
  if (hasRoutineRun) ChecklistStep.routine,
  if (hasCheckIn) ChecklistStep.checkIn,
};

bool showsChecklist({
  required List<ChecklistStep> steps,
  required Set<ChecklistStep> done,
  required bool dismissed,
}) => !dismissed && !done.containsAll(steps);

String encodeSteps(Set<ChecklistStep> steps) => [
  for (final step in ChecklistStep.values)
    if (steps.contains(step)) step.name,
].join(',');

Set<ChecklistStep> parseSteps(String text) {
  final names = text.split(',').toSet();
  return {
    for (final step in ChecklistStep.values)
      if (names.contains(step.name)) step,
  };
}
