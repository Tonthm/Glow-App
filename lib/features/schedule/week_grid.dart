import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../theme/tokens.dart';

const _dayLabels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
const _dayNames = [
  'จันทร์',
  'อังคาร',
  'พุธ',
  'พฤหัส',
  'ศุกร์',
  'เสาร์',
  'อาทิตย์',
];

const double _hourHeight = 48;
const double _timeColumnWidth = 28;
const double _headerHeight = 28;

/// The hours shown when nothing falls outside them.
const int _defaultFirstHour = 7;
const int _defaultEndHour = 19;

/// The weekly timetable (CLAUDE.md section 2, THEME.md "ตารางรายสัปดาห์
/// แบบช่อง"): tapping an empty slot opens the form with that day and hour,
/// tapping a block edits it.
class WeekGrid extends StatelessWidget {
  final List<WeeklyItem> items;
  final void Function(int dayOfWeek, TimeOfDay start) onEmptyTap;
  final ValueChanged<WeeklyItem> onItemTap;

  const WeekGrid({
    super.key,
    required this.items,
    required this.onEmptyTap,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    var firstHour = _defaultFirstHour;
    var endHour = _defaultEndHour;
    for (final item in items) {
      final starts = item.startMinutes ~/ 60;
      final ends = (item.endMinutes + 59) ~/ 60;
      if (starts < firstHour) firstHour = starts;
      if (ends > endHour) endHour = ends;
    }
    final hourCount = endHour - firstHour;
    final theme = Theme.of(context);
    final line = BorderSide(color: theme.dividerColor, width: 1);

    return Column(
      children: [
        SizedBox(
          height: _headerHeight,
          child: Row(
            children: [
              const SizedBox(width: _timeColumnWidth),
              for (final label in _dayLabels)
                Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall,
                  ),
                ),
            ],
          ),
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
                    for (var h = firstHour; h < endHour; h++)
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
              for (var day = 1; day <= 7; day++)
                Expanded(
                  child: DecoratedBox(
                    decoration: BoxDecoration(border: Border(left: line)),
                    child: _DayColumn(
                      day: day,
                      items: items.where((i) => i.dayOfWeek == day).toList(),
                      firstHour: firstHour,
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

class _DayColumn extends StatelessWidget {
  final int day;
  final List<WeeklyItem> items;
  final int firstHour;
  final int hourCount;
  final BorderSide line;
  final void Function(int dayOfWeek, TimeOfDay start) onEmptyTap;
  final ValueChanged<WeeklyItem> onItemTap;

  const _DayColumn({
    required this.day,
    required this.items,
    required this.firstHour,
    required this.hourCount,
    required this.line,
    required this.onEmptyTap,
    required this.onItemTap,
  });

  /// Splits overlapping items into side-by-side lanes so none is hidden.
  List<List<WeeklyItem>> _lanes() {
    final sorted = items.toList()
      ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
    final lanes = <List<WeeklyItem>>[];
    for (final item in sorted) {
      final free = lanes.where(
        (lane) => lane.last.endMinutes <= item.startMinutes,
      );
      if (free.isEmpty) {
        lanes.add([item]);
      } else {
        free.first.add(item);
      }
    }
    return lanes;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lanes = _lanes();

    return LayoutBuilder(
      builder: (context, constraints) {
        final laneWidth =
            constraints.maxWidth / (lanes.isEmpty ? 1 : lanes.length);
        return Stack(
          children: [
            Column(
              children: [
                for (var h = firstHour; h < firstHour + hourCount; h++)
                  Semantics(
                    label: 'เพิ่มวัน${_dayNames[day - 1]} $h นาฬิกา',
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
            for (var lane = 0; lane < lanes.length; lane++)
              for (final item in lanes[lane])
                Positioned(
                  left: lane * laneWidth + 1,
                  width: laneWidth - 2,
                  top: (item.startMinutes - firstHour * 60) / 60 * _hourHeight,
                  height:
                      (item.endMinutes - item.startMinutes).clamp(20, 1440) /
                      60 *
                      _hourHeight,
                  child: Semantics(
                    label:
                        'วัน${_dayNames[day - 1]} ${item.title} '
                        '${formatMinutes(item.startMinutes)} ถึง '
                        '${formatMinutes(item.endMinutes)}',
                    button: true,
                    child: Material(
                      color: theme.colorScheme.primary.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(
                        GlowRadius.button / 2,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () => onItemTap(item),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 1,
                            vertical: 2,
                          ),
                          // Columns are narrow, so only the name: the
                          // block's position already shows the time.
                          child: Text(
                            item.title,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontSize:
                                  theme.textTheme.labelSmall!.fontSize! - 2,
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
