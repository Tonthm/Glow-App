import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../shared/time_of_day_field.dart';
import '../shared/title_autocomplete_field.dart';

const _dayLabels = ['จันทร์', 'อังคาร', 'พุธ', 'พฤหัส', 'ศุกร์', 'เสาร์', 'อาทิตย์'];

Future<void> showWeeklyItemForm(
  BuildContext context, {
  WeeklyItem? existing,
  int? initialDayOfWeek,
  TimeOfDay? initialStart,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _WeeklyItemForm(
      existing: existing,
      initialDayOfWeek: initialDayOfWeek,
      initialStart: initialStart,
    ),
  );
}

class _WeeklyItemForm extends ConsumerStatefulWidget {
  final WeeklyItem? existing;
  final int? initialDayOfWeek;
  final TimeOfDay? initialStart;

  const _WeeklyItemForm({
    this.existing,
    this.initialDayOfWeek,
    this.initialStart,
  });

  @override
  ConsumerState<_WeeklyItemForm> createState() => _WeeklyItemFormState();
}

class _WeeklyItemFormState extends ConsumerState<_WeeklyItemForm> {
  late String _title;
  late int _dayOfWeek;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late WeeklyItemType _type;
  final Set<int> _copyToDays = {};

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = existing?.title ?? '';
    _dayOfWeek = existing?.dayOfWeek ?? widget.initialDayOfWeek ?? DateTime.monday;
    final startMinutes = existing?.startMinutes ?? _timeOfDayToMinutes(widget.initialStart) ?? 8 * 60;
    _start = _minutesToTimeOfDay(startMinutes);
    _end = _minutesToTimeOfDay(existing?.endMinutes ?? (startMinutes + 60));
    _type = existing?.type ?? WeeklyItemType.classSession;
  }

  bool get _isEdit => widget.existing != null;

  @override
  Widget build(BuildContext context) {
    final titlesAsync = ref.watch(weeklyItemsStreamProvider);
    final oneTimeTitlesAsync = ref.watch(oneTimeItemsStreamProvider);
    final suggestions = <String>{
      ...titlesAsync.value?.map((e) => e.title) ?? [],
      ...oneTimeTitlesAsync.value?.map((e) => e.title) ?? [],
    }.toList();

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEdit ? 'แก้ไขรายการ' : 'เพิ่มคาบเรียน/กิจกรรม',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TitleAutocompleteField(
              initialValue: _title,
              suggestions: suggestions,
              onChanged: (v) => _title = v,
            ),
            const SizedBox(height: 12),
            SegmentedButton<WeeklyItemType>(
              segments: const [
                ButtonSegment(
                  value: WeeklyItemType.classSession,
                  label: Text('คาบเรียน'),
                ),
                ButtonSegment(
                  value: WeeklyItemType.activity,
                  label: Text('กิจกรรม'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() => _type = v.first),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final day = i + 1;
                return ChoiceChip(
                  label: Text(_dayLabels[i]),
                  selected: _dayOfWeek == day,
                  onSelected: (_) => setState(() => _dayOfWeek = day),
                );
              }),
            ),
            TimeOfDayField(
              label: 'เวลาเริ่ม',
              time: _start,
              onChanged: (t) => setState(() => _start = t),
            ),
            TimeOfDayField(
              label: 'เวลาจบ',
              time: _end,
              onChanged: (t) => setState(() => _end = t),
            ),
            if (!_isEdit) ...[
              const SizedBox(height: 8),
              const Text('คัดลอกไปวันอื่น (เลือกได้หลายวัน)'),
              Wrap(
                spacing: 8,
                children: List.generate(7, (i) {
                  final day = i + 1;
                  if (day == _dayOfWeek) return const SizedBox.shrink();
                  return FilterChip(
                    label: Text(_dayLabels[i]),
                    selected: _copyToDays.contains(day),
                    onSelected: (sel) => setState(() {
                      if (sel) {
                        _copyToDays.add(day);
                      } else {
                        _copyToDays.remove(day);
                      }
                    }),
                  );
                }),
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                if (_isEdit)
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(scheduleRepositoryProvider)
                          .deleteWeeklyItem(widget.existing!.id);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: const Text('ลบ', style: TextStyle(color: Colors.red)),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed: _title.trim().isEmpty ? null : _save,
                  child: const Text('บันทึก'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    final repo = ref.read(scheduleRepositoryProvider);
    final startMinutes = _start.hour * 60 + _start.minute;
    final endMinutes = _end.hour * 60 + _end.minute;

    if (_isEdit) {
      await repo.updateWeeklyItem(
        widget.existing!.copyWith(
          title: _title.trim(),
          dayOfWeek: _dayOfWeek,
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          type: _type,
        ),
      );
    } else {
      await repo.addWeeklyItem(
        title: _title.trim(),
        dayOfWeek: _dayOfWeek,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        type: _type,
      );
      for (final day in _copyToDays) {
        await repo.addWeeklyItem(
          title: _title.trim(),
          dayOfWeek: day,
          startMinutes: startMinutes,
          endMinutes: endMinutes,
          type: _type,
        );
      }
    }
    if (mounted) Navigator.of(context).pop();
  }
}

int? _timeOfDayToMinutes(TimeOfDay? t) => t == null ? null : t.hour * 60 + t.minute;

TimeOfDay _minutesToTimeOfDay(int minutes) =>
    TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);
