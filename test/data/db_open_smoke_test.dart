import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';

void main() {
  test('in-memory database opens and can be queried', () async {
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    final rows = await db.select(db.settings).get();
    expect(rows, isEmpty);
    await db.close();
  });
}
