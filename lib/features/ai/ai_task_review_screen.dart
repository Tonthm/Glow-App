import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/ai_validators.dart';
import '../../core/evening_planner.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../evening/task_form_sheet.dart';
import 'ai_badge.dart';
import 'ai_estimate_chip.dart';

const _defaultMinutes = 30;

class _Draft {
  String title;
  EveningTaskKind kind;
  DateTime? due;
  int minutes;
  int? aiEstimate;
  DateTime? examDate;
  final Set<AiTaskField> uncertain;

  _Draft(AiParsedTask task, this.examDate)
    : title = task.title,
      kind = task.kind,
      due = task.due,
      minutes = task.minutes ?? _defaultMinutes,
      // No time was said, so the default one needs checking.
      uncertain = {
        ...task.uncertain,
        if (task.minutes == null) AiTaskField.minutes,
      },
      needsTime = task.minutes == null;

  final bool needsTime;
}

/// Check, fix, then save the tasks the AI split out. Nothing is saved until
/// the user presses the button. Pops true once saved.
class AiTaskReviewScreen extends ConsumerStatefulWidget {
  final List<AiParsedTask> tasks;
  final DateTime planDate;

  const AiTaskReviewScreen({
    super.key,
    required this.tasks,
    required this.planDate,
  });

  @override
  ConsumerState<AiTaskReviewScreen> createState() => _AiTaskReviewScreenState();
}

class _AiTaskReviewScreenState extends ConsumerState<AiTaskReviewScreen> {
  late final List<_Draft> _drafts = [
    for (final task in widget.tasks) _Draft(task, _matchExam(task.examName)),
  ];
  bool _saving = false;

  List<OneTimeItem> get _exams {
    final today = ref.read(clockProvider)();
    final from = DateTime(today.year, today.month, today.day);
    return (ref.read(oneTimeItemsStreamProvider).value ?? [])
        .where((e) => e.type == OneTimeItemType.exam && !e.date.isBefore(from))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// The AI never sees the timetable, so its subject name is matched here.
  DateTime? _matchExam(String? name) {
    final wanted = name?.trim() ?? '';
    if (wanted.isEmpty) return null;
    for (final exam in _exams) {
      if (exam.title.contains(wanted) || wanted.contains(exam.title)) {
        return exam.date;
      }
    }
    return null;
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final repo = ref.read(eveningRepositoryProvider);
    final now = ref.read(clockProvider)();
    await ref.read(databaseProvider).transaction(() async {
      for (final draft in _drafts) {
        await repo.addTask(
          title: draft.title.trim(),
          minutes: draft.minutes,
          kind: draft.kind,
          planDate: widget.planDate,
          dueDate: draft.due,
          examDate: draft.kind == EveningTaskKind.examStudy
              ? draft.examDate
              : null,
          source: ItemSource.ai,
          aiEstimateMinutes: draft.aiEstimate,
          now: now,
        );
      }
    });
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final canSave =
        !_saving &&
        _drafts.isNotEmpty &&
        _drafts.every((d) => d.title.trim().isNotEmpty);
    return Scaffold(
      appBar: AppBar(title: const Text('ตรวจรายการ')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          const AiBadge(),
          Text(
            'ช่องสีเหลืองคือช่องที่ควรตรวจอีกครั้ง',
            style: textTheme.bodyMedium,
          ),
          for (final draft in _drafts) _card(context, draft),
          const SizedBox(height: GlowSpacing.xl),
          GlowPrimaryButton(
            label: 'บันทึก ${_drafts.length} งาน',
            onPressed: canSave ? _save : null,
          ),
        ],
      ),
    );
  }

  /// Yellow background plus a "ตรวจ" label, so color isn't the only cue.
  Widget _checkable(_Draft draft, AiTaskField field, Widget child) {
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
  void _edit(_Draft draft, AiTaskField field, VoidCallback change) {
    setState(() {
      change();
      draft.uncertain.remove(field);
    });
  }

  Widget _card(BuildContext context, _Draft draft) {
    final now = ref.read(clockProvider)();
    final today = DateTime(now.year, now.month, now.day);
    final exams = _exams;
    return Column(
      key: ObjectKey(draft),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Divider(height: GlowSpacing.xl),
        _checkable(
          draft,
          AiTaskField.title,
          TextFormField(
            initialValue: draft.title,
            decoration: const InputDecoration(labelText: 'ชื่องาน'),
            onChanged: (v) =>
                _edit(draft, AiTaskField.title, () => draft.title = v),
          ),
        ),
        _checkable(
          draft,
          AiTaskField.kind,
          Wrap(
            spacing: GlowSpacing.sm,
            children: [
              for (final entry in taskKindLabels.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: draft.kind == entry.key,
                  onSelected: (_) => _edit(
                    draft,
                    AiTaskField.kind,
                    () => draft.kind = entry.key,
                  ),
                ),
            ],
          ),
        ),
        _checkable(
          draft,
          AiTaskField.minutes,
          Row(
            children: [
              Expanded(child: Text('ใช้เวลาประมาณ ${draft.minutes} นาที')),
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                tooltip: 'ลด 5 นาที',
                onPressed: draft.minutes > 5
                    ? () => _edit(
                        draft,
                        AiTaskField.minutes,
                        () => draft.minutes -= 5,
                      )
                    : null,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                tooltip: 'เพิ่ม 5 นาที',
                onPressed: () =>
                    _edit(draft, AiTaskField.minutes, () => draft.minutes += 5),
              ),
            ],
          ),
        ),
        if (draft.needsTime)
          AiEstimateChip(
            key: ValueKey(draft.title),
            title: draft.title,
            due: draft.due,
            onEstimated: (e) => draft.aiEstimate = e.minutes,
            onAccept: (minutes) => _edit(
              draft,
              AiTaskField.minutes,
              () => draft.minutes = minutes,
            ),
          ),
        _checkable(
          draft,
          AiTaskField.due,
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              draft.due == null
                  ? 'ไม่มีวันส่ง'
                  : 'ส่ง ${draft.due!.day}/${draft.due!.month}/'
                        '${draft.due!.year}',
            ),
            trailing: draft.due == null
                ? const Icon(Icons.calendar_today_outlined)
                : IconButton(
                    icon: const Icon(Icons.close),
                    tooltip: 'เอาวันส่งออก',
                    onPressed: () =>
                        _edit(draft, AiTaskField.due, () => draft.due = null),
                  ),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: draft.due ?? today,
                firstDate: today,
                lastDate: DateTime(today.year + 1, today.month, today.day),
              );
              if (picked != null) {
                _edit(draft, AiTaskField.due, () => draft.due = picked);
              }
            },
          ),
        ),
        if (draft.kind == EveningTaskKind.examStudy && exams.isNotEmpty)
          _checkable(
            draft,
            AiTaskField.exam,
            Wrap(
              spacing: GlowSpacing.sm,
              children: [
                for (final exam in exams.take(6))
                  ChoiceChip(
                    label: Text(
                      '${exam.title} ${exam.date.day}/${exam.date.month}',
                    ),
                    selected: draft.examDate == exam.date,
                    onSelected: (on) => _edit(
                      draft,
                      AiTaskField.exam,
                      () => draft.examDate = on ? exam.date : null,
                    ),
                  ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => setState(() => _drafts.remove(draft)),
            child: const Text('เอารายการนี้ออก'),
          ),
        ),
      ],
    );
  }
}
