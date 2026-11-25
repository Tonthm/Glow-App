import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show Value;

import '../../data/database.dart';
import '../../providers.dart';
import '../shared/time_of_day_field.dart';
import '../shared/title_autocomplete_field.dart';

Future<void> showOneTimeItemForm(
  BuildContext context, {
  OneTimeItem? existing,
  DateTime? initialDate,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (_) => _OneTimeItemForm(existing: existing, initialDate: initialDate),
  );
}

class _OneTimeItemForm extends ConsumerStatefulWidget {
  final OneTimeItem? existing;
  final DateTime? initialDate;

  const _OneTimeItemForm({this.existing, this.initialDate});

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

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _title = existing?.title ?? '';
    _date = existing?.date ?? widget.initialDate ?? DateTime.now();
    _type = existing?.type ?? OneTimeItemType.exam;
    _hasTime = existing == null ? true : existing.startMinutes != null;
    _start = _minutesToTimeOfDay(existing?.startMinutes ?? 9 * 60);
    _end = _minutesToTimeOfDay(existing?.endMinutes ?? 10 * 60);
  }

  bool get _isEdit => widget.existing != null;

  @override
  Widget build(BuildContext context) {
    final weeklyAsync = ref.watch(weeklyItemsStreamProvider);
    final oneTimeAsync = ref.watch(oneTimeItemsStreamProvider);
    final suggestions = <String>{
      ...weeklyAsync.value?.map((e) => e.title) ?? [],
      ...oneTimeAsync.value?.map((e) => e.title) ?? [],
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
              _isEdit ? 'แก้ไขรายการ' : 'เพิ่มรายการครั้งเดียว',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            TitleAutocompleteField(
              initialValue: _title,
              suggestions: suggestions,
              onChanged: (v) => _title = v,
            ),
            const SizedBox(height: 12),
            SegmentedButton<OneTimeItemType>(
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime.now().subtract(const Duration(days: 365)),
                  lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
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
                  onChanged: (t) => setState(() => _start = t),
                ),
                TimeOfDayField(
                  label: 'เวลาจบ',
                  time: _end,
                  onChanged: (t) => setState(() => _end = t),
                ),
              ],
            ],
            const SizedBox(height: 16),
            Row(
              children: [
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
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
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
    if (mounted) Navigator.of(context).pop();
  }
}

TimeOfDay _minutesToTimeOfDay(int minutes) =>
    TimeOfDay(hour: (minutes ~/ 60) % 24, minute: minutes % 60);
