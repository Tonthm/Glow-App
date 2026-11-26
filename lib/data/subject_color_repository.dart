import 'package:drift/drift.dart';

import '../core/subject_color.dart';
import 'database.dart';

/// The colors the user gave to subjects, looked up by name.
class SubjectColorRepository {
  final AppDatabase db;

  SubjectColorRepository(this.db);

  static Map<String, int> _byName(List<SubjectColorRow> rows) => {
    for (final r in rows) r.subject: r.color,
  };

  Stream<Map<String, int>> watch() =>
      db.select(db.subjectColors).watch().map(_byName);

  Future<Map<String, int>> all() async =>
      _byName(await db.select(db.subjectColors).get());

  /// A null [color] goes back to the color of the item's type.
  Future<void> set(String title, int? color) async {
    final key = subjectKey(title);
    if (key.isEmpty) return;
    if (color == null) {
      await (db.delete(
        db.subjectColors,
      )..where((t) => t.subject.equals(key))).go();
    } else {
      await db
          .into(db.subjectColors)
          .insertOnConflictUpdate(
            SubjectColorsCompanion(subject: Value(key), color: Value(color)),
          );
    }
  }
}
