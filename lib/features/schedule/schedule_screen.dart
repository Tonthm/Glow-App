import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../calendar_import/calendar_import_screen.dart';
import '../shared/settings_button.dart';
import 'one_time_item_form.dart';
import 'weekly_item_form.dart';

const _dayLabels = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัส', 'ศุกร์', 'เสาร์', 'อาทิตย์'];

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ตาราง'),
          actions: [
            IconButton(
              icon: const Icon(Icons.calendar_month_outlined),
              tooltip: 'นำเข้าจากปฏิทิน',
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CalendarImportScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.date_range_outlined),
              tooltip: 'ช่วงเทอม',
              onPressed: () => _editTermDates(context, ref),
            ),
            const SettingsButton(),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'รายสัปดาห์'), Tab(text: 'ครั้งเดียว')],
          ),
        ),
        body: const TabBarView(
          children: [_WeeklyTab(), _OneTimeTab()],
        ),
      ),
    );
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
                subtitle: Text(start == null ? 'ยังไม่ตั้ง' : _formatDate(start!)),
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

class _WeeklyTab extends ConsumerWidget {
  const _WeeklyTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(weeklyItemsStreamProvider);
    return itemsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      data: (items) {
        return ListView.builder(
          itemCount: 7,
          itemBuilder: (context, index) {
            final day = index + 1;
            final dayItems = items.where((i) => i.dayOfWeek == day).toList()
              ..sort((a, b) => a.startMinutes.compareTo(b.startMinutes));
            return ExpansionTile(
              initiallyExpanded: true,
              title: Text(_dayLabels[index]),
              trailing: IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => showWeeklyItemForm(context, initialDayOfWeek: day),
              ),
              children: [
                if (dayItems.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 8),
                    child: Text(
                      'ไม่มีรายการ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                for (final item in dayItems)
                  ListTile(
                    title: Text(item.title),
                    subtitle: Text(
                      '${_formatMinutes(item.startMinutes)} - ${_formatMinutes(item.endMinutes)}'
                      ' • ${item.type == WeeklyItemType.classSession ? 'คาบเรียน' : 'กิจกรรม'}',
                    ),
                    onTap: () => showWeeklyItemForm(context, existing: item),
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _OneTimeTab extends ConsumerWidget {
  const _OneTimeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(oneTimeItemsStreamProvider);
    return Scaffold(
      body: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
        data: (items) {
          final sorted = items.toList()..sort((a, b) => a.date.compareTo(b.date));
          if (sorted.isEmpty) {
            return Center(
              child: Text(
                'ยังไม่มีรายการครั้งเดียว',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            );
          }
          return ListView.builder(
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final item = sorted[index];
              return ListTile(
                title: Text(item.title),
                subtitle: Text(
                  '${_formatDate(item.date)}'
                  '${item.startMinutes != null ? ' • ${_formatMinutes(item.startMinutes!)}-${_formatMinutes(item.endMinutes!)}' : ''}'
                  ' • ${_oneTimeTypeLabel(item.type)}',
                ),
                onTap: () => showOneTimeItemForm(context, existing: item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showOneTimeItemForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _oneTimeTypeLabel(OneTimeItemType type) => switch (type) {
  OneTimeItemType.exam => 'สอบ',
  OneTimeItemType.activity => 'กิจกรรม',
  OneTimeItemType.holiday => 'วันหยุด',
};

String _formatMinutes(int minutes) {
  final h = (minutes ~/ 60).toString().padLeft(2, '0');
  final m = (minutes % 60).toString().padLeft(2, '0');
  return '$h:$m';
}
