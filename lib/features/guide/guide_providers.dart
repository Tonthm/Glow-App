import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/birth_date.dart';
import '../../core/guide.dart';
import '../../providers.dart';
import '../ai/ai_providers.dart';

/// What this user can get into right now.
final guideAccessProvider = Provider<GuideAccess>((ref) {
  final settings = ref.watch(settingsStreamProvider).value;
  // Asked only where there is AI at all, and hidden until the age is known.
  final age = ref.watch(platformCapabilitiesProvider).aiAssistant
      ? ref.watch(aiAgeProvider).value
      : null;
  return GuideAccess(
    eveningEnabled: settings?.eveningEnabled ?? true,
    routineEnabled: settings?.routineEnabled ?? true,
    aiVisible: age != null && age != AiAgeState.hidden,
  );
});

/// Counts changes to whatever can tick or close the checklist.
final _checklistChangesProvider = StreamProvider.autoDispose<int>((ref) {
  final db = ref.watch(databaseProvider);
  var changes = 0;
  return db
      .tableUpdates(
        TableUpdateQuery.onAllTables([
          db.weeklyItems,
          db.oneTimeItems,
          db.eveningTasks,
          db.routineLogs,
          db.checkIns,
          db.guideStates,
        ]),
      )
      .map((_) => ++changes);
});

typedef ChecklistView = ({Set<ChecklistStep> done, bool dismissed});

final checklistProvider = FutureProvider.autoDispose<ChecklistView>((
  ref,
) async {
  ref.watch(_checklistChangesProvider);
  final repo = ref.watch(guideRepositoryProvider);
  // Saved, so deleting a task later doesn't untick the step.
  await repo.markDone(await repo.stepsInData());
  final row = await repo.get();
  return (done: parseSteps(row.doneSteps), dismissed: row.checklistDismissed);
});
