/// Lays out tonight's work between getting home and putting the phone down
/// (CLAUDE.md section 14). The plan always ends before the reminder: work
/// that doesn't fit is reported, never pushed into sleep.
library;

import 'schedule_models.dart';

enum EveningTaskKind { homework, reading, examStudy, other }

/// A split task never gets a piece shorter than this.
const int minPieceMinutes = 15;

const int _quietDayStartHour = 16;
const int _suggestionDays = 7;

class EveningSettings {
  final int restMinutes;
  final int dinnerMinutes;
  final int dinnerStartMinutes;
  final int showerMinutes;
  final bool showerOnArrival;
  final int maxFocusMinutes;
  final int breakMinutes;
  final int bufferBeforeNotifyMinutes;

  const EveningSettings({
    this.restMinutes = 30,
    this.dinnerMinutes = 45,
    this.dinnerStartMinutes = 18 * 60 + 30,
    this.showerMinutes = 20,
    this.showerOnArrival = false,
    this.maxFocusMinutes = 50,
    this.breakMinutes = 10,
    this.bufferBeforeNotifyMinutes = 15,
  });
}

class PlannerTask {
  final int id;
  final String title;

  /// Minutes still to do.
  final int minutes;
  final DateTime? due;
  final EveningTaskKind kind;
  final DateTime? examDate;

  /// Set once the user has reordered the list by hand.
  final int? userOrder;

  const PlannerTask({
    required this.id,
    required this.title,
    required this.minutes,
    required this.kind,
    this.due,
    this.examDate,
    this.userOrder,
  });
}

enum BlockKind { activity, rest, dinner, shower, task, breakTime }

class EveningBlock {
  final BlockKind kind;
  final DateTime start;
  final DateTime end;
  final String title;
  final int? taskId;

  const EveningBlock({
    required this.kind,
    required this.start,
    required this.end,
    required this.title,
    this.taskId,
  });

  int get minutes => end.difference(start).inMinutes;
}

class EveningPlan {
  final DateTime start;

  /// The latest anything may end: the reminder minus the buffer.
  final DateTime end;
  final List<EveningBlock> blocks;

  /// Task id to the minutes that didn't fit.
  final Map<int, int> overflow;

  /// On a red night, tasks that can wait and were left out.
  final List<int> postponedForRedNight;

  const EveningPlan({
    required this.start,
    required this.end,
    required this.blocks,
    required this.overflow,
    required this.postponedForRedNight,
  });

