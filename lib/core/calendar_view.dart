/// The calendar's month, week and day views (CLAUDE.md section 2): which days
/// each shows, what falls on each day, and where it sits in the time grid.
///
/// Which weekly items fall on a day is decided by [resolveScheduleForDate],
/// the same rules the sleep plan uses. The first day of the week here is only
/// about how the calendar is drawn: quests and stats still start on Monday.
library;

import 'dart:math' as math;

import 'schedule_models.dart';
import 'schedule_resolver.dart';

enum CalendarMode { month, week, day }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

bool isSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

// ---------- which days ----------

/// [firstWeekday] is DateTime.monday .. DateTime.sunday.
DateTime startOfWeek(DateTime date, int firstWeekday) =>
    _addDays(date, -((date.weekday - firstWeekday + 7) % 7));

/// The weekdays in column order.
List<int> weekdayOrder(int firstWeekday) => [
  for (var i = 0; i < 7; i++) (firstWeekday - 1 + i) % 7 + 1,
];

List<DateTime> weekDays(DateTime date, int firstWeekday) {
  final start = startOfWeek(date, firstWeekday);
  return [for (var i = 0; i < 7; i++) _addDays(start, i)];
}

/// Whole weeks covering the month of [date]: 4 to 6 of them.
List<DateTime> monthDays(DateTime date, int firstWeekday) {
  final start = startOfWeek(DateTime(date.year, date.month), firstWeekday);
  // Day 0 of the next month is the last day of this one.
  final last = DateTime(date.year, date.month + 1, 0);
  final days = <DateTime>[];
  var day = start;
  while (!day.isAfter(last) || days.length % 7 != 0) {
    days.add(day);
    day = _addDays(day, 1);
  }
  return days;
}

/// [steps] months, weeks or days later (earlier if negative).
DateTime shiftPeriod(CalendarMode mode, DateTime date, int steps) {
  switch (mode) {
    case CalendarMode.day:
      return _addDays(date, steps);
    case CalendarMode.week:
      return _addDays(date, 7 * steps);
    case CalendarMode.month:
      final lastDay = DateTime(date.year, date.month + steps + 1, 0).day;
      return DateTime(
        date.year,
        date.month + steps,
        math.min(date.day, lastDay),
      );
  }
}

// ---------- Thai words ----------

const List<String> thaiMonths = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];

const List<String> thaiShortMonths = [
  'ม.ค.',
  'ก.พ.',
  'มี.ค.',
  'เม.ย.',
  'พ.ค.',
  'มิ.ย.',
  'ก.ค.',
  'ส.ค.',
  'ก.ย.',
  'ต.ค.',
  'พ.ย.',
  'ธ.ค.',
];

const List<String> _weekdays = [
  'จันทร์',
  'อังคาร',
  'พุธ',
  'พฤหัสบดี',
  'ศุกร์',
  'เสาร์',
  'อาทิตย์',
];

const List<String> _shortWeekdays = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

String weekdayName(int weekday) => _weekdays[weekday - 1];

String shortWeekday(int weekday) => _shortWeekdays[weekday - 1];

int buddhistYear(int year) => year + 543;

String monthTitle(DateTime date) =>
    '${thaiMonths[date.month - 1]} ${buddhistYear(date.year)}';

String _shortDate(DateTime d) => '${d.day} ${thaiShortMonths[d.month - 1]}';

String dayTitle(DateTime date) =>
    '${weekdayName(date.weekday)} ${_shortDate(date)} '
    '${buddhistYear(date.year)}';

/// [days] as given by [weekDays].
String weekTitle(List<DateTime> days) {
  final first = days.first, last = days.last;
  final end = '${_shortDate(last)} ${buddhistYear(last.year)}';
  if (first.year != last.year) {
    return '${_shortDate(first)} ${buddhistYear(first.year)} – $end';
  }
  if (first.month != last.month) return '${_shortDate(first)} – $end';
  return '${first.day}–$end';
}

// ---------- what falls on each day ----------

/// In the order marks are shown on a day.
enum CalendarKind { holiday, exam, classSession, activity, task }

/// Where an item came from, so tapping it can open the right thing.
enum CalendarSource { weekly, oneTime, task }

typedef CalendarWeekly = ({int id, WeeklyEntry entry});
typedef CalendarOneTime = ({int id, OneTimeEntry entry});

