import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/schedule_models.dart';
import '../../core/thai_schedule_parser.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../shared/time_of_day_field.dart';
import 'add_item_sheet.dart';

const _dayNames = [
  'จันทร์',
  'อังคาร',
  'พุธ',
  'พฤหัส',
  'ศุกร์',
  'เสาร์',
  'อาทิตย์',
];

const _kindNames = {
  ItemKind.classSession: 'คาบเรียน',
  ItemKind.exam: 'สอบ',
  ItemKind.activity: 'กิจกรรม',
  ItemKind.holiday: 'วันหยุด',
};

/// An editable copy of one parsed item. A weekly item has [weekday], a
/// one-off item has [date].
class _Draft {
  String title;
  ItemKind kind;
  int? weekday;
  DateTime? date;
  int startMinutes;
  int endMinutes;
  final Set<ParsedField> uncertain;

  _Draft(ParsedScheduleItem item)
    : title = item.title,
      kind = item.kind,
      weekday = item.weekday,
      date = item.date,
      startMinutes = item.startMinutes ?? 8 * 60,
      endMinutes = item.endMinutes ?? 9 * 60,
      uncertain = {...item.uncertain};

  bool get isWeekly => date == null;
  bool get hasTimes => kind != ItemKind.holiday;

  bool get isValid =>
      (!hasTimes || endMinutes > startMinutes) &&
      (kind == ItemKind.holiday || title.trim().isNotEmpty);

  /// Exams and holidays happen once; classes repeat weekly.
  void changeKind(ItemKind newKind, DateTime today) {
    kind = newKind;
    final needsDate = newKind == ItemKind.exam || newKind == ItemKind.holiday;
    if (needsDate && date == null) {
      final ahead = (weekday! - today.weekday + 7) % 7;
      date = DateTime(today.year, today.month, today.day + ahead);
      weekday = null;
      uncertain.add(ParsedField.day);
    } else if (newKind == ItemKind.classSession && date != null) {
      weekday = date!.weekday;
      date = null;
      uncertain.add(ParsedField.day);
    }
  }
}

/// Step 3-5 of "พูดใส่ตาราง": check each item, fix what's highlighted, save.
class VoiceReviewScreen extends ConsumerStatefulWidget {
  final ThaiScheduleParseResult result;

  const VoiceReviewScreen({super.key, required this.result});

  @override
  ConsumerState<VoiceReviewScreen> createState() => _VoiceReviewScreenState();
}

