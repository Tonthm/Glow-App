import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/speech_problem.dart';
import '../../core/ai_config.dart';
import '../../core/evening_planner.dart';
import '../../core/thai_task_parser.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/ai/ai_assistant.dart';
import '../../services/app_clock.dart';
import '../../services/speech_service.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../ai/ai_estimate_chip.dart';
import '../ai/ai_providers.dart';
import '../ai/ai_task_review_screen.dart';
import '../schedule/voice_notice.dart';
import '../shared/title_autocomplete_field.dart';

const taskKindLabels = {
  EveningTaskKind.homework: 'การบ้าน',
  EveningTaskKind.reading: 'อ่านหนังสือ',
  EveningTaskKind.examStudy: 'อ่านสอบ',
  EveningTaskKind.other: 'อื่น ๆ',
};

const _quickMinutes = [15, 30, 45, 60, 90];

/// Adds a task for [planDate], or edits [existing].
Future<void> showTaskForm(
  BuildContext context, {
  required DateTime planDate,
  EveningTask? existing,
}) {
  return showGlowBottomSheet<void>(
    context: context,
    builder: (context) => Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: _TaskForm(planDate: planDate, existing: existing),
    ),
  );
}

class _TaskForm extends ConsumerStatefulWidget {
  final DateTime planDate;
  final EveningTask? existing;

  const _TaskForm({required this.planDate, this.existing});

