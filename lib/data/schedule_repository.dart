import 'package:drift/drift.dart';

import '../core/schedule_models.dart' as core;
import 'database.dart';

class ScheduleRepository {
  final AppDatabase db;

  ScheduleRepository(this.db);

  Stream<List<WeeklyItem>> watchWeeklyItems() =>
      db.select(db.weeklyItems).watch();

  Stream<List<OneTimeItem>> watchOneTimeItems() =>
      db.select(db.oneTimeItems).watch();

  Future<List<WeeklyItem>> getWeeklyItems() => db.select(db.weeklyItems).get();

  Future<List<OneTimeItem>> getOneTimeItems() =>
      db.select(db.oneTimeItems).get();

  Future<int> addWeeklyItem({
    required String title,
    required int dayOfWeek,
    required int startMinutes,
    required int endMinutes,
    required WeeklyItemType type,
    ItemSource source = ItemSource.typed,
    String? calendarEventId,
  }) {
    return db
        .into(db.weeklyItems)
        .insert(
          WeeklyItemsCompanion.insert(
            title: title,
            dayOfWeek: dayOfWeek,
            startMinutes: startMinutes,
            endMinutes: endMinutes,
            type: type,
            source: Value(source),
            calendarEventId: Value(calendarEventId),
          ),
        );
  }

  /// Copies [item] onto each day in [dayOfWeekTargets] (1=Mon..7=Sun).
  Future<void> copyWeeklyItemToDays(
    WeeklyItem item,
    List<int> dayOfWeekTargets,
  ) async {
    for (final day in dayOfWeekTargets) {
      await addWeeklyItem(
        title: item.title,
        dayOfWeek: day,
        startMinutes: item.startMinutes,
        endMinutes: item.endMinutes,
        type: item.type,
        source: item.source,
      );
    }
  }

  Future<void> updateWeeklyItem(WeeklyItem item) =>
      db.update(db.weeklyItems).replace(item);

  Future<void> deleteWeeklyItem(int id) =>
      (db.delete(db.weeklyItems)..where((t) => t.id.equals(id))).go();

  Future<int> addOneTimeItem({
    required String title,
    required DateTime date,
    required OneTimeItemType type,
    int? startMinutes,
    int? endMinutes,
    ItemSource source = ItemSource.typed,
    String? calendarEventId,
  }) {
    return db
        .into(db.oneTimeItems)
        .insert(
          OneTimeItemsCompanion.insert(
            title: title,
            date: date,
            type: type,
            startMinutes: Value(startMinutes),
            endMinutes: Value(endMinutes),
            source: Value(source),
            calendarEventId: Value(calendarEventId),
          ),
        );
  }

  Future<void> updateOneTimeItem(OneTimeItem item) =>
      db.update(db.oneTimeItems).replace(item);

  Future<void> deleteOneTimeItem(int id) =>
      (db.delete(db.oneTimeItems)..where((t) => t.id.equals(id))).go();

  /// Distinct titles typed before, most recent first, for the "ชื่อวิชาที่
  /// เคยพิมพ์ขึ้นให้เลือก" autocomplete.
  Future<List<String>> recentTitles() async {
    final weekly = await db.select(db.weeklyItems).get();
    final oneTime = await db.select(db.oneTimeItems).get();
    final titles = <String>{
      for (final w in weekly.reversed) w.title,
      for (final o in oneTime.reversed) o.title,
    };
    return titles.toList();
  }

  /// True if a calendar event was already imported before (used by "นำเข้า
  /// อีกครั้ง" to skip duplicates).
  Future<bool> hasImportedCalendarEvent(String calendarEventId) async {
    // A series can map to several rows (one per weekday), so don't assume
    // there is at most one.
    final weekly = await (db.select(
      db.weeklyItems,
    )..where((t) => t.calendarEventId.equals(calendarEventId))).get();
    if (weekly.isNotEmpty) return true;
    final oneTime = await (db.select(
      db.oneTimeItems,
    )..where((t) => t.calendarEventId.equals(calendarEventId))).get();
    return oneTime.isNotEmpty;
  }
}

core.ItemKind _weeklyKind(WeeklyItemType type) => switch (type) {
  WeeklyItemType.classSession => core.ItemKind.classSession,
  WeeklyItemType.activity => core.ItemKind.activity,
};

core.ItemKind _oneTimeKind(OneTimeItemType type) => switch (type) {
  OneTimeItemType.exam => core.ItemKind.exam,
  OneTimeItemType.activity => core.ItemKind.activity,
  OneTimeItemType.holiday => core.ItemKind.holiday,
};

List<core.WeeklyEntry> toCoreWeeklyEntries(List<WeeklyItem> rows) => rows
    .map(
      (r) => core.WeeklyEntry(
        title: r.title,
        dayOfWeek: r.dayOfWeek,
        startMinutes: r.startMinutes,
        endMinutes: r.endMinutes,
        kind: _weeklyKind(r.type),
      ),
    )
    .toList();

List<core.OneTimeEntry> toCoreOneTimeEntries(List<OneTimeItem> rows) => rows
    .map(
      (r) => core.OneTimeEntry(
        title: r.title,
        date: r.date,
        startMinutes: r.startMinutes,
        endMinutes: r.endMinutes,
        kind: _oneTimeKind(r.type),
      ),
    )
    .toList();
