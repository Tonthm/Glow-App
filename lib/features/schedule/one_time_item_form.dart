import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../core/subject_color.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../shared/subject_color_picker.dart';
import '../shared/time_of_day_field.dart';
import '../shared/title_autocomplete_field.dart';
import '../../services/app_clock.dart';

Future<void> showOneTimeItemForm(
  BuildContext context, {
  OneTimeItem? existing,
  DateTime? initialDate,
  TimeOfDay? initialStart,
}) {
  return showGlowBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _OneTimeItemForm(
      existing: existing,
      initialDate: initialDate,
      initialStart: initialStart,
    ),
  );
}

class _OneTimeItemForm extends ConsumerStatefulWidget {
  final OneTimeItem? existing;
  final DateTime? initialDate;

  final TimeOfDay? initialStart;

  const _OneTimeItemForm({this.existing, this.initialDate, this.initialStart});

  @override
  ConsumerState<_OneTimeItemForm> createState() => _OneTimeItemFormState();
}

class _OneTimeItemFormState extends ConsumerState<_OneTimeItemForm> {
  late String _title;
  late DateTime _date;
  late OneTimeItemType _type;
  late bool _hasTime;
  late TimeOfDay _start;
  late TimeOfDay _end;
  int? _color;
  bool _colorPicked = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = existing?.title ?? '';
    _date = existing?.date ?? widget.initialDate ?? ref.read(clockProvider)();
    _type = existing?.type ?? OneTimeItemType.exam;
    _hasTime = existing == null ? true : existing.startMinutes != null;
    final tapped = widget.initialStart;
    final startMinutes =
        existing?.startMinutes ??
        (tapped == null ? 9 * 60 : tapped.hour * 60 + tapped.minute);
    _start = _minutesToTimeOfDay(startMinutes);
    _end = _minutesToTimeOfDay(existing?.endMinutes ?? startMinutes + 60);
  }

  bool get _isEdit => widget.existing != null;

  bool get _hasValidTimes =>
      _type == OneTimeItemType.holiday ||
      !_hasTime ||
      _end.hour * 60 + _end.minute > _start.hour * 60 + _start.minute;

  @override
  Widget build(BuildContext context) {
    final weeklyAsync = ref.watch(weeklyItemsStreamProvider);
    final colors = ref.watch(subjectColorsProvider).value ?? const {};
    final color = _colorPicked ? _color : colorOfSubject(colors, _title);
    final oneTimeAsync = ref.watch(oneTimeItemsStreamProvider);
    final suggestions = <String>{
      ...weeklyAsync.value?.map((e) => e.title) ?? [],
      ...oneTimeAsync.value?.map((e) => e.title) ?? [],
    }.toList();

    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              _isEdit ? 'แก้ไขรายการ' : 'เพิ่มรายการครั้งเดียว',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TitleAutocompleteField(
              initialValue: _title,
              suggestions: suggestions,
              onChanged: (v) => setState(() => _title = v),
            ),
            const SizedBox(height: 12),
            SegmentedButton<OneTimeItemType>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: OneTimeItemType.exam, label: Text('สอบ')),
                ButtonSegment(
                  value: OneTimeItemType.activity,
                  label: Text('กิจกรรม'),
                ),
                ButtonSegment(
                  value: OneTimeItemType.holiday,
                  label: Text('วันหยุด'),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (v) => setState(() {
                _type = v.first;
                if (_type == OneTimeItemType.holiday) _hasTime = false;
              }),
            ),
            const SizedBox(height: 12),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('วันที่'),
              subtitle: Text(
                '${_date.day}/${_date.month}/${_date.year}',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: ref
                      .read(clockProvider)()
                      .subtract(const Duration(days: 365)),
                  lastDate: ref
                      .read(clockProvider)()
                      .add(const Duration(days: 365 * 2)),
                );
                if (picked != null) setState(() => _date = picked);
              },
            ),
            if (_type != OneTimeItemType.holiday) ...[
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('มีเวลาเริ่ม-จบ'),
                value: _hasTime,
                onChanged: (v) => setState(() => _hasTime = v),
              ),
              if (_hasTime) ...[
                TimeOfDayField(
                  label: 'เวลาเริ่ม',
                  time: _start,
                  // Moving the start keeps the length.
                  onChanged: (t) => setState(() {
                    final length =
                        (_end.hour - _start.hour) * 60 +
                        _end.minute -
                        _start.minute;
                    _start = t;
                    if (length > 0) _end = stepTimeOfDay(t, length);
                  }),
                ),
                TimeOfDayField(
                  label: 'เวลาจบ',
                  time: _end,
                  onChanged: (t) => setState(() => _end = t),
                ),
              ],
            ],
            // A holiday isn't a subject.
            if (_type != OneTimeItemType.holiday) ...[
              const SizedBox(height: 8),
              SubjectColorPicker(
                color: color,
                onChanged: (v) => setState(() {
                  _color = v;
                  _colorPicked = true;
                }),
              ),
            ],
            if (!_hasValidTimes)
              Text(
                'เวลาจบต้องอยู่หลังเวลาเริ่ม',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FilledButton(
                  onPressed: _title.trim().isEmpty || !_hasValidTimes
                      ? null
                      : _save,
                  child: const Text('บันทึก'),
                ),
                if (_isEdit)
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(scheduleRepositoryProvider)
                          .deleteOneTimeItem(widget.existing!.id);
                      if (context.mounted) Navigator.of(context).pop();
                    },
                    child: Text(
                      'ลบ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
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
    final includeTime = _type != OneTimeItemType.holiday && _hasTime;
    final startMinutes = includeTime ? _start.hour * 60 + _start.minute : null;
    final endMinutes = includeTime ? _end.hour * 60 + _end.minute : null;
    final date = DateTime(_date.year, _date.month, _date.day);

    if (_isEdit) {
      await repo.updateOneTimeItem(
        widget.existing!.copyWith(
          title: _title.trim(),
          date: date,
          type: _type,
          startMinutes: Value(startMinutes),
          endMinutes: Value(endMinutes),
        ),
      );
    } else {
      await repo.addOneTimeItem(
        title: _title.trim(),
        date: date,
        type: _type,
        startMinutes: startMinutes,
        endMinutes: endMinutes,
      );
    }
    if (_colorPicked && _type != OneTimeItemType.holiday) {
      await colorRepo.set(_title, _color);
    }
    if (mounted) Navigator.of(context).pop();
  }
}

TimeOfDay _minutesToTimeOfDay(int minutes) =>
    TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);
