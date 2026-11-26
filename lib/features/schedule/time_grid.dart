import 'package:material_ui/material_ui.dart';

import '../../core/calendar_view.dart';
import '../../theme/tokens.dart';
import 'calendar_marks.dart';

const double _hourHeight = 48;
const double _timeColumnWidth = 28;

/// The hour grid of the week and day views: tapping an empty slot adds there,
/// tapping a block opens it.
class TimeGrid extends StatelessWidget {
  /// Seven days for a week, one for a day.
  final List<DateTime> days;
  final DateTime today;
  final Map<DateTime, List<CalendarItem>> items;
  final void Function(DateTime date, TimeOfDay start) onEmptyTap;
  final ValueChanged<CalendarItem> onItemTap;

  /// With it, each column has a heading that opens that day. It also marks
  /// what has no time, which the grid can't place.
  final ValueChanged<DateTime>? onDayTap;

  const TimeGrid({
    super.key,
    required this.days,
    required this.today,
    required this.items,
    required this.onEmptyTap,
    required this.onItemTap,
    this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hours = gridHours([for (final day in days) ...?items[day]]);
    final hourCount = hours.end - hours.first;
    final line = BorderSide(
      color: theme.dividerColor,
      width: GlowStroke.divider,
    );

    return Column(
      children: [
        if (onDayTap != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(width: _timeColumnWidth),
              for (final day in days)
                Expanded(
                  child: _DayHeading(
                    day: day,
                    isToday: isSameDay(day, today),
                    items: items[day] ?? const [],
                    onTap: () => onDayTap!(day),
                  ),
                ),
            ],
          ),
        SizedBox(
          height: hourCount * _hourHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: _timeColumnWidth,
                child: Column(
                  children: [
                    for (var h = hours.first; h < hours.end; h++)
                      SizedBox(
                        height: _hourHeight,
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            h.toString().padLeft(2, '0'),
                            style: theme.textTheme.labelSmall,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              for (final day in days)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border(left: line),
                      color:
                          (items[day] ?? const []).any(
                            (i) => i.kind == CalendarKind.holiday,
                          )
                          ? calendarKindFill(
                              context,
                              CalendarKind.holiday,
                            ).withValues(alpha: 0.35)
                          : null,
                    ),
                    child: _DayColumn(
                      day: day,
                      items: items[day] ?? const [],
                      wide: days.length == 1,
                      firstHour: hours.first,
                      hourCount: hourCount,
                      line: line,
                      onEmptyTap: onEmptyTap,
                      onItemTap: onItemTap,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DayHeading extends StatelessWidget {
  final DateTime day;
  final bool isToday;
  final List<CalendarItem> items;
  final VoidCallback onTap;

  const _DayHeading({
    required this.day,
    required this.isToday,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final untimed = [
      for (final i in items)
        if (!i.isTimed) i,
    ];
    final style = theme.textTheme.labelSmall!.copyWith(
      color: isToday
          ? theme.colorScheme.onPrimary
          : theme.colorScheme.onSurface,
      height: 1.3,
    );
    return Semantics(
      label: [
        dayTitle(day),
        if (isToday) 'วันนี้',
        for (final i in untimed) '${calendarKindLabel(i.kind)} ${i.title}',
      ].join(' '),
      button: true,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: isToday ? theme.colorScheme.primary : null,
                borderRadius: BorderRadius.circular(GlowRadius.button / 2),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${shortWeekday(day.weekday)}\n${day.day}',
                  textAlign: TextAlign.center,
                  style: style,
                ),
              ),
            ),
            SizedBox(
              height: 14,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (final kind in CalendarKind.values)
                    if (untimed.any((i) => i.kind == kind))
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 1),
                        child: CalendarMark(kind),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayColumn extends StatelessWidget {
  final DateTime day;
  final List<CalendarItem> items;
  final bool wide;
  final int firstHour;
  final int hourCount;
  final BorderSide line;
  final void Function(DateTime date, TimeOfDay start) onEmptyTap;
  final ValueChanged<CalendarItem> onItemTap;

  const _DayColumn({
    required this.day,
    required this.items,
    required this.wide,
    required this.firstHour,
    required this.hourCount,
    required this.line,
    required this.onEmptyTap,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = weekdayName(day.weekday);

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              children: [
                for (var h = firstHour; h < firstHour + hourCount; h++)
                  Semantics(
                    label: 'เพิ่มวัน$name ${day.day} $h นาฬิกา',
                    button: true,
                    child: InkWell(
                      onTap: () =>
                          onEmptyTap(day, TimeOfDay(hour: h, minute: 0)),
                      child: Container(
                        height: _hourHeight,
                        decoration: BoxDecoration(border: Border(top: line)),
                      ),
                    ),
                  ),
              ],
            ),
            for (final (:item, :lane, :laneCount) in placeInLanes(items))
              Positioned(
                left: lane * constraints.maxWidth / laneCount + 1,
                width: constraints.maxWidth / laneCount - 2,
                top: (item.startMinutes! - firstHour * 60) / 60 * _hourHeight,
                height:
                    (item.endMinutes! - item.startMinutes!).clamp(20, 1440) /
                    60 *
                    _hourHeight,
                child: Semantics(
                  label:
                      'วัน$name ${item.title} '
                      '${formatMinutes(item.startMinutes!)} ถึง '
                      '${formatMinutes(item.endMinutes!)}',
                  button: true,
                  excludeSemantics: true,
                  onTap: () => onItemTap(item),
                  child: Material(
                    color: calendarKindFill(context, item.kind),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: theme.colorScheme.outline,
                        width: GlowStroke.divider,
                      ),
                      borderRadius: BorderRadius.circular(
                        GlowRadius.button / 2,
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: InkWell(
                      onTap: () => onItemTap(item),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: wide ? GlowSpacing.sm : 1,
                          vertical: 2,
                        ),
                        // Week columns are narrow, so only the name: the
                        // block's position already shows the time.
                        child: Text(
                          wide
                              ? '${item.kind == CalendarKind.exam ? 'สอบ · ' : ''}'
                                    '${item.title}\n'
                                    '${formatMinutes(item.startMinutes!)}–'
                                    '${formatMinutes(item.endMinutes!)}'
                              : item.title,
                          style: theme.textTheme.labelSmall!.copyWith(
                            color: theme.colorScheme.onSurface,
                            height: 1.4,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

String formatMinutes(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}
