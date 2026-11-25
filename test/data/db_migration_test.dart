import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';

const _rewindFrom12 = [
  'ALTER TABLE settings DROP COLUMN travel_overrides',
  'ALTER TABLE night_plans DROP COLUMN prep_override_minutes',
  'ALTER TABLE settings DROP COLUMN evening_enabled',
  'ALTER TABLE settings DROP COLUMN rest_minutes',
  'ALTER TABLE settings DROP COLUMN dinner_minutes',
  'ALTER TABLE settings DROP COLUMN dinner_start_minutes',
  'ALTER TABLE settings DROP COLUMN shower_minutes',
  'ALTER TABLE settings DROP COLUMN shower_on_arrival',
  'ALTER TABLE settings DROP COLUMN max_focus_minutes',
  'ALTER TABLE settings DROP COLUMN break_minutes',
  'ALTER TABLE settings DROP COLUMN buffer_before_notify_minutes',
  'ALTER TABLE night_plans DROP COLUMN evening_from',
  'ALTER TABLE night_plans DROP COLUMN evening_started_at',
  'DROP TABLE evening_tasks',
];

/// What schema 11 added to tables that existed before it. The check_ins
/// columns are only listed for rewinds that keep that table.
const _rewindFrom11 = [
  'ALTER TABLE settings DROP COLUMN routine_enabled',
  'ALTER TABLE settings DROP COLUMN hidden_pose_ids',
  'ALTER TABLE night_plans DROP COLUMN legacy_bed_press',
  'ALTER TABLE night_plans DROP COLUMN quest_mode',
  'ALTER TABLE night_plans DROP COLUMN low_energy',
  'DROP TABLE day_activities',
  'DROP TABLE routine_logs',
  ..._rewindFrom12,
];

/// Rewinds a freshly created database to what schema version 2 looked like.
const _rewindToV2 = [
  'ALTER TABLE settings DROP COLUMN theme_mode',
  'ALTER TABLE settings DROP COLUMN notify_check_in',
  'ALTER TABLE settings DROP COLUMN onboarded_at',
  'ALTER TABLE settings DROP COLUMN voice_notice_accepted',
  ..._rewindFrom11,
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

  test('version 10 data survives, and old nights count as pressed', () async {
    await prepare([
      'INSERT INTO night_plans (wake_date, planned_wake_at, planned_bedtime_at,'
          ' is_locked) VALUES (1795478400, 1795502100, 1795470600, 1)',
      'INSERT INTO check_ins (wake_date, lights_off_at, actual_wake_at,'
          ' result, on_time, checked_in_at)'
          ' VALUES (1795478400, 1795470600, 1795502100, 0, 1, 1795503000)',
      ..._rewindFrom11,
      'ALTER TABLE check_ins DROP COLUMN pressed_in_bed',
      'ALTER TABLE check_ins DROP COLUMN lights_off_source',
      'PRAGMA user_version = 10',
    ]);

    final db = AppDatabase.forTesting(NativeDatabase(file));
    final plan = await db.select(db.nightPlans).getSingle();
    expect(plan.legacyBedPress, isTrue);
    expect(plan.questMode, isNull);
    final checkIn = await db.select(db.checkIns).getSingle();
    expect(checkIn.pressedInBed, isTrue);
    expect(checkIn.onTime, isTrue);
    expect(await db.select(db.dayActivities).get(), isEmpty);
    await db.close();
  });

  test('repairs a database left half-migrated at version 10', () async {
    // Everything already added, but the version never moved on.
    await prepare(['PRAGMA user_version = 10']);
    await expectUsable();
  });

  test('repairs a database left half-migrated at version 2', () async {
    await prepare(['PRAGMA user_version = 2']);
    await expectUsable();
  });
}