/// An evening task (CLAUDE.md section 14).
class CalendarTask {
  final int id;
  final String title;

  /// The evening it is to be done.
  final DateTime planDate;
  final DateTime? due;
  final bool done;

  /// The task this is one part of.
  final int? parentId;

  /// The original of a split task: only its parts are worked on.
  final bool splitIntoParts;

  const CalendarTask({
    required this.id,
    required this.title,
    required this.planDate,
    this.due,
    this.done = false,
    this.parentId,
    this.splitIntoParts = false,
  });
}

class CalendarItem {
  final CalendarKind kind;
  final CalendarSource source;
  final int sourceId;
  final String title;
  final DateTime date;

  /// Minutes after midnight; both null for what has no time.
  final int? startMinutes;
  final int? endMinutes;

  /// For tasks: finished, and due on this day.
  final bool done;
  final bool dueHere;

  const CalendarItem({
    required this.kind,
    required this.source,
    required this.sourceId,
    required this.title,
    required this.date,
    this.startMinutes,
    this.endMinutes,
    this.done = false,
    this.dueHere = false,
  });

  bool get isTimed => startMinutes != null && endMinutes != null;
}

CalendarKind _kindOf(ItemKind kind) => switch (kind) {
  ItemKind.classSession => CalendarKind.classSession,
  ItemKind.exam => CalendarKind.exam,
  ItemKind.activity => CalendarKind.activity,
  ItemKind.holiday => CalendarKind.holiday,
};

/// Everything on each of [days]: holidays first, then by time, then what has
/// no time, with tasks last.
Map<DateTime, List<CalendarItem>> calendarItems({
  required List<DateTime> days,
  List<CalendarWeekly> weekly = const [],
  List<CalendarOneTime> oneTime = const [],
  List<CalendarTask> tasks = const [],
  DateTime? termStart,
  DateTime? termEnd,
}) {
  final result = {for (final day in days) _dateOnly(day): <CalendarItem>[]};

  for (final MapEntry(key: day, value: items) in result.entries) {
    final todays = [
      for (final o in oneTime)
        if (isSameDay(o.entry.date, day)) o,
    ];
    final todaysEntries = [for (final o in todays) o.entry];
    // How many of today's one-time items the resolver returns by itself.
    final alone = resolveScheduleForDate(
      date: day,
      weeklyEntries: const [],
      oneTimeEntries: todaysEntries,
    ).length;

    for (final w in weekly) {
      if (w.entry.dayOfWeek != day.weekday) continue;
      // Asking about one item at a time keeps track of which one it is.
      final kept =
          resolveScheduleForDate(
            date: day,
            weeklyEntries: [w.entry],
            oneTimeEntries: todaysEntries,
            termStart: termStart,
            termEnd: termEnd,
          ).length >
          alone;
      if (!kept) continue;
      items.add(
        CalendarItem(
          kind: _kindOf(w.entry.kind),
          source: CalendarSource.weekly,
          sourceId: w.id,
          title: w.entry.title,
          date: day,
          startMinutes: w.entry.startMinutes,
          endMinutes: w.entry.endMinutes,
        ),
      );
    }

    for (final o in todays) {
      final holiday = o.entry.kind == ItemKind.holiday;
      final timed =
          !holiday &&
          o.entry.startMinutes != null &&
          o.entry.endMinutes != null;
      items.add(
        CalendarItem(
          kind: _kindOf(o.entry.kind),
          source: CalendarSource.oneTime,
          sourceId: o.id,
          title: o.entry.title,
          date: day,
          startMinutes: timed ? o.entry.startMinutes : null,
          endMinutes: timed ? o.entry.endMinutes : null,
        ),
      );
    }
  }

  for (final task in tasks) {
    final planned = result[_dateOnly(task.planDate)];
    final dueDay = task.due == null ? null : _dateOnly(task.due!);
    // A split task's original has no evening of its own.
    final showPlanned = !task.splitIntoParts;
    // Its parts share its due date, which is shown once, on the original.
    final showDue = task.parentId == null && dueDay != null;
    final done = task.splitIntoParts
        ? tasks.where((t) => t.parentId == task.id).every((t) => t.done)
        : task.done;

    CalendarItem item(DateTime day, {required bool dueHere}) => CalendarItem(
      kind: CalendarKind.task,
      source: CalendarSource.task,
      sourceId: task.id,
      title: task.title,
      date: day,
      done: done,
      dueHere: dueHere,
    );

    final dueWithPlan =
        showPlanned && showDue && isSameDay(dueDay, task.planDate);
    if (showPlanned && planned != null) {
      planned.add(item(_dateOnly(task.planDate), dueHere: dueWithPlan));
    }
    if (showDue && !dueWithPlan) {
      result[dueDay]?.add(item(dueDay, dueHere: true));
    }
  }

  for (final items in result.values) {
    _sort(items);
  }
  return result;
}

