import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/calendar_view.dart';
import '../../core/guide.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_fold.dart';
import '../calendar_import/calendar_import_screen.dart';
import '../guide/navigation.dart';
import '../shared/settings_button.dart';
import '../shared/subject_colors.dart';
import 'add_item_sheet.dart';
import 'calendar_data.dart';
import 'day_items.dart';
import 'month_view.dart';
import 'one_time_item_form.dart';
import 'time_grid.dart';
import 'voice_input_screen.dart';
import '../../services/app_clock.dart';

const _modeLabels = {
  CalendarMode.month: 'เดือน',
  CalendarMode.week: 'สัปดาห์',
  CalendarMode.day: 'วัน',
};

/// The timetable as a calendar: a month, a week, or a day (CLAUDE.md
/// section 2).
class ScheduleScreen extends ConsumerStatefulWidget {
  const ScheduleScreen({super.key});

  @override
  ConsumerState<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends ConsumerState<ScheduleScreen> {
  CalendarMode _mode = CalendarMode.month;

  /// The day the views are around; null follows today.
  DateTime? _picked;

  DateTime get _today {
    final now = ref.read(clockProvider)();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime get _focus => _picked ?? _today;

  void _move(int steps) =>
      setState(() => _picked = shiftPeriod(_mode, _focus, steps));

  Future<void> _openDay(DateTime day) async {
    // The other tabs then start from the day last looked at.
    setState(() => _picked = day);
    await showDaySheet(context, day);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(clockProvider);
    final data = ref.watch(calendarDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ตาราง'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'เพิ่มรายการ',
            onPressed: () => _chooseHowToAdd(context),
          ),
          IconButton(
            icon: const Icon(Icons.date_range_outlined),
            tooltip: 'ช่วงเทอม',
            onPressed: () => _editTermDates(context),
          ),
          const SettingsButton(),
        ],
      ),
      body: data == null
          ? const Center(child: CircularProgressIndicator())
          : _calendar(context, data),
    );
  }

  Widget _calendar(BuildContext context, CalendarData data) {
    final theme = Theme.of(context);
    final days = switch (_mode) {
      CalendarMode.month => monthDays(_focus, data.firstWeekday),
      CalendarMode.week => weekDays(_focus, data.firstWeekday),
      CalendarMode.day => [_focus],
    };
    final items = data.itemsFor(days);
    final title = switch (_mode) {
      CalendarMode.month => monthTitle(_focus),
      CalendarMode.week => weekTitle(days),
      CalendarMode.day => dayTitle(_focus),
    };
    final unit = _modeLabels[_mode]!;
    final empty = data.weekly.isEmpty && data.oneTime.isEmpty;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: GlowSpacing.pageMargin,
          ),
          child: SizedBox(
            width: double.infinity,
            child: SegmentedButton<CalendarMode>(
              showSelectedIcon: false,
              segments: [
                for (final entry in _modeLabels.entries)
                  ButtonSegment(value: entry.key, label: Text(entry.value)),
              ],
              selected: {_mode},
              onSelectionChanged: (v) => setState(() => _mode = v.single),
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: '$unitก่อนหน้า',
              onPressed: () => _move(-1),
            ),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _picked = null),
              child: const Text('วันนี้'),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: '$unitถัดไป',
              onPressed: () => _move(1),
            ),
          ],
        ),
        Expanded(
          child: GestureDetector(
            // A sideways swipe turns the page.
            onHorizontalDragEnd: (details) {
              final speed = details.primaryVelocity ?? 0;
              if (speed.abs() > 200) _move(speed < 0 ? 1 : -1);
            },
            child: ListView(
              key: ValueKey(_mode),
              padding: const EdgeInsets.symmetric(
                horizontal: GlowSpacing.pageMargin,
              ),
              children: [
                if (empty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
                    child: Text(
                      'ยังไม่มีตาราง แตะ + หรือแตะวันเพื่อเพิ่มรายการแรก',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                ..._view(data, days, items),
                const SizedBox(height: GlowSpacing.xl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<Widget> _view(
    CalendarData data,
    List<DateTime> days,
    Map<DateTime, List<CalendarItem>> items,
  ) {
    void addAt(DateTime date, TimeOfDay start) => showTypedEntryChooser(
      context,
      date: date,
      start: start,
      outsideTerm: data.isOutsideTerm(date),
    );
    void open(CalendarItem item) => openCalendarItem(context, data, item);

    switch (_mode) {
      case CalendarMode.month:
        return [
          MonthView(
            month: _focus,
            today: _today,
            firstWeekday: data.firstWeekday,
            items: items,
            onDayTap: _openDay,
            colors: data.colors,
          ),
          const SizedBox(height: GlowSpacing.lg),
          GlowFold(
            icon: Icons.event_outlined,
            title: 'รายการครั้งเดียว',
            summary: 'สอบ กิจกรรม และวันหยุดทั้งหมด',
            child: _OneTimeList(
              items: data.oneTime,
              now: _today,
              colors: data.colors,
            ),
          ),
        ];
      case CalendarMode.week:
        return [
          TimeGrid(
            days: days,
            today: _today,
            items: items,
            onEmptyTap: addAt,
            onItemTap: open,
            onDayTap: _openDay,
            colors: data.colors,
          ),
        ];
      case CalendarMode.day:
        final day = days.single;
        return [
          // What has no time can't be placed on the grid.
          for (final item in items[day]!)
            if (!item.isTimed)
              CalendarItemRow(
                item: item,
                colors: data.colors,
                onTap: () => open(item),
              ),
          TimeGrid(
            days: days,
            today: _today,
            items: items,
            onEmptyTap: addAt,
            onItemTap: open,
            colors: data.colors,
          ),
          const SizedBox(height: GlowSpacing.md),
          OutlinedButton.icon(
            onPressed: () => showTypedEntryChooser(
              context,
              date: day,
              outsideTerm: data.isOutsideTerm(day),
            ),
            icon: const Icon(Icons.add),
            label: const Text('เพิ่มในวันนี้'),
          ),
        ];
    }
  }

  /// THEME.md: + opens a sheet to pick พิมพ์ / พูด / นำเข้าจากปฏิทิน.
  Future<void> _chooseHowToAdd(BuildContext context) async {
    final choice = await showAddMethodSheet(context);
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case AddMethod.type:
        await showTypedEntryChooser(context);
      case AddMethod.voice:
        await Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => const VoiceInputScreen()));
      case AddMethod.photo:
        await navigateTo(context, Destination.importPicture);
      case AddMethod.calendar:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CalendarImportScreen()));
    }
  }

  Future<void> _editTermDates(BuildContext context) async {
    final settings = await ref.read(settingsRepositoryProvider).get();
    var start = settings.termStart;
    var end = settings.termEnd;

    if (!context.mounted) return;
    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('ช่วงเทอม'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('วันเริ่มเทอม'),
                subtitle: Text(
                  start == null ? 'ยังไม่ตั้ง' : _formatDate(start!),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: start ?? ref.read(clockProvider)(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) setState(() => start = picked);
                },
              ),
              ListTile(
                title: const Text('วันจบเทอม'),
                subtitle: Text(end == null ? 'ยังไม่ตั้ง' : _formatDate(end!)),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: end ?? (start ?? ref.read(clockProvider)()),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2035),
                  );
                  if (picked != null) setState(() => end = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('ยกเลิก'),
            ),
            FilledButton(
              onPressed: () async {
                await ref
                    .read(settingsRepositoryProvider)
                    .updateTermDates(start: start, end: end);
                if (context.mounted) Navigator.of(context).pop();
              },
              child: const Text('บันทึก'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Day, month, and Buddhist year, as everywhere on this screen.
String _formatDate(DateTime d) => '${d.day}/${d.month}/${buddhistYear(d.year)}';

/// Every one-time item, so a far-off exam can be found without paging through
/// the months.
class _OneTimeList extends StatelessWidget {
  final List<OneTimeItem> items;
  final DateTime now;
  final Map<String, int> colors;
  const _OneTimeList({
    required this.items,
    required this.now,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Upcoming first; past items drop to the bottom, newest first.
    final upcoming = items.where((i) => !i.date.isBefore(now)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final past = items.where((i) => i.date.isBefore(now)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (items.isEmpty)
          Text(
            'สอบ กิจกรรมครั้งเดียว และวันหยุด จะแสดงที่นี่',
            style: textTheme.bodyMedium,
          ),
        for (final item in [...upcoming, ...past])
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Row(
              children: [
                SubjectDot(colors, item.title),
                Expanded(child: Text(item.title, style: textTheme.bodyLarge)),
              ],
            ),
            subtitle: Text(
              '${_oneTimeTypeLabel(item.type)} · ${_formatDate(item.date)}'
              '${item.startMinutes != null ? ' · ${formatMinutes(item.startMinutes!)}–${formatMinutes(item.endMinutes!)}' : ''}',
              style: textTheme.bodyMedium,
            ),
            onTap: () => showOneTimeItemForm(context, existing: item),
          ),
      ],
    );
  }
}

String _oneTimeTypeLabel(OneTimeItemType type) => switch (type) {
  OneTimeItemType.exam => 'สอบ',
  OneTimeItemType.activity => 'กิจกรรม',
  OneTimeItemType.holiday => 'วันหยุด',
};
