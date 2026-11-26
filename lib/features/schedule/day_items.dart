import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/calendar_view.dart';
import '../../core/subject_color.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../evening/task_form_sheet.dart';
import 'add_item_sheet.dart';
import 'calendar_data.dart';
import 'calendar_marks.dart';
import 'one_time_item_form.dart';
import 'time_grid.dart';
import 'weekly_item_form.dart';

/// Opens the form for whatever [item] came from.
Future<void> openCalendarItem(
  BuildContext context,
  CalendarData data,
  CalendarItem item,
) async {
  switch (item.source) {
    case CalendarSource.weekly:
      final row = data.weeklyById(item.sourceId);
      if (row != null) await showWeeklyItemForm(context, existing: row);
    case CalendarSource.oneTime:
      final row = data.oneTimeById(item.sourceId);
      if (row != null) await showOneTimeItemForm(context, existing: row);
    case CalendarSource.task:
      final row = data.taskById(item.sourceId);
      if (row == null) return;
      if (data.isSplitOriginal(item)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('งานนี้แบ่งเป็นช่วงแล้ว แก้ได้ที่แต่ละช่วง'),
          ),
        );
        return;
      }
      await showTaskForm(context, planDate: row.planDate, existing: row);
  }
}

String _detail(CalendarItem item) => [
  calendarKindLabel(item.kind),
  if (item.isTimed)
    '${formatMinutes(item.startMinutes!)}–${formatMinutes(item.endMinutes!)}',
  if (item.source == CalendarSource.weekly) 'ทุกสัปดาห์',
  if (item.kind == CalendarKind.task)
    item.done
        ? 'เสร็จแล้ว'
        : item.dueHere
        ? 'ส่งวันนี้'
        : 'ทำเย็นนี้',
].join(' · ');

/// One thing on a day.
class CalendarItemRow extends StatelessWidget {
  final CalendarItem item;
  final VoidCallback onTap;
  final Map<String, int> colors;

  const CalendarItemRow({
    super.key,
    required this.item,
    required this.onTap,
    this.colors = const {},
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
      child: GlowCard(
        onTap: onTap,
        padding: const EdgeInsets.all(GlowSpacing.md),
        child: Row(
          children: [
            CalendarMark(
              item.kind,
              size: 10,
              subjectColor: colorOfSubject(colors, item.title),
            ),
            const SizedBox(width: GlowSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title.isEmpty
                        ? calendarKindLabel(item.kind)
                        : item.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      decoration: item.done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  Text(_detail(item), style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The list of one day, with a button that adds to that day.
Future<void> showDaySheet(BuildContext context, DateTime date) =>
    showGlowBottomSheet<void>(
      context: context,
      builder: (_) => _DaySheet(date),
    );

class _DaySheet extends ConsumerWidget {
  final DateTime date;

  const _DaySheet(this.date);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    // Watched, so an edit made from here shows at once.
    final data = ref.watch(calendarDataProvider);
    if (data == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    final items = data.itemsFor([date])[date]!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(dayTitle(date), style: theme.textTheme.titleMedium),
        const SizedBox(height: GlowSpacing.md),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              if (items.isEmpty)
                Text('วันนี้ยังว่าง', style: theme.textTheme.bodyMedium),
              for (final item in items)
                CalendarItemRow(
                  item: item,
                  colors: data.colors,
                  onTap: () => openCalendarItem(context, data, item),
                ),
            ],
          ),
        ),
        const SizedBox(height: GlowSpacing.md),
        GlowPrimaryButton(
          label: 'เพิ่มในวันนี้',
          icon: Icons.add,
          onPressed: () => showTypedEntryChooser(
            context,
            date: date,
            outsideTerm: data.isOutsideTerm(date),
          ),
        ),
      ],
    );
  }
}
