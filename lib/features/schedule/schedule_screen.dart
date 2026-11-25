import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../calendar_import/calendar_import_screen.dart';
import '../shared/settings_button.dart';
import 'add_item_sheet.dart';
import 'one_time_item_form.dart';
import 'week_grid.dart';
import 'weekly_item_form.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklyAsync = ref.watch(weeklyItemsStreamProvider);
    final oneTimeAsync = ref.watch(oneTimeItemsStreamProvider);
    final weekly = weeklyAsync.value;
    final oneTime = oneTimeAsync.value;

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
            onPressed: () => _editTermDates(context, ref),
          ),
          const SettingsButton(),
        ],
      ),
      body: weekly == null || oneTime == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: GlowSpacing.pageMargin,
              ),
              children: [
                if (weekly.isEmpty && oneTime.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: GlowSpacing.md),
                    child: Text(
                      'ยังไม่มีตาราง แตะ + หรือแตะช่องว่างเพื่อเพิ่มคาบแรก',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                WeekGrid(
                  items: weekly,
                  onEmptyTap: (day, start) => showWeeklyItemForm(
                    context,
                    initialDayOfWeek: day,
                    initialStart: start,
                  ),
                  onItemTap: (item) =>
                      showWeeklyItemForm(context, existing: item),
                ),
                const Divider(height: GlowSpacing.xxl),
                _OneTimeList(items: oneTime),
                const SizedBox(height: GlowSpacing.xl),
              ],
            ),
    );
  }

  /// THEME.md: + opens a sheet to pick พิมพ์ / พูด / นำเข้าจากปฏิทิน.
  Future<void> _chooseHowToAdd(BuildContext context) async {
    final choice = await showAddMethodSheet(context);
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case AddMethod.type:
        await showTypedEntryChooser(context);
      case AddMethod.calendar:
        await Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const CalendarImportScreen()));
    }
  }

  Future<void> _editTermDates(BuildContext context, WidgetRef ref) async {
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
                    initialDate: start ?? DateTime.now(),
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
                    initialDate: end ?? (start ?? DateTime.now()),
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

String _formatDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

class _OneTimeList extends StatelessWidget {
  final List<OneTimeItem> items;
  const _OneTimeList({required this.items});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    // Upcoming first; past items drop to the bottom, newest first.
    final upcoming = items.where((i) => !i.date.isBefore(today)).toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final past = items.where((i) => i.date.isBefore(today)).toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('รายการครั้งเดียว', style: textTheme.titleLarge),
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
                if (item.type == OneTimeItemType.exam) ...[
                  const _ExamPill(),
                  const SizedBox(width: GlowSpacing.sm),
                ],
                Expanded(child: Text(item.title)),
              ],
            ),
            subtitle: Text(
              '${_formatDate(item.date)}'
              '${item.startMinutes != null ? ' • ${formatMinutes(item.startMinutes!)}-${formatMinutes(item.endMinutes!)}' : ''}'
              ' • ${_oneTimeTypeLabel(item.type)}',
              style: textTheme.bodyMedium,
            ),
            onTap: () => showOneTimeItemForm(context, existing: item),
          ),
      ],
    );
  }
}

class _ExamPill extends StatelessWidget {
  const _ExamPill();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: GlowSpacing.sm),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.primary),
        borderRadius: BorderRadius.circular(GlowRadius.pill),
      ),
      child: Text(
        'สอบ',
        style: theme.textTheme.labelSmall?.copyWith(
          color: theme.colorScheme.primary,
        ),
      ),
    );
  }
}

String _oneTimeTypeLabel(OneTimeItemType type) => switch (type) {
  OneTimeItemType.exam => 'สอบ',
  OneTimeItemType.activity => 'กิจกรรม',
  OneTimeItemType.holiday => 'วันหยุด',
};
