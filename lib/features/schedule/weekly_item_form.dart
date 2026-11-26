import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/subject_color.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../shared/subject_color_picker.dart';
import '../shared/time_of_day_field.dart';
import '../shared/title_autocomplete_field.dart';

const _dayLabels = [
  'จันทร์',
  'อังคาร',
  'พุธ',
  'พฤหัส',
  'ศุกร์',
  'เสาร์',
  'อาทิตย์',
];

Future<void> showWeeklyItemForm(
  BuildContext context, {
  WeeklyItem? existing,
  int? initialDayOfWeek,
  TimeOfDay? initialStart,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
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
  /// For a new item: the days it happens on.
  late final Set<int> _days;

  /// The color picked in this form; otherwise the name's saved color shows.
  int? _color;
  bool _colorPicked = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = existing?.title ?? '';
    _dayOfWeek =
        existing?.dayOfWeek ?? widget.initialDayOfWeek ?? DateTime.monday;
    _days = {_dayOfWeek};
    final startMinutes =
        existing?.startMinutes ??
        _timeOfDayToMinutes(widget.initialStart) ??
        8 * 60;
    _start = _minutesToTimeOfDay(startMinutes);
    _end = _minutesToTimeOfDay(existing?.endMinutes ?? (startMinutes + 60));
    _type = existing?.type ?? WeeklyItemType.classSession;
  }

  bool get _isEdit => widget.existing != null;

  bool get _hasValidTimes =>
      _timeOfDayToMinutes(_end)! > _timeOfDayToMinutes(_start)!;

  @override
  Widget build(BuildContext context) {
    final titlesAsync = ref.watch(weeklyItemsStreamProvider);
    final colors = ref.watch(subjectColorsProvider).value ?? const {};
    final color = _colorPicked ? _color : colorOfSubject(colors, _title);
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
              onChanged: (v) => setState(() => _title = v),
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
            Text(
              _isEdit ? 'วัน' : 'เลือกได้หลายวัน',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Wrap(
              spacing: 8,
              children: List.generate(7, (i) {
                final day = i + 1;
                if (_isEdit) {
                  return ChoiceChip(
                    label: Text(_dayLabels[i]),
                    selected: _dayOfWeek == day,
                    onSelected: (_) => setState(() => _dayOfWeek = day),
                  );
                }
                return FilterChip(
                  label: Text(_dayLabels[i]),
                  selected: _days.contains(day),
                  onSelected: (on) => setState(
                    () => on ? _days.add(day) : _days.remove(day),
                  ),
                );
              }),
            ),
            if (!_isEdit && _days.isEmpty)
              Text(
                'เลือกอย่างน้อย 1 วัน',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            TimeOfDayField(
              label: 'เวลาเริ่ม',
              time: _start,
              // Moving the start keeps the length of the class.
              onChanged: (t) => setState(() {
                final length =
                    _timeOfDayToMinutes(_end)! - _timeOfDayToMinutes(_start)!;
                _start = t;
                if (length > 0) _end = stepTimeOfDay(t, length);
              }),
            ),
            TimeOfDayField(
              label: 'เวลาจบ',
              time: _end,
              onChanged: (t) => setState(() => _end = t),
            ),
            const SizedBox(height: 8),
            SubjectColorPicker(
              color: color,
              onChanged: (v) => setState(() {
                _color = v;
                _colorPicked = true;
              }),
            ),
            if (!_hasValidTimes)
              Text(
                'เวลาจบต้องอยู่หลังเวลาเริ่ม',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
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
                    child: Text(
                      'ลบ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                  ),
                const Spacer(),
                FilledButton(
                  onPressed:
                      _title.trim().isEmpty ||
                          !_hasValidTimes ||
                          (!_isEdit && _days.isEmpty)
                      ? null
                      : _save,
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
    final colorRepo = ref.read(subjectColorRepositoryProvider);
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
      await repo.addWeeklyItems(
        title: _title.trim(),
        days: _days,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
        type: _type,
      );
    }
    if (_colorPicked) await colorRepo.set(_title, _color);
    if (mounted) Navigator.of(context).pop();
  }
}

int? _timeOfDayToMinutes(TimeOfDay? t) =>
    t == null ? null : t.hour * 60 + t.minute;

TimeOfDay _minutesToTimeOfDay(int minutes) =>
    TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);