  @override
  ConsumerState<_TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<_TaskForm> {
  late String _title = widget.existing?.title ?? '';
  late int _minutes = widget.existing?.minutes ?? 30;
  late DateTime? _due = widget.existing?.dueDate;
  late EveningTaskKind _kind = widget.existing == null
      ? EveningTaskKind.homework
      : EveningTaskKind.values[widget.existing!.kind];
  late DateTime? _examDate = widget.existing?.examDate;
  late final SpeechService _speech = ref.read(speechServiceProvider);
  bool _listening = false;
  bool _spoken = false;
  String? _message;

  /// Rebuilds the title field after voice input replaces the text.
  int _titleVersion = 0;

  /// The free-text box that goes to the AI, and whether one is on screen.
  final _freeText = TextEditingController();
  bool _aiBox = false;
  bool _aiBusy = false;

  /// True once the user or their voice has given a time.
  bool _minutesChosen = false;
  int? _aiEstimate;

  @override
  void dispose() {
    _speech.cancel();
    _freeText.dispose();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    if (_listening) {
      await _speech.stop();
      return;
    }
    if (!await acceptVoiceNotice(context, ref)) return;
    try {
      if (!await _speech.prepare()) {
        _micFailed(SpeechProblem.unavailable);
        return;
      }
      if (!mounted) return;
      setState(() => _message = null);
      await _speech.listen(
        onText: _fillFrom,
        onListeningChanged: (value) {
          if (mounted) setState(() => _listening = value);
        },
        onError: (code) => _micFailed(speechProblem(code)),
      );
    } catch (_) {
      _micFailed(SpeechProblem.unavailable);
    }
  }

  void _micFailed(SpeechProblem problem) {
    if (!mounted) return;
    if (micCannotWork(problem)) {
      ref.read(micBrokenProvider.notifier).state = true;
    }
    setState(() {
      _listening = false;
      _message = speechProblemMessage(problem);
    });
  }

  /// With AI on, speech goes into the AI box; otherwise straight to the form.
  void _fillFrom(String words) {
    if (!mounted) return;
    _spoken = true;
    if (_aiBox) {
      setState(() => _freeText.text = words);
    } else {
      _fillWithRules(words);
    }
  }

  /// Fills the form by rules, no AI; everything stays editable.
  void _fillWithRules(String words) {
    final task = parseSpokenTask(words, now: ref.read(clockProvider)());
    setState(() {
      _title = task.title;
      _titleVersion++;
      _kind = task.kind;
      if (task.minutes != null) {
        _minutes = task.minutes!;
        _minutesChosen = true;
      }
      if (task.due != null) _due = task.due;
    });
  }

  Future<void> _splitWithAi() async {
    final text = _freeText.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _aiBusy = true;
      _message = null;
    });
    final result = await ref
        .read(aiAssistantProvider)
        .parseTasks(text, today: ref.read(clockProvider)());
    if (!mounted) return;
    setState(() => _aiBusy = false);
    final tasks = result.value;
    if (tasks == null) {
      _fillWithRules(text);
      setState(() => _message = aiFailureMessage(result.failure!));
      return;
    }
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            AiTaskReviewScreen(tasks: tasks, planDate: widget.planDate),
      ),
    );
    if (saved == true && mounted) Navigator.of(context).pop();
  }

  void _chooseMinutes(int minutes) => setState(() {
    _minutes = minutes;
    _minutesChosen = true;
  });

  Future<void> _save() async {
    final repo = ref.read(eveningRepositoryProvider);
    final examDate = _kind == EveningTaskKind.examStudy ? _examDate : null;
    final existing = widget.existing;
    if (existing == null) {
      await repo.addTask(
        title: _title.trim(),
        minutes: _minutes,
        kind: _kind,
        planDate: widget.planDate,
        now: ref.read(clockProvider)(),
        dueDate: _due,
        examDate: examDate,
        source: _spoken ? ItemSource.voice : ItemSource.typed,
        aiEstimateMinutes: _aiEstimate,
      );
    } else {
      await repo.updateTask(
        existing.copyWith(
          title: _title.trim(),
          minutes: _minutes,
          kind: _kind.index,
          dueDate: Value(_due),
          examDate: Value(examDate),
        ),
      );
    }
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = ref.watch(clockProvider)();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(today.year, today.month, today.day + 1);
    final exams =
        (ref.watch(oneTimeItemsStreamProvider).value ?? [])
            .where(
              (e) => e.type == OneTimeItemType.exam && !e.date.isBefore(today),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));
    final pastTitles = ref.watch(taskTitlesProvider).value ?? const [];
    final aiReady = ref.watch(aiReadyProvider).value ?? false;
    _aiBox = aiReady && widget.existing == null;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.existing == null ? 'เพิ่มงาน' : 'แก้งาน',
                    style: textTheme.titleLarge,
                  ),
                ),
                if (ref.watch(micAvailableProvider))
                  IconButton(
                    icon: Icon(
                      _listening ? Icons.stop : Icons.mic_none_outlined,
                    ),
                    tooltip: _listening ? 'หยุดฟัง' : 'พูดเพิ่มงาน',
                    onPressed: _toggleMic,
                  ),
              ],
            ),
            if (_listening || _message != null)
              Text(
                _message ?? 'กำลังฟัง… เช่น "การบ้านเลขสี่สิบนาทีส่งพรุ่งนี้"',
                style: textTheme.bodyMedium,
              ),
            if (_aiBox) ...[
              TextField(
                controller: _freeText,
                minLines: 1,
                maxLines: 4,
                maxLength: aiMaxInputChars,
                decoration: const InputDecoration(
                  labelText: 'บอกหลายงานในครั้งเดียวได้',
                  hintText: 'ส่งรายงานชีวะศุกร์ แล้วก็ทำเลข 2 หน้า',
                ),
              ),
              TextButton.icon(
                icon: const Icon(Icons.auto_awesome_outlined, size: 16),
                label: Text(_aiBusy ? 'กำลังแยกงาน…' : 'ให้ AI แยกงาน'),
                onPressed: _aiBusy ? null : _splitWithAi,
              ),
              Text('หรือใส่ทีละงาน', style: textTheme.bodyMedium),
            ],
            const SizedBox(height: GlowSpacing.sm),
            TitleAutocompleteField(
              key: ValueKey(_titleVersion),
              initialValue: _title,
              suggestions: pastTitles,
              label: 'ชื่องาน',
              onChanged: (v) => setState(() {
                _title = v;
                _aiEstimate = null;
              }),
            ),
            const SizedBox(height: GlowSpacing.md),
            Row(
              children: [
                Expanded(child: Text('ใช้เวลาประมาณ $_minutes นาที')),
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  tooltip: 'ลด 5 นาที',
                  onPressed: _minutes > 5
                      ? () => _chooseMinutes(_minutes - 5)
                      : null,
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  tooltip: 'เพิ่ม 5 นาที',
                  onPressed: () => _chooseMinutes(_minutes + 5),
                ),
              ],
            ),
            Wrap(
              spacing: GlowSpacing.sm,
              children: [
                for (final m in _quickMinutes)
                  ChoiceChip(
                    label: Text('$m'),
                    selected: _minutes == m,
                    onSelected: (_) => _chooseMinutes(m),
                  ),
              ],
            ),
            if (_aiBox && !_minutesChosen && _title.trim().isNotEmpty)
              AiEstimateChip(
                key: ValueKey(_title.trim()),
                title: _title,
                due: _due,
                onEstimated: (e) => _aiEstimate = e.minutes,
                // Keeps the chip on screen, so the reason stays readable.
                onAccept: (m) => setState(() => _minutes = m),
              ),
            const SizedBox(height: GlowSpacing.md),
            Text('ประเภท', style: textTheme.bodyMedium),
            Wrap(
              spacing: GlowSpacing.sm,
              children: [
                for (final entry in taskKindLabels.entries)
                  ChoiceChip(
                    label: Text(entry.value),
                    selected: _kind == entry.key,
                    onSelected: (_) => setState(() => _kind = entry.key),
                  ),
              ],
            ),
            if (_kind == EveningTaskKind.examStudy && exams.isNotEmpty) ...[
              const SizedBox(height: GlowSpacing.md),
              Text('สอบวิชา', style: textTheme.bodyMedium),
              Wrap(
                spacing: GlowSpacing.sm,
                children: [
                  for (final exam in exams.take(6))
                    ChoiceChip(
                      label: Text(
                        '${exam.title} ${exam.date.day}/${exam.date.month}',
                      ),
                      selected: _examDate == exam.date,
                      onSelected: (on) =>
                          setState(() => _examDate = on ? exam.date : null),
                    ),
                ],
              ),
            ],
            const SizedBox(height: GlowSpacing.md),
            Text('วันส่ง (ไม่ใส่ก็ได้)', style: textTheme.bodyMedium),
            Wrap(
              spacing: GlowSpacing.sm,
              children: [
                ChoiceChip(
                  label: const Text('ไม่มี'),
                  selected: _due == null,
                  onSelected: (_) => setState(() => _due = null),
                ),
                ChoiceChip(
                  label: const Text('พรุ่งนี้'),
                  selected: _due == tomorrow,
                  onSelected: (_) => setState(() => _due = tomorrow),
                ),
                ActionChip(
                  label: Text(
                    _due == null || _due == tomorrow
                        ? 'เลือกวัน'
                        : '${_due!.day}/${_due!.month}',
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _due ?? tomorrow,
                      firstDate: DateTime(today.year - 1),
                      lastDate: DateTime(today.year + 2),
                    );
                    if (picked != null) setState(() => _due = picked);
                  },
                ),
              ],
            ),
            const SizedBox(height: GlowSpacing.lg),
            GlowPrimaryButton(
              label: 'บันทึก',
              onPressed: _title.trim().isEmpty ? null : _save,
            ),
          ],
        ),
      ),
    );
  }
}
