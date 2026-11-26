import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/timetable_import.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/warning_bar.dart';
import '../shared/time_of_day_field.dart';

const _dayNames = [
  'จันทร์',
  'อังคาร',
  'พุธ',
  'พฤหัส',
  'ศุกร์',
  'เสาร์',
  'อาทิตย์',
];

const _choiceLabels = {
  ImportChoice.skip: 'ข้าม',
  ImportChoice.replace: 'แทนที่',
  ImportChoice.add: 'เพิ่ม',
};

/// One item while the user checks it.
class _Draft {
  String title;
  int day;
  int start;
  int end;
  final ImportedClass read;

  /// Null until the user picks; then the safe choice no longer applies.
  ImportChoice? choice;

  /// Fields the user has looked at and changed are no longer marked.
  final Set<ImportField> checked = {};

  _Draft(this.read)
    : title = read.title,
      day = read.day,
      start = read.startMinutes,
      end = read.endMinutes;

  bool get isValid => title.trim().isNotEmpty && end > start;

  bool marked(ImportField field) =>
      read.isUncertain(field) && !checked.contains(field);

  ImportedClass get value => ImportedClass(
    title: title.trim(),
    day: day,
    startMinutes: start,
    endMinutes: end,
    confidence: read.confidence,
  );
}

/// The check page, like the one after speaking: fix, remove, decide about
/// clashes, and only then save. Nothing is saved without the button.
class TimetableReview extends ConsumerStatefulWidget {
  final TimetableReading reading;

  /// What was sent, to compare against. Held in memory only.
  final Uint8List picture;
  final VoidCallback onTypeInstead;

  const TimetableReview({
    super.key,
    required this.reading,
    required this.picture,
    required this.onTypeInstead,
  });

  @override
  ConsumerState<TimetableReview> createState() => _TimetableReviewState();
}

class _TimetableReviewState extends ConsumerState<TimetableReview> {
  late final List<_Draft> _drafts = widget.reading.items.map(_Draft.new).toList();
  bool _saving = false;

  List<ExistingClass> _existing(List<WeeklyItem> rows) => [
    for (final r in rows)
      ExistingClass(
        id: r.id,
        title: r.title,
        day: r.dayOfWeek,
        start: r.startMinutes,
        end: r.endMinutes,
      ),
  ];

  ImportChoice _choiceOf(_Draft draft, List<ExistingClass> existing) =>
      overlapping(draft.value, existing).isEmpty
      ? ImportChoice.add
      : draft.choice ?? defaultChoice(draft.value, existing);

  Future<void> _save() async {
    if (_saving) return;
    setState(() => _saving = true);
    final db = ref.read(databaseProvider);
    final repo = ref.read(scheduleRepositoryProvider);
    await db.transaction(() async {
      // Read again, in case the timetable changed while checking.
      final existing = _existing(await repo.getWeeklyItems());
      final plan = importPlan([
        for (final d in _drafts) (d.value, _choiceOf(d, existing)),
      ], existing);
      for (final id in plan.removeIds) {
        await repo.deleteWeeklyItem(id);
      }
      for (final c in plan.add) {
        await repo.addWeeklyItem(
          title: c.title,
          dayOfWeek: c.day,
          startMinutes: c.startMinutes,
          endMinutes: c.endMinutes,
          type: WeeklyItemType.classSession,
          source: ItemSource.ai,
        );
      }
    });
    if (mounted) Navigator.of(context).pop(true);
  }