void _sort(List<CalendarItem> items) {
  int group(CalendarItem i) => switch (i) {
    CalendarItem(kind: CalendarKind.holiday) => 0,
    CalendarItem(isTimed: true) => 1,
    CalendarItem(kind: CalendarKind.task) => 3,
    _ => 2,
  };
  items.sort((a, b) {
    var order = group(a).compareTo(group(b));
    if (order == 0) {
      order = (a.startMinutes ?? 0).compareTo(b.startMinutes ?? 0);
    }
    return order != 0 ? order : a.sourceId.compareTo(b.sourceId);
  });
}

/// The kinds to mark on a day in the month view, once each. A holiday is shown
/// on the day's number instead.
List<CalendarKind> dayMarks(List<CalendarItem> items) => [
  for (final kind in CalendarKind.values)
    if (kind != CalendarKind.holiday && items.any((i) => i.kind == kind)) kind,
];

/// One mark in a month cell: its kind, and its subject's color if it has one.
typedef DayMark = ({CalendarKind kind, int? color});

const int maxDayMarks = 4;

/// Like [dayMarks], but subjects with their own colors get their own marks.
/// Exams come first, so they are never the ones left out.
List<DayMark> dayColorMarks(
  List<CalendarItem> items,
  int? Function(String title) colorOf,
) {
  final marks = <DayMark>[];
  for (final kind in CalendarKind.values) {
    if (kind == CalendarKind.holiday) continue;
    for (final item in items) {
      if (item.kind != kind) continue;
      final mark = (kind: kind, color: colorOf(item.title));
      if (!marks.contains(mark)) marks.add(mark);
    }
  }
  return marks.length > maxDayMarks ? marks.sublist(0, maxDayMarks) : marks;
}

// ---------- the time grid of the week and day views ----------

const int _defaultFirstHour = 7;
const int _defaultEndHour = 19;

/// The hours the grid shows: the usual day, stretched to fit [items].
({int first, int end}) gridHours(Iterable<CalendarItem> items) {
  var first = _defaultFirstHour;
  var end = _defaultEndHour;
  for (final item in items) {
    if (!item.isTimed) continue;
    first = math.min(first, item.startMinutes! ~/ 60);
    end = math.max(end, (item.endMinutes! + 59) ~/ 60);
  }
  return (first: first, end: end);
}

typedef PlacedItem = ({CalendarItem item, int lane, int laneCount});

/// Places the timed items of one day so that overlapping ones sit side by
/// side. Only items in the same overlapping group share the width.
List<PlacedItem> placeInLanes(List<CalendarItem> items) {
  final sorted = items.where((i) => i.isTimed).toList()
    ..sort((a, b) {
      final order = a.startMinutes!.compareTo(b.startMinutes!);
      return order != 0 ? order : a.sourceId.compareTo(b.sourceId);
    });
  final placed = <PlacedItem>[];
  var group = <({CalendarItem item, int lane})>[];
  final laneEnds = <int>[];
  var groupEnd = 0;

  void closeGroup() {
    for (final entry in group) {
      placed.add((
        item: entry.item,
        lane: entry.lane,
        laneCount: laneEnds.length,
      ));
    }
    group = [];
    laneEnds.clear();
  }

  for (final item in sorted) {
    if (item.startMinutes! >= groupEnd) closeGroup();
    var lane = laneEnds.indexWhere((end) => end <= item.startMinutes!);
    if (lane < 0) {
      lane = laneEnds.length;
      laneEnds.add(item.endMinutes!);
    } else {
      laneEnds[lane] = item.endMinutes!;
    }
    group.add((item: item, lane: lane));
    groupEnd = math.max(groupEnd, item.endMinutes!);
  }
  closeGroup();
  return placed;
}
