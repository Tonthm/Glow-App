import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';

/// What schema 17 added.
const _rewindFrom17 = [
  'DROP TABLE card_photos',
  'ALTER TABLE settings DROP COLUMN earliest_class_minutes',
];

/// What schema 14 added, and the newer tables on top of it. Must run before
/// evening_tasks is dropped.
const _rewindFrom14 = [
  ..._rewindFrom17,
  'DROP TABLE card_profiles',
  'DROP TABLE calendar_reminder_states',
  'ALTER TABLE evening_tasks DROP COLUMN ai_estimate_minutes',
  'ALTER TABLE evening_tasks DROP COLUMN parent_id',
  'DROP TABLE ai_settings',
];

const _rewindFrom12 = [
  ..._rewindFrom14,
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

  test(
    'a version 13 database keeps its tasks and starts with AI off',
    () async {
      await prepare([
        'INSERT INTO evening_tasks (title, minutes, kind, plan_date)'
            " VALUES ('เลข', 30, 0, 1795392000)",
        ..._rewindFrom14,
        'PRAGMA user_version = 13',
      ]);

      final db = AppDatabase.forTesting(NativeDatabase(file));
      final task = await db.select(db.eveningTasks).getSingle();
      expect(task.title, 'เลข');
      expect(task.aiEstimateMinutes, isNull);
      expect(task.parentId, isNull);
      expect(await db.select(db.aiSettings).get(), isEmpty);
      await db.close();
    },
  );

  test('a version 15 database keeps everything bought in the shop', () async {
    await prepare([
      'INSERT INTO wallets (id, coins, equipped_blanket_id)'
          " VALUES (0, 137, 'blanket_navy')",
      'INSERT INTO owned_items (item_id, acquired_at)'
          " VALUES ('blanket_navy', 1795000000)",
      'INSERT INTO owned_items (item_id, acquired_at)'
          " VALUES ('blanket_spark', 1795000100)",
      'INSERT INTO fire_states (id, points, level, shields)'
          ' VALUES (0, 9, 3, 2)',
      ..._rewindFrom17,
      'DROP TABLE card_profiles',
      'PRAGMA user_version = 15',
    ]);

    final db = AppDatabase.forTesting(NativeDatabase(file));
    final wallet = await db.select(db.wallets).getSingle();
    expect(wallet.coins, 137);
    expect(wallet.equippedBlanketId, 'blanket_navy');
    final owned = await db.select(db.ownedItems).get();
    expect(owned.map((o) => o.itemId).toSet(), {
      'blanket_navy',
      'blanket_spark',
    });
    final fire = await db.select(db.fireStates).getSingle();
    expect((fire.points, fire.level, fire.shields), (9, 3, 2));
    expect(await db.select(db.cardProfiles).get(), isEmpty);
    await db.close();
  });

  test('a version 16 database, as published on the web, keeps it all', () async {
    await prepare([
      'INSERT INTO settings (id, onboarding_completed, target_min_minutes)'
          ' VALUES (0, 1, 495)',
      'INSERT INTO weekly_items (title, day_of_week, start_minutes,'
          " end_minutes, type) VALUES ('ฟิสิกส์', 1, 480, 540, 0)",
      'INSERT INTO one_time_items (title, date, type)'
          " VALUES ('สอบเคมี', 1796000000, 0)",
      'INSERT INTO wallets (id, coins, equipped_blanket_id)'
          " VALUES (0, 88, 'blanket_navy')",
      'INSERT INTO owned_items (item_id, acquired_at)'
          " VALUES ('sticker_zzz', 1795000000)",
      'INSERT INTO fire_states (id, points, level, shields)'
          ' VALUES (0, 15, 4, 1)',
      'INSERT INTO card_profiles (id, display_name, school, sticker_ids)'
          " VALUES (0, 'มายด์', 'โรงเรียน', 'sticker_zzz')",
      ..._rewindFrom17,
      'ALTER TABLE card_profiles DROP COLUMN birth_date',
      'PRAGMA user_version = 16',
    ]);

    final db = AppDatabase.forTesting(NativeDatabase(file));
    final settings = await db.select(db.settings).getSingle();
    expect(settings.onboardingCompleted, isTrue);
    expect(settings.targetMinMinutes, 495);
    expect(settings.earliestClassMinutes, isNull);
    expect((await db.select(db.weeklyItems).getSingle()).title, 'ฟิสิกส์');
    expect((await db.select(db.oneTimeItems).getSingle()).title, 'สอบเคมี');
    expect((await db.select(db.wallets).getSingle()).coins, 88);
    expect((await db.select(db.ownedItems).getSingle()).itemId, 'sticker_zzz');
    final fire = await db.select(db.fireStates).getSingle();
    expect((fire.points, fire.level, fire.shields), (15, 4, 1));
    final card = await db.select(db.cardProfiles).getSingle();
    expect((card.displayName, card.stickerIds), ('มายด์', 'sticker_zzz'));
    expect(card.birthDate, isNull);
    expect(await db.select(db.cardPhotos).get(), isEmpty);
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
