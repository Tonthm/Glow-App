import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/split_scheduler.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/ai/ai_assistant.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'ai_badge.dart';
import 'ai_providers.dart';

/// A task longer than this can be split.
const int splitOverMinutes = 90;

/// "แบ่งงานให้": the AI proposes the parts, core/ checks them and picks the
/// evenings, and nothing changes until the user accepts.
Future<void> showAiSplit(
  BuildContext context, {
  required EveningTask task,
  required DateTime firstEvening,
}) {
  return showGlowBottomSheet<void>(
    context: context,
    builder: (context) => _SplitSheet(task: task, firstEvening: firstEvening),
  );
}

class _SplitSheet extends ConsumerStatefulWidget {
  final EveningTask task;
  final DateTime firstEvening;

  const _SplitSheet({required this.task, required this.firstEvening});

  @override
  ConsumerState<_SplitSheet> createState() => _SplitSheetState();
}

class _SplitSheetState extends ConsumerState<_SplitSheet> {
  List<ScheduledPart>? _parts;
  String? _message;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _ask();
  }

  Future<void> _ask() async {
    final task = widget.task;
    final result = await ref
        .read(aiAssistantProvider)
        .split(
          title: task.title,
          totalMinutes: task.minutes - task.doneMinutes,
          today: ref.read(clockProvider)(),
          due: task.dueDate,
        );
    if (!mounted) return;
    setState(() {
      if (result.value == null) {
        _message =
            '${aiFailureMessage(result.failure!)} '
            'แบ่งเองได้โดยเพิ่มเป็นหลายงาน';
        return;
      }
      _parts = scheduleParts(
        parts: result.value!,
        firstEvening: widget.firstEvening,
        due: task.dueDate,
        examDate: task.examDate,
      );
      if (_parts == null) {
        _message = 'สอบใกล้มากแล้ว คืนก่อนสอบทบทวนเบา ๆ ก็พอ จึงไม่แบ่งงานนี้';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final parts = _parts;
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('แบ่ง "${widget.task.title}"', style: textTheme.titleLarge),
            const SizedBox(height: GlowSpacing.md),
            if (parts == null && _message == null)
              const Center(child: CircularProgressIndicator()),
            if (_message != null) Text(_message!, style: textTheme.bodyLarge),
            if (parts != null) ...[
              const AiBadge(),
              for (final scheduled in parts)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(scheduled.part.title),
                  subtitle: Text(
                    '${scheduled.part.minutes} นาที · ทำวันที่ '
                    '${scheduled.date.day}/${scheduled.date.month}',
                  ),
                ),
              const SizedBox(height: GlowSpacing.md),
              GlowPrimaryButton(
                label: 'รับตามนี้',
                onPressed: _saving
                    ? null
                    : () async {
                        setState(() => _saving = true);
                        await ref
                            .read(eveningRepositoryProvider)
                            .acceptSplit(
                              widget.task,
                              parts,
                              now: ref.read(clockProvider)(),
                            );
                        if (context.mounted) Navigator.of(context).pop();
                      },
              ),
            ],
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(parts == null ? 'ปิด' : 'ไม่รับ'),
            ),
          ],
        ),
      ),
    );
  }
}
