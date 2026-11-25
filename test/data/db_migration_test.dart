import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';

/// Rewinds a freshly created database to what schema version 2 looked like.
const _rewindToV2 = [
  'ALTER TABLE settings DROP COLUMN theme_mode',
  'ALTER TABLE settings DROP COLUMN notify_check_in',
  'ALTER TABLE settings DROP COLUMN onboarded_at',
  'ALTER TABLE settings DROP COLUMN voice_notice_accepted',
  'ALTER TABLE night_plans DROP COLUMN in_bed_at',
  'ALTER TABLE night_plans DROP COLUMN used_shield',
  'ALTER TABLE night_plans DROP COLUMN fire_applied_at',
  'DROP TABLE check_ins',
  'DROP TABLE fire_states',
  'DROP TABLE wallets',
  'DROP TABLE owned_items',
  'DROP TABLE weekly_quest_progresses',
  'DROP TABLE exam_period_claims',
];

void main() {
  late Directory dir;
  late File file;

  setUp(() {
    dir = Directory.systemTemp.createTempSync('glow_migration');
    file = File('${dir.path}/glow.sqlite');
  });

  tearDown(() => dir.deleteSync(recursive: true));

  Future<void> prepare(List<String> statements) async {
    final db = AppDatabase.forTesting(NativeDatabase(file));
    await db.customSelect('SELECT 1').get();
    for (final sql in statements) {
      await db.customStatement(sql);
    }
    await db.close();
  }

  Future<void> expectUsable() async {
    final db = AppDatabase.forTesting(NativeDatabase(file));
    expect(await db.select(db.settings).get(), isEmpty);
    expect(await db.select(db.fireStates).get(), isEmpty);
    expect(await db.select(db.nightPlans).get(), isEmpty);
    final version = await db.customSelect('PRAGMA user_version').getSingle();
    expect(version.data['user_version'], db.schemaVersion);
    await db.close();
  }

  test('upgrades a version 2 database to the latest schema', () async {
    await prepare([..._rewindToV2, 'PRAGMA user_version = 2']);
    await expectUsable();
  });

  test('repairs a database left half-migrated at version 2', () async {
    await prepare(['PRAGMA user_version = 2']);
    await expectUsable();
  });
}
