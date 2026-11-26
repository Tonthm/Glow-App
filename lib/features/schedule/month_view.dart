import 'package:material_ui/material_ui.dart';

import '../../core/calendar_view.dart';
import '../../core/subject_color.dart';
import '../../theme/tokens.dart';
import 'calendar_marks.dart';

/// A month as on a wall calendar, with marks for what each day holds.
class MonthView extends StatelessWidget {
  /// Any day of the month shown.
  final DateTime month;
  final DateTime today;
  final int firstWeekday;
  final Map<DateTime, List<CalendarItem>> items;
  final ValueChanged<DateTime> onDayTap;
  final Map<String, int> colors;

  const MonthView({
    super.key,
    required this.month,
    required this.today,
    required this.firstWeekday,
    required this.items,
    required this.onDayTap,
    this.colors = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final days = monthDays(month, firstWeekday);
    // Cells grow with the phone's text size.
    final cellHeight =
        MediaQuery.textScalerOf(context).scale(GlowFontSize.body) + 33;

    return Column(
      children: [
        Row(
          children: [
            for (final weekday in weekdayOrder(firstWeekday))
              Expanded(
                child: Text(
                  shortWeekday(weekday),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
          ],
        ),
        const SizedBox(height: GlowSpacing.xs),
        for (var week = 0; week < days.length; week += 7)
          Container(
            height: cellHeight,
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: theme.dividerColor,
                  width: GlowStroke.divider,
                ),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final day in days.sublist(week, week + 7))
                  Expanded(
                    child: _DayCell(
                      day: day,
                      inMonth: day.month == month.month,
                      isToday: isSameDay(day, today),
                      items: items[day] ?? const [],
                      colors: colors,
                      onTap: () => onDayTap(day),
                    ),
                  ),
              ],
            ),
          ),
        const SizedBox(height: GlowSpacing.sm),
        const _Legend(),
      ],
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime day;
  final bool inMonth;
  final bool isToday;
  final List<CalendarItem> items;
  final VoidCallback onTap;
  final Map<String, int> colors;

  const _DayCell({
    required this.colors,
    required this.day,
    required this.inMonth,
    required this.isToday,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final holiday = items.any((i) => i.kind == CalendarKind.holiday);
    final marks = dayMarks(items);
    final fill = isToday
        ? theme.colorScheme.primary
        : holiday
        ? calendarKindFill(context, CalendarKind.holiday)
        : null;
    final number = theme.textTheme.bodyLarge!.copyWith(
      color: isToday
          ? theme.colorScheme.onPrimary
          : inMonth
          ? theme.colorScheme.onSurface
          : theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.55),
      fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
      height: 1.2,
    );
    final words = [
      dayTitle(day),
      if (isToday) 'วันนี้',
      if (holiday) 'วันหยุด',
      for (final kind in marks)
        '${calendarKindLabel(kind)} '
            '${items.where((i) => i.kind == kind).length}',
    ];

    return Semantics(
      label: words.join(' '),
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: const BoxConstraints(minWidth: 30, minHeight: 28),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: fill,
                borderRadius: BorderRadius.circular(GlowRadius.pill),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text('${day.day}', style: number),
              ),
            ),
            const SizedBox(height: 3),
            SizedBox(
              height: 9,
              child: Opacity(
                opacity: inMonth ? 1 : 0.5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final mark in dayColorMarks(
                      items,
                      (title) => colorOfSubject(colors, title),
                    ))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: CalendarMark(
                          mark.kind,
                          subjectColor: mark.color,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyMedium;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: GlowSpacing.md,
      children: [
        for (final kind in CalendarKind.values)
          if (kind != CalendarKind.holiday)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarMark(kind, size: 8),
                const SizedBox(width: GlowSpacing.xs),
                Text(calendarKindLabel(kind), style: style),
              ],
            ),
      ],
    );
  }
}