class _VoiceReviewScreenState extends ConsumerState<VoiceReviewScreen> {
  late final List<_Draft> _drafts = widget.result.items
      .map(_Draft.new)
      .toList();
  bool _saving = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(scheduleRepositoryProvider);
    await ref.read(databaseProvider).transaction(() async {
      for (final draft in _drafts) {
        final title = draft.title.trim().isEmpty
            ? 'วันหยุด'
            : draft.title.trim();
        final start = draft.hasTimes ? draft.startMinutes : null;
        final end = draft.hasTimes ? draft.endMinutes : null;
        if (draft.isWeekly) {
          await repo.addWeeklyItem(
            title: title,
            dayOfWeek: draft.weekday!,
            startMinutes: draft.startMinutes,
            endMinutes: draft.endMinutes,
            type: draft.kind == ItemKind.activity
                ? WeeklyItemType.activity
                : WeeklyItemType.classSession,
            source: ItemSource.voice,
          );
        } else {
          await repo.addOneTimeItem(
            title: title,
            date: draft.date!,
            type: switch (draft.kind) {
              ItemKind.exam => OneTimeItemType.exam,
              ItemKind.holiday => OneTimeItemType.holiday,
              _ => OneTimeItemType.activity,
            },
            startMinutes: start,
            endMinutes: end,
            source: ItemSource.voice,
          );
        }
      }
    });
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canSave =
        !_saving && _drafts.isNotEmpty && _drafts.every((d) => d.isValid);
    return Scaffold(
      appBar: AppBar(
        title: const Text('ตรวจรายการ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_outlined),
            tooltip: 'เพิ่มด้วยการพิมพ์',
            onPressed: () => showTypedEntryChooser(context),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          Text(
            'ช่องสีเหลืองคือช่องที่ควรตรวจอีกครั้ง',
            style: textTheme.bodyMedium,
          ),
          for (final draft in _drafts)
            _DraftCard(
              key: ObjectKey(draft),
              draft: draft,
              onChanged: () => setState(() {}),
              onRemove: () => setState(() => _drafts.remove(draft)),
            ),
          if (widget.result.unparsed.isNotEmpty) ...[
            const SizedBox(height: GlowSpacing.lg),
            Text('ส่วนที่แยกไม่ออก', style: textTheme.titleLarge),
            for (final text in widget.result.unparsed)
              Text(text, style: textTheme.bodyLarge),
          ],
          const SizedBox(height: GlowSpacing.xl),
          GlowPrimaryButton(
            label: 'บันทึก ${_drafts.length} รายการ',
            onPressed: canSave ? _save : null,
          ),
        ],
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  final _Draft draft;
  final VoidCallback onChanged;
  final VoidCallback onRemove;

  const _DraftCard({
    super.key,
    required this.draft,
    required this.onChanged,
    required this.onRemove,
  });

  /// Yellow background plus a "ตรวจ" label, so color isn't the only cue.
  Widget _checkable(BuildContext context, ParsedField field, Widget child) {
    if (!draft.uncertain.contains(field)) return child;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: GlowSpacing.xs),
      padding: const EdgeInsets.all(GlowSpacing.sm),
      decoration: BoxDecoration(
        color: context.glowColors.almostEnough.withValues(alpha: 0.28),
        borderRadius: BorderRadius.circular(GlowRadius.button),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('ตรวจช่องนี้', style: Theme.of(context).textTheme.labelSmall),
          Material(type: MaterialType.transparency, child: child),
        ],
      ),
    );
  }

  /// Once the user has touched a field it no longer needs highlighting.
  void _edit(ParsedField field, VoidCallback change) {
    change();
    draft.uncertain.remove(field);
    onChanged();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    TimeOfDay time(int minutes) =>
        TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: GlowSpacing.xl),
        _checkable(
          context,
          ParsedField.title,
          TextFormField(
            initialValue: draft.title,
            decoration: const InputDecoration(labelText: 'ชื่อวิชา/กิจกรรม'),
            onChanged: (v) => _edit(ParsedField.title, () => draft.title = v),
          ),
        ),
        const SizedBox(height: GlowSpacing.sm),
        Row(
          children: [
            Expanded(
              child: DropdownButton<ItemKind>(
                isExpanded: true,
                value: draft.kind,
                items: [
                  for (final entry in _kindNames.entries)
                    DropdownMenuItem(
                      value: entry.key,
                      child: Text(entry.value),
                    ),
                ],
                onChanged: (kind) {
                  if (kind == null) return;
                  draft.changeKind(kind, today);
                  onChanged();
                },
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: 'เอารายการนี้ออก',
              onPressed: onRemove,
            ),
          ],
        ),
        _checkable(
          context,
          ParsedField.day,
          draft.isWeekly
              ? DropdownButton<int>(
                  isExpanded: true,
                  value: draft.weekday,
                  items: [
                    for (var day = 1; day <= 7; day++)
                      DropdownMenuItem(
                        value: day,
                        child: Text('ทุกวัน${_dayNames[day - 1]}'),
                      ),
                  ],
                  onChanged: (day) =>
                      _edit(ParsedField.day, () => draft.weekday = day),
                )
              : ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'วัน${_dayNames[draft.date!.weekday - 1]} '
                    '${draft.date!.day}/${draft.date!.month}/${draft.date!.year}',
                  ),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: draft.date!,
                      firstDate: DateTime(today.year - 1),
                      lastDate: DateTime(today.year + 2, 12, 31),
                    );
                    if (picked != null) {
                      _edit(ParsedField.day, () => draft.date = picked);
                    }
                  },
                ),
        ),
        if (draft.hasTimes) ...[
          _checkable(
            context,
            ParsedField.start,
            TimeOfDayField(
              label: 'เวลาเริ่ม',
              time: time(draft.startMinutes),
              onChanged: (t) => _edit(
                ParsedField.start,
                () => draft.startMinutes = t.hour * 60 + t.minute,
              ),
            ),
          ),
          _checkable(
            context,
            ParsedField.end,
            TimeOfDayField(
              label: 'เวลาจบ',
              time: time(draft.endMinutes),
              onChanged: (t) => _edit(
                ParsedField.end,
                () => draft.endMinutes = t.hour * 60 + t.minute,
              ),
            ),
          ),
          if (draft.endMinutes <= draft.startMinutes)
            Text(
              'เวลาจบต้องอยู่หลังเวลาเริ่ม',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ],
    );
  }
}
