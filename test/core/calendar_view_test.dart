import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/calendar_view.dart';
import 'package:glow/core/schedule_models.dart';

const _sunday = DateTime.sunday;
const _monday = DateTime.monday;

CalendarWeekly _weekly(
  int id,
  int day,
  int from,
  int to, {
  ItemKind kind = ItemKind.classSession,
  String? title,
}) => (
  id: id,
  entry: WeeklyEntry(
    title: title ?? 'w$id',
    dayOfWeek: day,
    startMinutes: from * 60,
    endMinutes: to * 60,
    kind: kind,
  ),
);

CalendarOneTime _once(
  int id,
  DateTime date,
  ItemKind kind, {
  int? from,
  int? to,
}) => (
  id: id,
  entry: OneTimeEntry(
    title: 'o$id',
    date: date,
    kind: kind,
    startMinutes: from == null ? null : from * 60,
    endMinutes: to == null ? null : to * 60,
  ),
);

List<CalendarItem> _on(
  DateTime date, {
  List<CalendarWeekly> weekly = const [],
  List<CalendarOneTime> oneTime = const [],
  List<CalendarTask> tasks = const [],
  DateTime? termStart,
  DateTime? termEnd,
}) => calendarItems(
  days: [date],
  weekly: weekly,
  oneTime: oneTime,
  tasks: tasks,
  termStart: termStart,
  termEnd: termEnd,
)[date]!;

