import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';

import '../core/card_photo.dart';
import '../data/calendar_reminder_repository.dart';
import '../data/database.dart';
import 'ai/api_key_store.dart';
import 'file_saver.dart';

/// Exports/imports every table as a single JSON file, per CLAUDE.md section
/// 12 ("สำรองข้อมูลเป็นไฟล์ JSON และนำเข้าได้ ใช้ตอนย้ายเครื่อง").
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  static const _version = 14;

  /// The card photo goes in only if [includePhoto] is asked for.
  Future<Map<String, dynamic>> buildSnapshot({
    bool includePhoto = false,
  }) async {
    Future<List<Map<String, dynamic>>>
    dump<T extends Table, R extends DataClass>(TableInfo<T, R> table) async {
      final rows = await db.select(table).get();
      return [for (final row in rows) row.toJson()];
    }

    final settings = await db.select(db.settings).getSingleOrNull();
    final photo = includePhoto
        ? await db.select(db.cardPhotos).getSingleOrNull()
        : null;
    return {
      'version': _version,
      if (photo != null) 'cardPhoto': base64Encode(photo.jpeg),
      'settings': settings?.toJson(),
      'weeklyItems': await dump(db.weeklyItems),
      'oneTimeItems': await dump(db.oneTimeItems),
      'nightPlans': await dump(db.nightPlans),
      'checkIns': await dump(db.checkIns),
      'fireStates': await dump(db.fireStates),
      'wallets': await dump(db.wallets),
      'ownedItems': await dump(db.ownedItems),
      'cardProfiles': await dump(db.cardProfiles),
      'subjectColors': await dump(db.subjectColors),
      'weeklyQuestProgresses': await dump(db.weeklyQuestProgresses),
      'examPeriodClaims': await dump(db.examPeriodClaims),
      'dayActivities': await dump(db.dayActivities),
      'routineLogs': await dump(db.routineLogs),
      'eveningTasks': await dump(db.eveningTasks),
      'taskSteps': await dump(db.taskSteps),
      // The API key is in secure storage and is never part of a backup.
      'aiSettings': await dump(db.aiSettings),
      // Keeps the SEQUENCE counters, so re-added reminders still update.
      'calendarReminderStates': await dump(db.calendarReminderStates),
      'guideStates': await dump(db.guideStates),
    };
  }

  /// Returns true if the user picked a destination and the file was saved.
  Future<bool> exportToFile({bool includePhoto = false}) async {
    final snapshot = await buildSnapshot(includePhoto: includePhoto);
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(snapshot)));
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final saved = await saveFile(
      'glow_backup_$stamp.json',
      bytes,
      'application/json',
    );
    if (saved) {
      await CalendarReminderRepository.markBackedUp(db, DateTime.now());
    }
    return saved;
  }

  /// Returns true if the user picked a file and it was restored.
  Future<bool> importFromFile() async {
    final files = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (files.isEmpty) return false;
    final bytes = await files.first.readAsBytes();
    final map = jsonDecode(utf8.decode(bytes)) as Map<String, dynamic>;
    await restoreSnapshot(map);
    return true;
  }

  /// Replaces everything with [map]. All-or-nothing: a bad file throws and
  /// leaves the current data untouched.
  Future<void> restoreSnapshot(Map<String, dynamic> map) async {
    final version = map['version'];
    if (version is! int || version < 1 || version > _version) {
      throw const FormatException('ไฟล์นี้ไม่ใช่ไฟล์สำรองของ Glow ที่รองรับ');
    }

    final importedPhoto = _photoIn(map);

    await db.transaction(() async {
      // A file without a photo leaves the one on this phone alone.
      final keptPhoto = importedPhoto == null
          ? (await db.select(db.cardPhotos).getSingleOrNull())?.jpeg
          : null;
      await deleteAllData();
      final photo = importedPhoto ?? keptPhoto;
      if (photo != null) {
        await db
            .into(db.cardPhotos)
            .insert(
              CardPhotosCompanion(id: const Value(0), jpeg: Value(photo)),
            );
      }

      Future<void> load<T extends Table, R extends DataClass>(
        String key,
        TableInfo<T, R> table,
        Insertable<R> Function(Map<String, dynamic>) parse,
      ) async {
        for (final row in (map[key] as List? ?? [])) {
          await db
              .into(table)
              .insert(
                parse(row as Map<String, dynamic>),
                mode: InsertMode.insertOrReplace,
              );
        }
      }

      final settingsJson = map['settings'] as Map<String, dynamic>?;
      if (settingsJson != null) {
        // Defaults cover columns that older backups don't have.
        await db
            .into(db.settings)
            .insert(
              SettingsRow.fromJson({
                'notifyCheckIn': true,
                'themeMode': 0,
                'voiceNoticeAccepted': false,
                'routineEnabled': true,
                'travelOverrides': '',
                'eveningEnabled': true,
                'restMinutes': 30,
                'dinnerMinutes': 45,
                'dinnerStartMinutes': 1110,
                'showerMinutes': 20,
                'showerOnArrival': false,
                'maxFocusMinutes': 50,
                'breakMinutes': 10,
                'bufferBeforeNotifyMinutes': 15,
                'hiddenPoseIds': '',
                'calendarFirstWeekday': DateTime.sunday,
                'notifyDeadline': false,
                'notifyBeforeClass': false,
                'beforeClassMinutes': 15,
                'cycleAlignEnabled': true,
                'cycleMinutes': 90,
                ...settingsJson,
              }).toCompanion(false),
              mode: InsertMode.insertOrReplace,
            );
      }
      await load(
        'weeklyItems',
        db.weeklyItems,
        (j) => WeeklyItem.fromJson(j).toCompanion(false),
      );
      await load(
        'oneTimeItems',
        db.oneTimeItems,
        (j) => OneTimeItem.fromJson(j).toCompanion(false),
      );
      await load(
        'nightPlans',
        db.nightPlans,
        // Nights in a backup older than version 3 count as pressed.
        (j) => NightPlan.fromJson({
          'usedShield': false,
          'legacyBedPress': version < 3,
          'lowEnergy': false,
          ...j,
        }).toCompanion(false),
      );
      await load(
        'checkIns',
        db.checkIns,
        (j) =>
            CheckInRow.fromJson({'pressedInBed': true, ...j})
                .toCompanion(false),
      );
      await load(
        'fireStates',
        db.fireStates,
        (j) => FireStateRow.fromJson(j).toCompanion(false),
      );
      await load(
        'wallets',
        db.wallets,
        (j) => WalletRow.fromJson(j).toCompanion(false),
      );
      await load(
        'ownedItems',
        db.ownedItems,
        (j) => OwnedItem.fromJson(j).toCompanion(false),
      );
      await load(
        'cardProfiles',
        db.cardProfiles,
        (j) => CardProfileRow.fromJson(j).toCompanion(false),
      );
      await load(
        'subjectColors',
        db.subjectColors,
        (j) => SubjectColorRow.fromJson(j).toCompanion(false),
      );
      await load(
        'weeklyQuestProgresses',
        db.weeklyQuestProgresses,
        (j) => WeeklyQuestProgressesData.fromJson(j).toCompanion(false),
      );
      await load(
        'examPeriodClaims',
        db.examPeriodClaims,
        (j) => ExamPeriodClaim.fromJson(j).toCompanion(false),
      );
      await load(
        'dayActivities',
        db.dayActivities,
        (j) => DayActivity.fromJson(j).toCompanion(false),
      );
      await load(
        'routineLogs',
        db.routineLogs,
        (j) => RoutineLog.fromJson(j).toCompanion(false),
      );
      await load(
        'eveningTasks',
        db.eveningTasks,
        (j) => EveningTask.fromJson(j).toCompanion(false),
      );
      await load(
        'taskSteps',
        db.taskSteps,
        (j) => TaskStepRow.fromJson(j).toCompanion(false),
      );
      await load(
        'aiSettings',
        db.aiSettings,
        // A restored backup never switches AI on by itself, and asks again
        // before any picture is sent.
        (j) => AiSettingsRow.fromJson({
          ...j,
          'enabled': false,
          'imageConsentVersion': 0,
        }).toCompanion(false),
      );
      await load(
        'calendarReminderStates',
        db.calendarReminderStates,
        (j) => CalendarReminderRow.fromJson(j).toCompanion(false),
      );
      await load(
        'guideStates',
        db.guideStates,
        (j) => GuideStateRow.fromJson(j).toCompanion(false),
      );
    });
  }

  /// The photo in a backup, or null. Anything but a small JPEG is refused.
  static Uint8List? _photoIn(Map<String, dynamic> map) {
    final value = map['cardPhoto'];
    if (value == null) return null;
    final bytes = value is String ? base64Decode(value) : null;
    if (bytes == null ||
        bytes.length < 3 ||
        bytes.length > maxCardPhotoBytes ||
        bytes[0] != 0xFF ||
        bytes[1] != 0xD8) {
      throw const FormatException('รูปในไฟล์สำรองไม่ถูกต้อง');
    }
    return bytes;
  }

  /// "ลบข้อมูลทั้งหมด": the database and the API key.
  Future<void> deleteEverything(ApiKeyStore keys) async {
    await keys.delete();
    await deleteAllData();
  }

  /// Empties the database only; restoring a backup keeps this phone's key.
  Future<void> deleteAllData() async {
    await db.transaction(() async {
      for (final table in db.allTables) {
        await db.delete(table).go();
      }
    });
  }
}
