import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:file_picker/file_picker.dart';

import '../data/database.dart';

/// Exports/imports every table as a single JSON file, per CLAUDE.md section
/// 12 ("สำรองข้อมูลเป็นไฟล์ JSON และนำเข้าได้ ใช้ตอนย้ายเครื่อง").
class BackupService {
  final AppDatabase db;

  BackupService(this.db);

  Future<Map<String, dynamic>> _buildSnapshot() async {
    final settings = await db.select(db.settings).getSingleOrNull();
    final weekly = await db.select(db.weeklyItems).get();
    final oneTime = await db.select(db.oneTimeItems).get();
    final nightPlans = await db.select(db.nightPlans).get();
    return {
      'version': 1,
      'settings': settings?.toJson(),
      'weeklyItems': weekly.map((e) => e.toJson()).toList(),
      'oneTimeItems': oneTime.map((e) => e.toJson()).toList(),
      'nightPlans': nightPlans.map((e) => e.toJson()).toList(),
    };
  }

  /// Returns true if the user picked a destination and the file was saved.
  Future<bool> exportToFile() async {
    final snapshot = await _buildSnapshot();
    final bytes = Uint8List.fromList(utf8.encode(jsonEncode(snapshot)));
    final stamp = DateTime.now().toIso8601String().replaceAll(':', '-');
    final uri = await FilePicker.saveFile(
      fileName: 'glow_backup_$stamp.json',
      bytes: bytes,
      mimeType: 'application/json',
    );
    return uri != null;
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
    await _restoreSnapshot(map);
    return true;
  }

  Future<void> _restoreSnapshot(Map<String, dynamic> map) async {
    await db.transaction(() async {
      await db.delete(db.nightPlans).go();
      await db.delete(db.oneTimeItems).go();
      await db.delete(db.weeklyItems).go();
      await db.delete(db.settings).go();

      final settingsJson = map['settings'] as Map<String, dynamic>?;
      if (settingsJson != null) {
        await db.into(db.settings).insert(
          SettingsRow.fromJson(settingsJson).toCompanion(false),
          mode: InsertMode.insertOrReplace,
        );
      }
      for (final w in (map['weeklyItems'] as List? ?? [])) {
        await db.into(db.weeklyItems).insert(
          WeeklyItem.fromJson(w as Map<String, dynamic>).toCompanion(false),
          mode: InsertMode.insertOrReplace,
        );
      }
      for (final o in (map['oneTimeItems'] as List? ?? [])) {
        await db.into(db.oneTimeItems).insert(
          OneTimeItem.fromJson(o as Map<String, dynamic>).toCompanion(false),
          mode: InsertMode.insertOrReplace,
        );
      }
      for (final n in (map['nightPlans'] as List? ?? [])) {
        await db.into(db.nightPlans).insert(
          NightPlan.fromJson(n as Map<String, dynamic>).toCompanion(false),
          mode: InsertMode.insertOrReplace,
        );
      }
    });
  }

  Future<void> deleteAllData() async {
    await db.transaction(() async {
      await db.delete(db.nightPlans).go();
      await db.delete(db.oneTimeItems).go();
      await db.delete(db.weeklyItems).go();
      await db.delete(db.settings).go();
    });
  }
}