void main() {
  // 26 November 2026 is a Thursday, so 1 November is a Sunday.
  final today = DateTime(2026, 11, 26);

  group('first day of the week', () {
    test('Sunday or Monday', () {
      expect(startOfWeek(today, _sunday), DateTime(2026, 11, 22));
      expect(startOfWeek(today, _monday), DateTime(2026, 11, 23));
    });

    test('a day that starts the week is its own start', () {
      expect(
        startOfWeek(DateTime(2026, 11, 22, 23, 59), _sunday),
        DateTime(2026, 11, 22),
      );
      expect(
        startOfWeek(DateTime(2026, 11, 23), _monday),
        DateTime(2026, 11, 23),
      );
      // Under a Monday start, Sunday ends the week before.
      expect(
        startOfWeek(DateTime(2026, 11, 22), _monday),
        DateTime(2026, 11, 16),
      );
    });

    test('orders the columns', () {
      expect(weekdayOrder(_sunday), [7, 1, 2, 3, 4, 5, 6]);
      expect(weekdayOrder(_monday), [1, 2, 3, 4, 5, 6, 7]);
      expect(
        weekdayOrder(_sunday).map(shortWeekday),
        ['อา', 'จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส'],
      );
    });

    test('a week is seven days from it, across a year', () {
      final days = weekDays(DateTime(2027, 1, 1), _sunday);
      expect(days.first, DateTime(2026, 12, 27));
      expect(days.last, DateTime(2027, 1, 2));
      expect(days, hasLength(7));
    });
  });

  group('month grid', () {
    void whole(List<DateTime> days, int firstWeekday) {
      expect(days.length % 7, 0);
      expect(days.first.weekday, firstWeekday);
      for (var i = 1; i < days.length; i++) {
        final previous = days[i - 1];
        expect(
          days[i],
          DateTime(previous.year, previous.month, previous.day + 1),
        );
      }
    }

    test('covers the month with whole weeks only', () {
      final sunday = monthDays(today, _sunday);
      whole(sunday, _sunday);
      expect(sunday.first, DateTime(2026, 11, 1));
      expect(sunday.last, DateTime(2026, 12, 5));

      final monday = monthDays(today, _monday);
      whole(monday, _monday);
      expect(monday.first, DateTime(2026, 10, 26));
      expect(monday.last, DateTime(2026, 12, 6));
    });

    test('a February that fits four weeks exactly', () {
      final days = monthDays(DateTime(2026, 2, 14), _sunday);
      expect(days, hasLength(28));
      expect(days.first, DateTime(2026, 2, 1));
      expect(days.last, DateTime(2026, 2, 28));
      expect(monthDays(DateTime(2026, 2, 14), _monday), hasLength(35));
    });

    test('a leap year has 29 February', () {
      for (final first in [_sunday, _monday]) {
        final days = monthDays(DateTime(2028, 2, 1), first);
        whole(days, first);
        expect(days, contains(DateTime(2028, 2, 29)));
        expect(days.where((d) => d.month == 2), hasLength(29));
      }
      expect(
        monthDays(DateTime(2027, 2, 1), _sunday).where((d) => d.month == 2),
        hasLength(28),
      );
    });

    test('a month can need six weeks', () {
      // August 2026 starts on a Saturday.
      expect(monthDays(DateTime(2026, 8, 1), _sunday), hasLength(42));
    });
  });

  group('moving between periods', () {
    test('a month keeps the day, or takes the last one there is', () {
      expect(
        shiftPeriod(CalendarMode.month, DateTime(2027, 1, 31), 1),
        DateTime(2027, 2, 28),
      );
      expect(
        shiftPeriod(CalendarMode.month, DateTime(2028, 1, 31), 1),
        DateTime(2028, 2, 29),
      );
      expect(
        shiftPeriod(CalendarMode.month, DateTime(2026, 1, 15), -1),
        DateTime(2025, 12, 15),
      );
    });

    test('a week or a day', () {
      expect(
        shiftPeriod(CalendarMode.week, DateTime(2026, 12, 28), 1),
        DateTime(2027, 1, 4),
      );
      expect(
        shiftPeriod(CalendarMode.day, DateTime(2028, 3, 1), -1),
        DateTime(2028, 2, 29),
      );
    });
  });

  group('Thai titles with Buddhist years', () {
    test('month', () {
      expect(buddhistYear(2026), 2569);
      expect(monthTitle(today), 'พฤศจิกายน 2569');
      expect(monthTitle(DateTime(2027, 1, 1)), 'มกราคม 2570');
    });

    test('day', () {
      expect(dayTitle(today), 'พฤหัสบดี 26 พ.ย. 2569');
      expect(dayTitle(DateTime(2028, 2, 29)), 'อังคาร 29 ก.พ. 2571');
    });

    test('week, within a month, across months, and across years', () {
      expect(
        weekTitle(weekDays(DateTime(2026, 11, 11), _sunday)),
        '8–14 พ.ย. 2569',
      );
      expect(
        weekTitle(weekDays(today, _monday)),
        '23–29 พ.ย. 2569',
      );
      expect(
        weekTitle(weekDays(DateTime(2026, 11, 30), _sunday)),
        '29 พ.ย. – 5 ธ.ค. 2569',
      );
      expect(
        weekTitle(weekDays(DateTime(2027, 1, 1), _sunday)),
        '27 ธ.ค. 2569 – 2 ม.ค. 2570',
      );
    });
  });

  group('what falls on a day', () {
    final math = _weekly(1, DateTime.thursday, 8, 9);

    test('weekly items on their weekday only', () {
      expect(_on(today, weekly: [math]).single.sourceId, 1);
      expect(_on(DateTime(2026, 11, 27), weekly: [math]), isEmpty);
    });

    test('only within the term', () {
      expect(
        _on(today, weekly: [math], termStart: DateTime(2026, 12, 1)),
        isEmpty,
      );
      expect(_on(today, weekly: [math], termEnd: today), hasLength(1));
      expect(
        _on(today, weekly: [math], termEnd: DateTime(2026, 11, 25)),
        isEmpty,
      );
    });

    test('a holiday cancels classes but not activities', () {
      final items = _on(
        today,
        weekly: [
          math,
          _weekly(2, DateTime.thursday, 17, 18, kind: ItemKind.activity),
        ],
        oneTime: [_once(9, today, ItemKind.holiday)],
      );
      expect(items.map((i) => i.kind), [
        CalendarKind.holiday,
        CalendarKind.activity,
      ]);
    });

    test('a one-time item replaces the class it overlaps', () {
      final items = _on(
        today,
        weekly: [math, _weekly(2, DateTime.thursday, 10, 11)],
        oneTime: [_once(9, today, ItemKind.exam, from: 8, to: 10)],
      );
      expect(items.map((i) => (i.kind, i.sourceId)), [
        (CalendarKind.exam, 9),
        (CalendarKind.classSession, 2),
      ]);
    });

    test('two classes with the same name and time are both shown', () {
      final items = _on(
        today,
        weekly: [
          _weekly(1, DateTime.thursday, 8, 9, title: 'x'),
          _weekly(2, DateTime.thursday, 8, 9, title: 'x'),
        ],
      );
      expect(items.map((i) => i.sourceId), [1, 2]);
    });

    test('a one-time item without a time still shows', () {
      final item = _on(
        today,
        oneTime: [_once(3, today, ItemKind.exam)],
      ).single;
      expect(item.startMinutes, isNull);
      expect(item.source, CalendarSource.oneTime);
    });

    test('holiday first, then by time, then what has no time', () {
      final items = _on(
        today,
        weekly: [
          _weekly(1, DateTime.thursday, 17, 18, kind: ItemKind.activity),
        ],
        oneTime: [
          _once(2, today, ItemKind.activity),
          _once(3, today, ItemKind.exam, from: 9, to: 10),
          _once(4, today, ItemKind.holiday),
        ],
        tasks: [CalendarTask(id: 5, title: 't', planDate: today)],
      );
      expect(items.map((i) => i.sourceId), [4, 3, 1, 2, 5]);
    });

    test('every day asked for is there, even an empty one', () {
      final days = monthDays(today, _sunday);
      final result = calendarItems(days: days, weekly: [math]);
      expect(result.keys, days);
      expect(result.values.expand((v) => v), hasLength(5));
    });
  });

  group('tasks', () {
    final tomorrow = DateTime(2026, 11, 27);

    test('show on the evening planned and on the due date', () {
      final task = CalendarTask(
        id: 1,
        title: 'รายงาน',
        planDate: today,
        due: tomorrow,
      );
      final planned = _on(today, tasks: [task]).single;
      expect((planned.kind, planned.dueHere), (CalendarKind.task, false));
      final due = _on(tomorrow, tasks: [task]).single;
      expect(due.dueHere, isTrue);
    });

    test('due the same evening shows once', () {
      final item = _on(
        today,
        tasks: [
          CalendarTask(id: 1, title: 't', planDate: today, due: today),
        ],
      ).single;
      expect(item.dueHere, isTrue);
    });

    test('a split task shows its parts, and its due date once', () {
      final tasks = [
        CalendarTask(
          id: 1,
          title: 'โครงงาน',
          planDate: today,
          due: DateTime(2026, 11, 30),
          splitIntoParts: true,
        ),
        CalendarTask(
          id: 2,
          title: 'ส่วน 1',
          planDate: today,
          due: DateTime(2026, 11, 30),
          parentId: 1,
          done: true,
        ),
        CalendarTask(
          id: 3,
          title: 'ส่วน 2',
          planDate: tomorrow,
          due: DateTime(2026, 11, 30),
          parentId: 1,
        ),
      ];
      expect(_on(today, tasks: tasks).map((i) => i.title), ['ส่วน 1']);
      final due = _on(DateTime(2026, 11, 30), tasks: tasks).single;
      expect((due.title, due.done), ('โครงงาน', false));
    });

    test('the whole split task is done once every part is', () {
      final tasks = [
        CalendarTask(
          id: 1,
          title: 'โครงงาน',
          planDate: today,
          due: tomorrow,
          splitIntoParts: true,
        ),
        CalendarTask(
          id: 2,
          title: 'ส่วน 1',
          planDate: today,
          parentId: 1,
          done: true,
        ),
      ];
      expect(_on(tomorrow, tasks: tasks).single.done, isTrue);
    });
  });

  test('marks on a day: one of each kind there is, exams first', () {
    final items = _on(
      today,
      weekly: [
        _weekly(1, DateTime.thursday, 8, 9),
        _weekly(2, DateTime.thursday, 9, 10),
        _weekly(3, DateTime.thursday, 17, 18, kind: ItemKind.activity),
      ],
      oneTime: [_once(4, today, ItemKind.exam, from: 13, to: 14)],
      tasks: [CalendarTask(id: 5, title: 't', planDate: today)],
    );
    expect(dayMarks(items), [
      CalendarKind.exam,
      CalendarKind.classSession,
      CalendarKind.activity,
      CalendarKind.task,
    ]);
    // A holiday is shown on the day number, not as a mark.
    expect(
      dayMarks(_on(today, oneTime: [_once(1, today, ItemKind.holiday)])),
      isEmpty,
    );
  });

  test('subjects with their own colors get their own marks', () {
    final items = _on(
      today,
      weekly: [
        _weekly(1, DateTime.thursday, 8, 9, title: 'a'),
        _weekly(2, DateTime.thursday, 9, 10, title: 'b'),
        _weekly(3, DateTime.thursday, 10, 11, title: 'c'),
        _weekly(4, DateTime.thursday, 11, 12, title: 'd'),
        _weekly(5, DateTime.thursday, 12, 13, title: 'e'),
      ],
      oneTime: [_once(6, today, ItemKind.exam, from: 14, to: 15)],
    );
    final colors = {'a': 1, 'b': 1, 'c': 2};
    final marks = dayColorMarks(items, (title) => colors[title]);
    // Two reds share a mark; there is room for four, exam first.
    expect(marks, [
      (kind: CalendarKind.exam, color: null),
      (kind: CalendarKind.classSession, color: 1),
      (kind: CalendarKind.classSession, color: 2),
      (kind: CalendarKind.classSession, color: null),
    ]);
  });

  group('time grid', () {
    List<CalendarItem> timed(List<(int, int)> spans) => [
      for (final (i, (from, to)) in spans.indexed)
        CalendarItem(
          kind: CalendarKind.classSession,
          source: CalendarSource.weekly,
          sourceId: i,
          title: '$i',
          date: today,
          startMinutes: from,
          endMinutes: to,
        ),
    ];

    test('shows 07:00 to 19:00, wider if something is outside it', () {
      expect(gridHours(const []), (first: 7, end: 19));
      expect(gridHours(timed([(6 * 60 + 30, 8 * 60)])), (first: 6, end: 19));
      expect(
        gridHours(timed([(20 * 60, 22 * 60 + 10)])),
        (first: 7, end: 23),
      );
      expect(gridHours(timed([(23 * 60, 24 * 60)])), (first: 7, end: 24));
    });

    test('items that overlap sit side by side', () {
      final placed = placeInLanes(timed([(480, 600), (540, 660), (700, 760)]));
      expect(
        placed.map((p) => (p.item.sourceId, p.lane, p.laneCount)),
        [(0, 0, 2), (1, 1, 2), (2, 0, 1)],
      );
    });

    test('a free lane is used again within a group', () {
      final placed = placeInLanes(timed([(480, 720), (480, 540), (540, 600)]));
      expect(placed.every((p) => p.laneCount == 2), isTrue);
      expect(placed.map((p) => p.lane).toSet(), {0, 1});
    });

    test('items that only touch are not an overlap', () {
      final placed = placeInLanes(timed([(480, 540), (540, 600)]));
      expect(placed.every((p) => p.laneCount == 1), isTrue);
    });

    test('what has no time is left out of the grid', () {
      final items = [
        CalendarItem(
          kind: CalendarKind.task,
          source: CalendarSource.task,
          sourceId: 1,
          title: 't',
          date: today,
        ),
      ];
      expect(placeInLanes(items), isEmpty);
      expect(gridHours(items), (first: 7, end: 19));
    });
  });

  test('knows today from the time given', () {
    expect(isSameDay(today, DateTime(2026, 11, 26, 23, 59)), isTrue);
    expect(isSameDay(today, DateTime(2026, 11, 27)), isFalse);
  });
}