  int get overflowMinutes => overflow.values.fold(0, (a, b) => a + b);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// When the evening starts. Home is the end of the last class or exam plus
/// travel; activities after that are fixed blocks inside the evening. A day
/// without classes starts at 16:00, or when the user says so.
DateTime eveningWindowStart(
  DateTime eveningDate,
  List<ScheduleEntry> entries, {
  required int travelMinutes,
  DateTime? startNow,
}) {
  DateTime? lastClassEnd;
  for (final entry in entries) {
    if (entry.kind == ItemKind.activity) continue;
    if (lastClassEnd == null || entry.end.isAfter(lastClassEnd)) {
      lastClassEnd = entry.end;
    }
  }
  if (lastClassEnd != null) {
    return lastClassEnd.add(Duration(minutes: travelMinutes));
  }
  return startNow ??
      DateTime(
        eveningDate.year,
        eveningDate.month,
        eveningDate.day,
        _quietDayStartHour,
      );
}

/// The user's order first; otherwise overdue, then by due date, then tasks
/// with none. Ties go to the nearer exam.
List<PlannerTask> orderTasks(List<PlannerTask> tasks, DateTime eveningDate) {
  final today = _dateOnly(eveningDate);
  // Overdue work (including due today) all counts as most urgent.
  int dueRank(PlannerTask t) {
    if (t.due == null) return 1 << 20;
    final days = _dateOnly(t.due!).difference(today).inDays;
    return days < 0 ? 0 : days;
  }

  int examRank(PlannerTask t) =>
      t.examDate == null ? 1 << 20 : t.examDate!.difference(today).inDays;

  final indexed = tasks.asMap().entries.toList()
    ..sort((a, b) {
      final x = a.value;
      final y = b.value;
      final byUser = (x.userOrder ?? 1 << 20).compareTo(y.userOrder ?? 1 << 20);
      if (byUser != 0) return byUser;
      final byDue = dueRank(x).compareTo(dueRank(y));
      if (byDue != 0) return byDue;
      final byExam = examRank(x).compareTo(examRank(y));
      return byExam != 0 ? byExam : a.key.compareTo(b.key);
    });
  return [for (final entry in indexed) entry.value];
}

class _Span {
  final DateTime start;
  final DateTime end;
  const _Span(this.start, this.end);
  int get minutes => end.difference(start).inMinutes;
}

/// The parts of [start]..[end] not covered by [taken].
List<_Span> _gaps(DateTime start, DateTime end, List<EveningBlock> taken) {
  final sorted = taken.toList()..sort((a, b) => a.start.compareTo(b.start));
  final result = <_Span>[];
  var cursor = start;
  for (final block in sorted) {
    if (block.start.isAfter(cursor)) {
      final stop = block.start.isBefore(end) ? block.start : end;
      if (stop.isAfter(cursor)) result.add(_Span(cursor, stop));
    }
    if (block.end.isAfter(cursor)) cursor = block.end;
  }
  if (end.isAfter(cursor)) result.add(_Span(cursor, end));
  return result;
}

/// Builds the evening. Rest, dinner, and the shower are placed from
/// [windowStart]; tasks go into what's left, no earlier than [tasksFrom]
/// (used to move the work along when running late or finishing early).
EveningPlan planEvening({
  required DateTime windowStart,
  required DateTime notifyTime,
  required List<ScheduleEntry> fixedActivities,
  required List<PlannerTask> tasks,
  required EveningSettings settings,
  required DateTime eveningDate,
  bool redNight = false,
  DateTime? tasksFrom,
}) {
  final end = notifyTime.subtract(
    Duration(minutes: settings.bufferBeforeNotifyMinutes),
  );
  final blocks = <EveningBlock>[];

  // Timetabled activities can't be moved, even if they run past the end.
  final activities =
      fixedActivities.where((a) => a.end.isAfter(windowStart)).toList()
        ..sort((a, b) => a.start.compareTo(b.start));
  var covered = windowStart;
  for (final activity in activities) {
    final from = activity.start.isAfter(covered) ? activity.start : covered;
    if (!activity.end.isAfter(from)) continue;
    blocks.add(
      EveningBlock(
        kind: BlockKind.activity,
        start: from,
        end: activity.end,
        title: activity.title,
      ),
    );
    covered = activity.end;
  }

  /// Puts a daily block in the first gap at or after [notBefore] that holds
  /// all of it; skipped if there is none.
  void place(
    BlockKind kind,
    String title,
    int minutes,
    DateTime notBefore, {
    bool latest = false,
  }) {
    if (minutes <= 0) return;
    final gaps = _gaps(windowStart, end, blocks);
    for (final gap in latest ? gaps.reversed : gaps) {
      final from = gap.start.isAfter(notBefore) ? gap.start : notBefore;
      if (gap.end.difference(from).inMinutes < minutes) continue;
      final start = latest
          ? gap.end.subtract(Duration(minutes: minutes))
          : from;
      blocks.add(
        EveningBlock(
          kind: kind,
          start: start,
          end: start.add(Duration(minutes: minutes)),
          title: title,
        ),
      );
      return;
    }
  }

  place(BlockKind.rest, 'พักหลังถึงบ้าน', settings.restMinutes, windowStart);
  if (settings.showerOnArrival) {
    place(BlockKind.shower, 'อาบน้ำ', settings.showerMinutes, windowStart);
  }
  final dinnerAt = DateTime(
    eveningDate.year,
    eveningDate.month,
    eveningDate.day,
  ).add(Duration(minutes: settings.dinnerStartMinutes));
  place(
    BlockKind.dinner,
    'ข้าวเย็น',
    settings.dinnerMinutes,
    dinnerAt.isAfter(windowStart) ? dinnerAt : windowStart,
  );
  if (!settings.showerOnArrival) {
    place(
      BlockKind.shower,
      'อาบน้ำ',
      settings.showerMinutes,
      windowStart,
      latest: true,
    );
  }

  // On a red night only what can't wait is placed.
  final tomorrow = DateTime(
    eveningDate.year,
    eveningDate.month,
    eveningDate.day + 1,
  );
  final postponed = <int>[];
  final queue = <PlannerTask>[];
  for (final task in orderTasks(tasks, eveningDate)) {
    final urgent = task.due != null && !_dateOnly(task.due!).isAfter(tomorrow);
    if (redNight && !urgent) {
      postponed.add(task.id);
    } else if (task.minutes > 0) {
      queue.add(task);
    }
  }
  postponed.sort();

  final from = tasksFrom != null && tasksFrom.isAfter(windowStart)
      ? tasksFrom
      : windowStart;
  final free = _gaps(from, end, blocks);
  final remaining = {for (final t in queue) t.id: t.minutes};

  var taskIndex = 0;
  for (final gap in free) {
    var cursor = gap.start;
    // A fixed block in between already counts as a break.
    var focused = 0;
    while (taskIndex < queue.length) {
      final task = queue[taskIndex];
      final left = remaining[task.id]!;
      // The smallest piece worth starting.
      final smallest = left < minPieceMinutes ? left : minPieceMinutes;
      final room = gap.end.difference(cursor).inMinutes;

      if (settings.maxFocusMinutes - focused < smallest && focused > 0) {
        // Only take a break if there is room to work after it.
        if (room - settings.breakMinutes < smallest) break;
        final breakEnd = cursor.add(Duration(minutes: settings.breakMinutes));
        blocks.add(
          EveningBlock(
            kind: BlockKind.breakTime,
            start: cursor,
            end: breakEnd,
            title: 'พัก',
          ),
        );
        cursor = breakEnd;
        focused = 0;
        continue;
      }
      if (room < smallest) break;

      var piece = [
        left,
        room,
        settings.maxFocusMinutes - focused,
      ].reduce((a, b) => a < b ? a : b);
      // Don't strand a tiny tail: shorten this piece so the rest is usable.
      final tail = left - piece;
      if (tail > 0 && tail < minPieceMinutes) {
        piece = left - minPieceMinutes;
        if (piece < minPieceMinutes) break;
      }

      final pieceEnd = cursor.add(Duration(minutes: piece));
      blocks.add(
        EveningBlock(
          kind: BlockKind.task,
          start: cursor,
          end: pieceEnd,
          title: task.title,
          taskId: task.id,
        ),
      );
      cursor = pieceEnd;
      focused += piece;
      remaining[task.id] = left - piece;
      if (remaining[task.id] == 0) taskIndex++;
    }
  }

  blocks.sort((a, b) => a.start.compareTo(b.start));
  return EveningPlan(
    start: windowStart,
    end: end,
    blocks: blocks,
    overflow: {
      for (final entry in remaining.entries)
        if (entry.value > 0) entry.key: entry.value,
    },
    postponedForRedNight: postponed,
  );
}

/// How far behind the plan is: the time since the oldest unfinished task
/// block should have ended. Null when on schedule.
Duration? behindBy(EveningPlan plan, DateTime now) {
  for (final block in plan.blocks) {
    if (block.kind != BlockKind.task) continue;
    return block.end.isBefore(now) ? now.difference(block.end) : null;
  }
  return null;
}

class StudyExam {
  final String title;
  final DateTime date;
  const StudyExam({required this.title, required this.date});
}

class StudySuggestion {
  final String examTitle;
  final DateTime examDate;
  final int minutes;

  /// The night before the exam.
  final bool lightReview;

  const StudySuggestion({
    required this.examTitle,
    required this.examDate,
    required this.minutes,
    required this.lightReview,
  });
}

/// Today's revision ideas in exam mode: one short session per exam each day,
/// so it's spread out instead of crammed. The user has to accept them.
List<StudySuggestion> suggestStudy({
  required DateTime eveningDate,
  required List<StudyExam> exams,
  required Set<DateTime> alreadyPlannedExamDates,
  required bool eveningIsFull,
}) {
  if (eveningIsFull) return const [];
  final today = _dateOnly(eveningDate);
  final result = <StudySuggestion>[];
  final sorted = exams.toList()..sort((a, b) => a.date.compareTo(b.date));
  for (final exam in sorted) {
    final date = _dateOnly(exam.date);
    final days = date.difference(today).inDays;
    if (days < 1 || days > _suggestionDays) continue;
    if (alreadyPlannedExamDates.contains(date)) continue;
    final lightReview = days == 1;
    result.add(
      StudySuggestion(
        examTitle: exam.title,
        examDate: date,
        minutes: lightReview || days > 3 ? 30 : 45,
        lightReview: lightReview,
      ),
    );
  }
  return result;
}
