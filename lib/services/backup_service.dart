import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';

import '../data/calendar_reminder_repository.dart';
import '../data/database.dart';
import 'ai/api_key_store.dart';
import 'file_saver.dart';

/// Exports/imports every table as a single JSON file, per CLAUDE.md section
/// 12 ("สำรองข้อมูลเป็นไฟล์ JSON และนำเข้าได้ ใช้ตอนย้ายเครื่อง").
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  static const _version = 6;

  Future<Map<String, dynamic>> buildSnapshot() async {
    Future<List<Map<String, dynamic>>>
    dump<T extends Table, R extends DataClass>(TableInfo<T, R> table) async {
      final rows = await db.select(table).get();
      return [for (final row in rows) row.toJson()];
    }

    final settings = await db.select(db.settings).getSingleOrNull();
    return {
      'version': _version,
      'settings': settings?.toJson(),
      'weeklyItems': await dump(db.weeklyItems),
      'oneTimeItems': await dump(db.oneTimeItems),
      'nightPlans': await dump(db.nightPlans),
      'checkIns': await dump(db.checkIns),
      'fireStates': await dump(db.fireStates),
      'wallets': await dump(db.wallets),
      'ownedItems': await dump(db.ownedItems),
      'weeklyQuestProgresses': await dump(db.weeklyQuestProgresses),
      'examPeriodClaims': await dump(db.examPeriodClaims),
      'dayActivities': await dump(db.dayActivities),
      'routineLogs': await dump(db.routineLogs),
      'eveningTasks': await dump(db.eveningTasks),
      // The API key is in secure storage and is never part of a backup.
      'aiSettings': await dump(db.aiSettings),
      // Keeps the SEQUENCE counters, so re-added reminders still update.
      'calendarReminderStates': await dump(db.calendarReminderStates),
    };
  }

  /// Returns true if the user picked a destination and the file was saved.
  Future<bool> exportToFile() async {
    final snapshot = await buildSnapshot();
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

    await db.transaction(() async {
      await deleteAllData();

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
        'aiSettings',
        db.aiSettings,
        // A restored backup never switches AI on by itself.
        (j) =>
            AiSettingsRow.fromJson({...j, 'enabled': false}).toCompanion(false),
      );
      await load(
        'calendarReminderStates',
        db.calendarReminderStates,
        (j) => CalendarReminderRow.fromJson(j).toCompanion(false),
      );
    });
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
