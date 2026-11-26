import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calendar_view.dart';
import '../../data/database.dart';
import '../../data/schedule_repository.dart';
import '../../providers.dart';

/// `EveningTasks.status` of the hidden original of a split task.
const int _doneStatus = 1;
const int _splitStatus = 2;

/// What the calendar draws from, and the saved rows behind each item.
class CalendarData {
  final List<WeeklyItem> weekly;
  final List<OneTimeItem> oneTime;
  final List<EveningTask> tasks;
  final DateTime? termStart;
  final DateTime? termEnd;
  final int firstWeekday;

  const CalendarData({
    required this.weekly,
    required this.oneTime,
    required this.tasks,
    required this.termStart,
    required this.termEnd,
    required this.firstWeekday,
  });

  Map<DateTime, List<CalendarItem>> itemsFor(List<DateTime> days) {
    final weeklyEntries = toCoreWeeklyEntries(weekly);
    final oneTimeEntries = toCoreOneTimeEntries(oneTime);
    return calendarItems(
      days: days,
      weekly: [
        for (var i = 0; i < weekly.length; i++)
          (id: weekly[i].id, entry: weeklyEntries[i]),
      ],
      oneTime: [
        for (var i = 0; i < oneTime.length; i++)
          (id: oneTime[i].id, entry: oneTimeEntries[i]),
      ],
      tasks: [
        for (final t in tasks)
          CalendarTask(
            id: t.id,
            title: t.title,
            planDate: t.planDate,
            due: t.dueDate,
            done: t.status == _doneStatus,
            parentId: t.parentId,
            splitIntoParts: t.status == _splitStatus,
          ),
      ],
      termStart: termStart,
      termEnd: termEnd,
    );
  }

  WeeklyItem? weeklyById(int id) => weekly.where((i) => i.id == id).firstOrNull;

  OneTimeItem? oneTimeById(int id) =>
      oneTime.where((i) => i.id == id).firstOrNull;

  EveningTask? taskById(int id) => tasks.where((t) => t.id == id).firstOrNull;

  /// The original of a split task is changed through its parts.
  bool isSplitOriginal(CalendarItem item) =>
      item.source == CalendarSource.task &&
      taskById(item.sourceId)?.status == _splitStatus;

  bool isOutsideTerm(DateTime day) =>
      (termStart != null &&
          day.isBefore(
            DateTime(termStart!.year, termStart!.month, termStart!.day),
          )) ||
      (termEnd != null && day.isAfter(termEnd!));
}

/// Null until everything has loaded.
final calendarDataProvider = Provider.autoDispose<CalendarData?>((ref) {
  final weekly = ref.watch(weeklyItemsStreamProvider).value;
  final oneTime = ref.watch(oneTimeItemsStreamProvider).value;
  final tasks = ref.watch(eveningTasksStreamProvider).value;
  final settings = ref.watch(settingsStreamProvider).value;
  if (weekly == null ||
      oneTime == null ||
      tasks == null ||
      settings == null) {
    return null;
  }
  return CalendarData(
    weekly: weekly,
    oneTime: oneTime,
    tasks: tasks,
    termStart: settings.termStart,
    termEnd: settings.termEnd,
    firstWeekday: settings.calendarFirstWeekday,
  );
});
