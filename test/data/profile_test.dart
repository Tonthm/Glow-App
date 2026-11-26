import 'dart:io';
import 'dart:typed_data';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/birth_date.dart';
import 'package:glow/core/card_photo.dart';
import 'package:glow/core/first_class.dart';
import 'package:glow/data/ai_settings_repository.dart';
import 'package:glow/data/card_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/night_planning_repository.dart';
import 'package:glow/data/schedule_repository.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/data/wallet_repository.dart';
import 'package:glow/services/ai/api_key_store.dart';
import 'package:glow/services/backup_service.dart';

/// A stand-in photo: it only has to start like a JPEG.
Uint8List _jpeg(int length, [int fill = 7]) => Uint8List(length)
  ..fillRange(0, length, fill)
  ..[0] = 0xFF
  ..[1] = 0xD8;

void main() {
  final now = DateTime(2026, 11, 26, 20);
  final adultBirth = DateTime(2000, 5, 1);
  final childBirth = DateTime(2011, 5, 1);

  late AppDatabase db;
  late SettingsRepository settings;
  late CardRepository cards;
  late BackupService backups;

  void open(AppDatabase database) {
    db = database;
    settings = SettingsRepository(db);
    cards = CardRepository(db, WalletRepository(db));
    backups = BackupService(db);
  }

  /// A database file deleted after the test, once it is closed (Windows
  /// won't delete an open file).
  File temporary() {
    final dir = Directory.systemTemp.createTempSync('glow_photo');
    addTearDown(() async {
      await db.close();
      dir.deleteSync(recursive: true);
    });
    return File('${dir.path}/glow.sqlite');
  }

  setUp(() async {
    open(AppDatabase.forTesting(NativeDatabase.memory()));
    await settings.ensureRowExists();
  });

  tearDown(() => db.close());

  group('birth date', () {
    test('sets the age group and an untouched sleep target', () async {
      await cards.setBirthDate(adultBirth, now: now);
      var row = await settings.get();
      expect(row.ageGroup, AgeGroup.adult);
      expect((row.targetMinMinutes, row.targetMaxMinutes), (420, 540));

      await cards.setBirthDate(childBirth, now: now);
      row = await settings.get();
      expect(row.ageGroup, AgeGroup.under18);
      expect((row.targetMinMinutes, row.targetMaxMinutes), (480, 600));
    });

    test('leaves a target the user chose', () async {
      await settings.updateTargetHours(minMinutes: 510);
      await cards.setBirthDate(adultBirth, now: now);
      final row = await settings.get();
      expect(row.ageGroup, AgeGroup.adult);
      expect((row.targetMinMinutes, row.targetMaxMinutes), (510, 600));
    });

    test('saved again after a birthday does not move the target', () async {
      final turns18Tomorrow = DateTime(2008, 11, 27);
      await cards.setBirthDate(turns18Tomorrow, now: now);
      await cards.setBirthDate(turns18Tomorrow, now: DateTime(2027));
      expect((await settings.get()).targetMinMinutes, 480);
    });

    test('can be cleared, keeping the age group', () async {
      await cards.setBirthDate(adultBirth, now: now);
      await cards.setBirthDate(null, now: now);
      expect((await cards.get()).birthDate, isNull);
      expect((await settings.get()).ageGroup, AgeGroup.adult);
    });

    test('under 18 hides AI even if 18+ is chosen in settings', () async {
      final ai = AiSettingsRepository(db);
      expect(await ai.ageState(now), AiAgeState.blocked);
      await settings.applyAgeGroupDefaults(AgeGroup.adult);
      expect(await ai.ageState(now), AiAgeState.adultUnconfirmed);
      await cards.setBirthDate(childBirth, now: now);
      await settings.applyAgeGroupDefaults(AgeGroup.adult);
      expect(await ai.ageState(now), AiAgeState.hidden);
    });
  });

  group('card photo', () {
    test('is saved, replaced and removed', () async {
      expect(await cards.photo(), isNull);
      await cards.savePhoto(_jpeg(100, 1));
      await cards.savePhoto(_jpeg(200, 2));
      expect(await cards.photo(), _jpeg(200, 2));
      expect(await db.select(db.cardPhotos).get(), hasLength(1));
      await cards.removePhoto();
      expect(await cards.photo(), isNull);
    });

    test('too big or empty is refused', () async {
      expect(
        () => cards.savePhoto(_jpeg(maxCardPhotoBytes + 1)),
        throwsArgumentError,
      );
      expect(() => cards.savePhoto(Uint8List(0)), throwsArgumentError);
    });

    test('goes away with "delete all", as does the birth date', () async {
      await cards.savePhoto(_jpeg(100));
      await cards.setBirthDate(adultBirth, now: now);
      await backups.deleteEverything(MemoryApiKeyStore('k'));
      expect(await db.select(db.cardPhotos).get(), isEmpty);
      expect(await db.select(db.cardProfiles).get(), isEmpty);
    });

    test('does not make the database file keep growing', () async {
      await db.close();
      final file = temporary();
      open(AppDatabase.forTesting(NativeDatabase(file)));
      await settings.ensureRowExists();

      await cards.savePhoto(_jpeg(maxCardPhotoBytes, 1));
      await cards.savePhoto(_jpeg(maxCardPhotoBytes, 2));
      final settled = file.lengthSync();
      for (var i = 0; i < 30; i++) {
        await cards.savePhoto(_jpeg(maxCardPhotoBytes, i));
        if (i.isEven) await cards.removePhoto();
      }
      expect(file.lengthSync(), lessThanOrEqualTo(settled + 32 * 1024));
    });

    test('removed, its bytes are wiped from the file', () async {
      await db.close();
      final file = temporary();
      open(AppDatabase.forTesting(NativeDatabase(file)));
      await settings.ensureRowExists();

      int run() {
        var longest = 0, current = 0;
        for (final byte in file.readAsBytesSync()) {
          current = byte == 0xAB ? current + 1 : 0;
          if (current > longest) longest = current;
        }
        return longest;
      }

      await cards.savePhoto(_jpeg(60 * 1024, 0xAB));
      expect(run(), greaterThan(500));
      await cards.removePhoto();
      expect(run(), lessThan(16));
    });
  });

  group('backup', () {
    test('leaves the photo out unless asked', () async {
      await cards.savePhoto(_jpeg(100));
      expect(await backups.buildSnapshot(), isNot(contains('cardPhoto')));
      expect(
        await backups.buildSnapshot(includePhoto: true),
        contains('cardPhoto'),
      );
    });

    test('without a photo keeps the one on the phone', () async {
      await cards.setBirthDate(adultBirth, now: now);
      final file = await backups.buildSnapshot();
      await cards.savePhoto(_jpeg(100, 3));
      await backups.restoreSnapshot(file);
      expect(await cards.photo(), _jpeg(100, 3));
      expect((await cards.get()).birthDate, adultBirth);
    });

    test('with a photo replaces the one on the phone', () async {
      await cards.savePhoto(_jpeg(100, 4));
      final file = await backups.buildSnapshot(includePhoto: true);
      await cards.savePhoto(_jpeg(100, 5));
      await backups.restoreSnapshot(file);
      expect(await cards.photo(), _jpeg(100, 4));
    });

    test('with a broken photo changes nothing', () async {
      await cards.savePhoto(_jpeg(100, 6));
      final file = await backups.buildSnapshot();
      for (final bad in ['not base64 !', 'AAAA', 12]) {
        await expectLater(
          backups.restoreSnapshot({...file, 'cardPhoto': bad}),
          throwsFormatException,
        );
      }
      expect(await cards.photo(), _jpeg(100, 6));
    });

    test('from before version 8 still loads', () async {
      final file = await backups.buildSnapshot();
      await cards.savePhoto(_jpeg(100));
      (file['settings'] as Map<String, dynamic>).remove('earliestClassMinutes');
      await backups.restoreSnapshot({...file, 'version': 7});
      expect((await settings.get()).earliestClassMinutes, isNull);
      expect(await cards.photo(), isNotNull);
    });
  });

  group('earliest class time', () {
    late NightPlanningRepository planning;
    // A Monday.
    final monday = DateTime(2026, 11, 30);

    setUp(() {
      planning = NightPlanningRepository(db, ScheduleRepository(db), settings);
    });

    test('sets wake times while there is no timetable', () async {
      await settings.updateEarliestClass(8 * 60);
      final plan = await planning.computeDraftForWakeDate(monday);
      expect(plan.wakeTime, DateTime(2026, 11, 30, 6, 35));
      expect(
        (await planning.firstAppointment(monday))!.title,
        earliestClassTitle,
      );
    });

    test('is not an appointment for the evening, and is not saved', () async {
      await settings.updateEarliestClass(8 * 60);
      expect(await planning.entriesOn(monday), isEmpty);
      expect(await db.select(db.weeklyItems).get(), isEmpty);
    });

    test('gives way to a real timetable', () async {
      await settings.updateEarliestClass(8 * 60);
      await db
          .into(db.weeklyItems)
          .insert(
            WeeklyItemsCompanion.insert(
              title: 'บ่าย',
              dayOfWeek: DateTime.tuesday,
              startMinutes: 13 * 60,
              endMinutes: 14 * 60,
              type: WeeklyItemType.classSession,
              source: const Value(ItemSource.typed),
            ),
          );
      // Monday now has no class, so it is a free morning.
      final plan = await planning.computeDraftForWakeDate(monday);
      expect(plan.wakeTime, DateTime(2026, 11, 30, 7, 30));
    });
  });
}
