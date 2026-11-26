/// Picks the evening for each part of a split task (CLAUDE.md section 16, job
/// 3), by the same rules as the revision suggestions in section 14: spread
/// over the days before the deadline, and only a light session the night
/// before an exam. The AI never chooses days.
library;

import 'ai_validators.dart';

/// The most the night before an exam may take.
const int lightReviewMaxMinutes = 30;

class ScheduledPart {
  final AiPart part;

  /// The evening it is to be done.
  final DateTime date;

  const ScheduledPart(this.part, this.date);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

/// [parts] stay in order. [firstEvening] is the earliest evening to use.
/// Returns null if the rules can't be kept, e.g. nothing but the night before
/// an exam is left and the parts are too big for it.
List<ScheduledPart>? scheduleParts({
  required List<AiPart> parts,
  required DateTime firstEvening,
  DateTime? due,
  DateTime? examDate,
}) {
  if (parts.isEmpty) return const [];
  final start = _dateOnly(firstEvening);

  // Work is finished the evening before it is due or examined.
  DateTime? deadline;
  for (final date in [due, examDate]) {
    if (date == null) continue;
    final day = _dateOnly(date);
    if (deadline == null || day.isBefore(deadline)) deadline = day;
  }

  var evenings = parts.length;
  if (deadline != null) {
    final available = _calendarDays(start, deadline);
    if (available < evenings) evenings = available < 1 ? 1 : available;
  }

  final nightBeforeExam = examDate == null
      ? null
      : _addDays(_dateOnly(examDate), -1);

  // The night before an exam takes at most the last part, and only if it is
  // short; everything else goes on earlier evenings.
  var earlier = evenings;
  var lightPart = false;
  if (nightBeforeExam != null) {
    final last = _addDays(start, evenings - 1);
    if (!last.isBefore(nightBeforeExam)) {
      earlier = _calendarDays(start, nightBeforeExam);
      if (earlier > evenings) earlier = evenings;
      lightPart = parts.last.minutes <= lightReviewMaxMinutes;
    }
  }

  final spread = lightPart ? parts.length - 1 : parts.length;
  if (earlier < 1) {
    // Only the night before the exam (or the exam day) is left.
    if (nightBeforeExam != start || parts.length != 1 || !lightPart) {
      return null;
    }
    return [ScheduledPart(parts.single, start)];
  }

  final result = <ScheduledPart>[
    for (var i = 0; i < spread; i++)
      // Evenly spaced, so no evening gets more than its share.
      ScheduledPart(parts[i], _addDays(start, i * earlier ~/ spread)),
  ];
  if (lightPart) result.add(ScheduledPart(parts.last, nightBeforeExam!));
  return result;
}

int _calendarDays(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;
