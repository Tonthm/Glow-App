/// What the guide remembers, and that it is backed up and deleted with
/// everything else (CLAUDE.md section 21).
library;

import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/guide.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/guide_repository.dart';
import 'package:glow/services/backup_service.dart';

void main() {
  late AppDatabase db;
  late GuideRepository guide;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    guide = GuideRepository(db);
  });
  tearDown(() => db.close());

  Future<(bool, bool, String)> state() async {
    final row = await guide.get();
    return (row.tourPending, row.checklistDismissed, row.doneSteps);
  }

  Future<void> useIt() async {
    await guide.setTourPending(true);
    await guide.dismissChecklist();
    await guide.markDone({ChecklistStep.routine});
    await guide.markDone({ChecklistStep.viewPlan});
  }

  test('starts empty, and reading writes nothing', () async {
    expect(await state(), (false, false, ''));
    expect(await db.select(db.guideStates).get(), isEmpty);
  });

  test('each change keeps the others', () async {
    await useIt();
    expect(await state(), (true, true, 'viewPlan,routine'));
    await guide.setTourPending(false);
    expect(await state(), (false, true, 'viewPlan,routine'));
  });

  test('a backup carries it, and deleting everything clears it', () async {
    await useIt();
    final backup = BackupService(db);
    final file = jsonDecode(
      jsonEncode(await backup.buildSnapshot()),
    ) as Map<String, dynamic>;

    await backup.deleteAllData();
    expect(await state(), (false, false, ''));

    await backup.restoreSnapshot(file);
    expect(await state(), (true, true, 'viewPlan,routine'));
  });

  test('an older backup restores with an untouched guide', () async {
    await useIt();
    await BackupService(db).restoreSnapshot({'version': 13});
    expect(await state(), (false, false, ''));
  });
}
