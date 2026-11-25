import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/evening_planner.dart';
import 'package:glow/core/schedule_models.dart';

/// Monday evening, 23 November 2026.
DateTime at(int hour, [int minute = 0]) => DateTime(2026, 11, 23, hour, minute);
final tomorrow = DateTime(2026, 11, 24);

const settings = EveningSettings();

/// Rest, dinner, and shower switched off, to test task placement alone.
const bare = EveningSettings(
  restMinutes: 0,
  dinnerMinutes: 0,
  showerMinutes: 0,
);

PlannerTask task(
  int id,
  int minutes, {
  DateTime? due,
  EveningTaskKind kind = EveningTaskKind.homework,
  DateTime? examDate,
  int? order,
}) => PlannerTask(
  id: id,
  title: 'งาน $id',
  minutes: minutes,
  due: due,
  kind: kind,
  examDate: examDate,
  userOrder: order,
);

ScheduleEntry activity(int from, int to, [String title = 'ซ้อม']) =>
    ScheduleEntry(
      title: title,
      kind: ItemKind.activity,
      start: at(from),
      end: at(to),
    );

EveningPlan plan(
  List<PlannerTask> tasks, {
  DateTime? start,
  DateTime? notify,
  List<ScheduleEntry> fixed = const [],
  EveningSettings options = bare,
  bool redNight = false,
  DateTime? from,
}) => planEvening(
  windowStart: start ?? at(17),
  notifyTime: notify ?? at(21),
  fixedActivities: fixed,
  tasks: tasks,
  settings: options,
  eveningDate: at(0),
  redNight: redNight,
  tasksFrom: from,
);