  void _showPicture() => Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('รูปต้นฉบับ')),
        body: InteractiveViewer(
          maxScale: 6,
          child: Center(child: Image.memory(widget.picture)),
        ),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final weekly = ref.watch(weeklyItemsStreamProvider).value;
    if (weekly == null) return const Center(child: CircularProgressIndicator());
    final existing = _existing(weekly);
    final saving = _drafts
        .where((d) => _choiceOf(d, existing) != ImportChoice.skip)
        .length;
    final canSave =
        !_saving && saving > 0 && _drafts.every((d) => d.isValid);
    final dropped = widget.reading.dropped;

    return Column(
      children: [
        Expanded(
          // Built all at once, so typed changes survive scrolling.
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(GlowSpacing.pageMargin),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'AI อ่านได้ ${widget.reading.items.length} คาบ '
                  'ตรวจเทียบกับรูปก่อนบันทึก ช่องสีเหลืองคือช่องที่ไม่แน่ใจ',
                  style: textTheme.bodyLarge,
                ),
                Semantics(
                  label: 'ดูรูปต้นฉบับ',
                  button: true,
                  child: InkWell(
                    onTap: _showPicture,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: GlowSpacing.sm,
                      ),
                      child: Image.memory(
                        widget.picture,
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: _showPicture,
                  child: const Text('ดูรูปต้นฉบับ'),
                ),
                if (dropped > 0)
                  Padding(
                    padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
                    child: WarningBar(
                      severity: WarningBarSeverity.yellow,
                      message:
                          'มี $dropped รายการที่ไม่ผ่านการตรวจ จึงไม่แสดง '
                          'ดูในรูปแล้วเพิ่มเอง',
                    ),
                  ),
                if (widget.reading.unreadable.isNotEmpty) ...[
                  Text('ส่วนที่อ่านไม่ออก', style: textTheme.titleMedium),
                  for (final line in widget.reading.unreadable)
                    Text(line, style: textTheme.bodyMedium),
                  const SizedBox(height: GlowSpacing.sm),
                ],
                for (final draft in _drafts)
                  _card(context, draft, existing),
                TextButton(
                  onPressed: widget.onTypeInstead,
                  child: const Text('พิมพ์ / พูดแทน'),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(GlowSpacing.md),
          child: GlowPrimaryButton(
            label: 'บันทึก $saving คาบ',
            onPressed: canSave ? _save : null,
          ),
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    _Draft draft,
    List<ExistingClass> existing,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final clashes = overlapping(draft.value, existing);

    // A Material, so a row's tap ripple still shows on the highlight.
    Widget field(ImportField which, Widget child) => Material(
      color: draft.marked(which)
          ? context.glowColors.pastel(GlowPastel.butter)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(GlowRadius.button),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: GlowSpacing.xs),
        child: child,
      ),
    );
    void change(ImportField which, VoidCallback apply) => setState(() {
      apply();
      draft.checked.add(which);
    });
    TimeOfDay time(int minutes) =>
        TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

    return Padding(
      key: ObjectKey(draft),
      padding: const EdgeInsets.only(bottom: GlowSpacing.md),
      child: GlowCard(
        padding: const EdgeInsets.all(GlowSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            field(
              ImportField.title,
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: draft.title,
                      decoration: const InputDecoration(labelText: 'ชื่อวิชา'),
                      onChanged: (v) =>
                          change(ImportField.title, () => draft.title = v),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    tooltip: 'ลบรายการ ${draft.title}',
                    onPressed: () => setState(() => _drafts.remove(draft)),
                  ),
                ],
              ),
            ),
            field(
              ImportField.day,
              DropdownButton<int>(
                value: draft.day,
                isExpanded: true,
                items: [
                  for (var day = 1; day <= 7; day++)
                    DropdownMenuItem(
                      value: day,
                      child: Text('วัน${_dayNames[day - 1]}'),
                    ),
                ],
                onChanged: (v) =>
                    change(ImportField.day, () => draft.day = v!),
              ),
            ),
            field(
              ImportField.start,
              TimeOfDayField(
                label: 'เวลาเริ่ม',
                time: time(draft.start),
                onChanged: (t) => change(
                  ImportField.start,
                  () => draft.start = t.hour * 60 + t.minute,
                ),
              ),
            ),
            field(
              ImportField.end,
              TimeOfDayField(
                label: 'เวลาจบ',
                time: time(draft.end),
                onChanged: (t) => change(
                  ImportField.end,
                  () => draft.end = t.hour * 60 + t.minute,
                ),
              ),
            ),
            if (!draft.isValid)
              Text(
                'ต้องมีชื่อ และเวลาจบต้องอยู่หลังเวลาเริ่ม',
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            if (draft.read.room != null || draft.read.teacher != null)
              Text(
                [
                  if (draft.read.room != null) 'ห้อง ${draft.read.room}',
                  if (draft.read.teacher != null)
                    'ผู้สอน ${draft.read.teacher}',
                  '(แสดงให้ตรวจ ไม่ได้บันทึก)',
                ].join(' · '),
                style: textTheme.bodyMedium,
              ),
            if (clashes.isNotEmpty) ...[
              const SizedBox(height: GlowSpacing.sm),
              Text(
                'ซ้อนกับ ${clashes.map((c) => c.title).join(', ')} '
                'ที่มีอยู่แล้ว (แทนที่ = ลบคาบเดิมที่ซ้อน)',
                style: textTheme.bodyLarge,
              ),
              SegmentedButton<ImportChoice>(
                showSelectedIcon: false,
                segments: [
                  for (final entry in _choiceLabels.entries)
                    ButtonSegment(value: entry.key, label: Text(entry.value)),
                ],
                selected: {_choiceOf(draft, existing)},
                onSelectionChanged: (v) =>
                    setState(() => draft.choice = v.single),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