String clock(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// "17:00-17:50 task 1" lines for the blocks of one kind or all of them.
List<String> lines(EveningPlan p, [Set<BlockKind>? kinds]) => [
  for (final b in p.blocks)
    if (kinds == null || kinds.contains(b.kind))
      '${clock(b.start)}-${clock(b.end)} '
          '${b.kind == BlockKind.task ? 'task ${b.taskId}' : b.kind.name}',
];

void main() {
  test('the window ends 15 minutes before the phone-down reminder', () {
    expect(plan([]).end, at(20, 45));
  });

  test('tasks that fit are all placed in order', () {
    final result = plan([task(1, 30), task(2, 20)]);
    expect(lines(result), ['17:00-17:30 task 1', '17:30-17:50 task 2']);
    expect(result.overflow, isEmpty);
  });

  test('a long task is split with a break after 50 minutes', () {
    expect(lines(plan([task(1, 90)])), [
      '17:00-17:50 task 1',
      '17:50-18:00 breakTime',
      '18:00-18:40 task 1',
    ]);
  });

  test('a break also comes after two tasks that add up to 50 minutes', () {
    expect(lines(plan([task(1, 30), task(2, 40)])), [
      '17:00-17:30 task 1',
      '17:30-17:50 task 2',
      '17:50-18:00 breakTime',
      '18:00-18:20 task 2',
    ]);
  });

  test('a split never leaves a piece shorter than 15 minutes', () {
    final pieces = [
      for (final b in plan([task(1, 55)]).blocks)
        if (b.kind == BlockKind.task) b.minutes,
    ];
    expect(pieces, [40, 15]);
  });

  test('a task is split across a fixed activity in pieces of 15+', () {
    final result = plan(
      [task(1, 60)],
      start: at(17),
      fixed: [
        ScheduleEntry(
          title: 'ติว',
          kind: ItemKind.activity,
          start: at(17, 30),
          end: at(18, 30),
        ),
      ],
    );
    expect(lines(result), [
      '17:00-17:30 task 1',
      '17:30-18:30 activity',
      '18:30-19:00 task 1',
    ]);
    expect(result.overflow, isEmpty);
  });

  test('a gap shorter than 15 minutes is left empty', () {
    final result = plan(
      [task(1, 30)],
      fixed: [
        ScheduleEntry(
          title: 'ติว',
          kind: ItemKind.activity,
          start: at(17, 10),
          end: at(18),
        ),
      ],
    );
    expect(lines(result, {BlockKind.task}), ['18:00-18:30 task 1']);
  });

  test('a short task may use less than 15 minutes as a whole', () {
    expect(lines(plan([task(1, 10)])), ['17:00-17:10 task 1']);
  });

  test('work that does not fit is reported with the minutes over', () {
    final result = plan([task(1, 120), task(2, 120)], notify: at(20));
    expect(result.overflow.keys, [2]);
    final placed = result.blocks
        .where((b) => b.taskId == 2)
        .fold(0, (sum, b) => sum + b.minutes);
    expect(placed + result.overflow[2]!, 120);
    expect(result.overflowMinutes, result.overflow[2]);
  });

  test('rest, dinner at 18:30, and a shower at the end', () {
    final result = plan([], options: settings);
    expect(lines(result), [
      '17:00-17:30 rest',
      '18:30-19:15 dinner',
      '20:25-20:45 shower',
    ]);
  });

  test('arriving after 18:30 pushes dinner after the rest', () {
    final result = plan([], start: at(19), notify: at(22), options: settings);
    expect(lines(result, {BlockKind.rest, BlockKind.dinner}), [
      '19:00-19:30 rest',
      '19:30-20:15 dinner',
    ]);
  });

  test('the shower can be set to happen on arrival', () {
    final result = plan(
      [],
      options: const EveningSettings(showerOnArrival: true),
    );
    expect(lines(result).take(2), ['17:00-17:30 rest', '17:30-17:50 shower']);
  });

  test('order: overdue, tomorrow, later, then no due date', () {
    final ordered = orderTasks([
      task(1, 20),
      task(2, 20, due: DateTime(2026, 11, 27)),
      task(3, 20, due: tomorrow),
      task(4, 20, due: DateTime(2026, 11, 20)),
    ], at(0));
    expect([for (final t in ordered) t.id], [4, 3, 2, 1]);
  });

  test('same due date: the nearer exam is studied first', () {
    final ordered = orderTasks([
      task(
        1,
        20,
        kind: EveningTaskKind.examStudy,
        examDate: DateTime(2026, 11, 30),
      ),
      task(
        2,
        20,
        kind: EveningTaskKind.examStudy,
        examDate: DateTime(2026, 11, 25),
      ),
    ], at(0));
    expect([for (final t in ordered) t.id], [2, 1]);
  });

  test("the user's own order beats the automatic one", () {
    final ordered = orderTasks([
      task(1, 20, due: tomorrow, order: 2),
      task(2, 20, order: 1),
      task(3, 20, due: tomorrow),
    ], at(0));
    expect([for (final t in ordered) t.id], [2, 1, 3]);
  });

  test('a day with nothing booked starts at 16:00 or when asked', () {
    expect(eveningWindowStart(at(0), const [], travelMinutes: 30), at(16));
    expect(
      eveningWindowStart(at(0), const [], travelMinutes: 30, startNow: at(14)),
      at(14),
    );
  });

  test('home is the last class or exam plus travel; activities stay fixed', () {
    final day = [
      ScheduleEntry(
        title: 'เลข',
        kind: ItemKind.classSession,
        start: at(8),
        end: at(15),
      ),
      activity(19, 20),
    ];
    expect(eveningWindowStart(at(0), day, travelMinutes: 30), at(15, 30));
  });

  test('a red night only keeps work that is overdue or due tomorrow', () {
    final result = plan([
      task(1, 20),
      task(2, 20, due: tomorrow),
      task(3, 20, due: DateTime(2026, 11, 30)),
      task(4, 20, due: DateTime(2026, 11, 22)),
    ], redNight: true);
    expect(
      [
        for (final b in result.blocks)
          if (b.taskId != null) b.taskId,
      ],
      [4, 2],
    );
    expect(result.postponedForRedNight, [1, 3]);
    expect(result.overflow, isEmpty);
  });

  test('replanning when behind moves the remaining work to now', () {
    final result = plan([task(1, 30)], options: settings, from: at(19, 30));
    expect(lines(result, {BlockKind.task}), ['19:30-20:00 task 1']);
    // Dinner and rest keep their places.
    expect(lines(result, {BlockKind.rest}), ['17:00-17:30 rest']);
  });

  test('behindBy reports the oldest unfinished block', () {
    final result = plan([task(1, 30), task(2, 30)]);
    expect(behindBy(result, at(17, 20)), isNull);
    expect(behindBy(result, at(17, 50)), const Duration(minutes: 20));
  });

  test('nothing is ever placed past the end of the window', () {
    final random = Random(1);
    for (var round = 0; round < 400; round++) {
      final notify = at(18 + random.nextInt(5), random.nextInt(12) * 5);
      final from = 16 + random.nextInt(4);
      final result = planEvening(
        windowStart: at(16, random.nextInt(12) * 5),
        notifyTime: notify,
        fixedActivities: [
          if (random.nextBool()) activity(from, from + 1 + random.nextInt(4)),
        ],
        tasks: [
          for (var i = 0; i < random.nextInt(6); i++)
            task(i, 5 + random.nextInt(40) * 5),
        ],
        settings: EveningSettings(showerOnArrival: random.nextBool()),
        eveningDate: at(0),
        tasksFrom: random.nextBool() ? at(17 + random.nextInt(6)) : null,
      );
      final limit = notify.subtract(const Duration(minutes: 15));
      for (final block in result.blocks) {
        if (block.kind == BlockKind.activity) continue;
        expect(block.end.isAfter(limit), isFalse, reason: 'round $round');
        expect(block.end.isAfter(block.start), isTrue, reason: 'round $round');
      }
      for (var i = 1; i < result.blocks.length; i++) {
        expect(
          result.blocks[i].start.isBefore(result.blocks[i - 1].end),
          isFalse,
          reason: 'round $round overlaps',
        );
      }
    }
  });

  group('study suggestions', () {
    StudyExam exam(String name, int day) =>
        StudyExam(title: name, date: DateTime(2026, 11, day));

    List<String> suggest(
      List<StudyExam> exams, {
      Set<DateTime> already = const {},
      bool full = false,
    }) => [
      for (final s in suggestStudy(
        eveningDate: at(0),
        exams: exams,
        alreadyPlannedExamDates: already,
        eveningIsFull: full,
      ))
        '${s.examTitle} ${s.minutes}${s.lightReview ? ' เบา' : ''}',
    ];

    test('one short session today for each exam within 7 days', () {
      expect(suggest([exam('เลข', 28), exam('เคมี', 30)]), [
        'เลข 30',
        'เคมี 30',
      ]);
    });

    test('a little longer when the exam is close', () {
      expect(suggest([exam('เลข', 25)]), ['เลข 45']);
    });

    test('the night before is only a light review', () {
      expect(suggest([exam('เลข', 24)]), ['เลข 30 เบา']);
    });

    test('spread over days: each earlier evening gets its own session', () {
      var days = 0;
      for (var day = 21; day <= 26; day++) {
        final found = suggestStudy(
          eveningDate: DateTime(2026, 11, day),
          exams: [exam('เลข', 27)],
          alreadyPlannedExamDates: const {},
          eveningIsFull: false,
        );
        expect(found.single.minutes, lessThanOrEqualTo(45));
        days++;
      }
      expect(days, 6);
    });

    test('nothing for far, past, planned, or when the evening is full', () {
      expect(suggest([exam('เลข', 3 + 30), exam('เคมี', 23)]), isEmpty);
      expect(
        suggest([exam('เลข', 26)], already: {DateTime(2026, 11, 26)}),
        isEmpty,
      );
      expect(suggest([exam('เลข', 26)], full: true), isEmpty);
    });
  });
}
