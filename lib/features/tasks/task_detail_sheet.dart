import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/task_status.dart';
import '../../data/task_list_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../evening/task_form_sheet.dart';

/// "2/5" with a bar. Nothing when there are no steps.
class StepProgressBar extends StatelessWidget {
  final List<ChecklistItem> checklist;

  const StepProgressBar(this.checklist, {super.key});

  @override
  Widget build(BuildContext context) {
    if (checklist.isEmpty) return const SizedBox.shrink();
    final (done, total) = stepProgress([for (final i in checklist) i.done]);
    return Semantics(
      label: 'งานย่อยเสร็จ $done จาก $total',
      excludeSemantics: true,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(GlowRadius.pill),
              child: LinearProgressIndicator(
                value: done / total,
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: GlowSpacing.sm),
          Text('$done/$total', style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}

/// One task with its checklist.
Future<void> showTaskDetail(BuildContext context, int taskId) =>
    showGlowBottomSheet<void>(
      context: context,
      builder: (_) => _TaskDetail(taskId),
    );

class _TaskDetail extends ConsumerStatefulWidget {
  final int taskId;

  const _TaskDetail(this.taskId);

  @override
  ConsumerState<_TaskDetail> createState() => _TaskDetailState();
}

class _TaskDetailState extends ConsumerState<_TaskDetail> {
  final _newStep = TextEditingController();

  @override
  void dispose() {
    _newStep.dispose();
    super.dispose();
  }

  Future<void> _add() async {
    final title = _newStep.text;
    _newStep.clear();
    await ref.read(taskListRepositoryProvider).addStep(widget.taskId, title);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final entry = ref
        .watch(taskEntriesProvider)
        ?.where((e) => e.task.id == widget.taskId)
        .firstOrNull;
    // Removed, or still loading.
    if (entry == null) return const SizedBox(height: 80);
    final repo = ref.read(taskListRepositoryProvider);
    final now = ref.watch(clockProvider);
    final task = entry.task;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(task.title, style: textTheme.titleLarge),
            if (task.dueDate != null)
              Text(
                'ส่ง ${task.dueDate!.day}/${task.dueDate!.month}',
                style: textTheme.bodyMedium,
              ),
            const SizedBox(height: GlowSpacing.sm),
            StepProgressBar(entry.checklist),
            for (final item in entry.checklist)
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: item.done,
                onChanged: (v) => repo.tick(item, v ?? false, now: now()),
                title: Text(item.title, style: textTheme.bodyLarge),
                subtitle: item.isPart
                    ? Text(
                        '${item.minutes} นาที · เย็นวันที่ '
                        '${item.planDate!.day}/${item.planDate!.month}',
                        style: textTheme.bodyMedium,
                      )
                    : null,
                secondary: item.isPart
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.close),
                        tooltip: 'ลบงานย่อย ${item.title}',
                        onPressed: () => repo.removeStep(item.id),
                      ),
              ),
            // A split task's checklist is its planned parts.
            if (!entry.isSplit)
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _newStep,
                      maxLength: maxStepTitleLength,
                      decoration: const InputDecoration(
                        labelText: 'เพิ่มงานย่อย',
                        counterText: '',
                      ),
                      onSubmitted: (_) => _add(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    tooltip: 'เพิ่มงานย่อยนี้',
                    onPressed: _add,
                  ),
                ],
              ),
            const SizedBox(height: GlowSpacing.md),
            FilledButton(
              onPressed: () =>
                  repo.setTaskDone(task.id, !entry.done, now: now()),
              child: Text(entry.done ? 'ยังไม่เสร็จ' : 'ทำเสร็จแล้ว'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!entry.isSplit)
                  TextButton(
                    onPressed: () => showTaskForm(
                      context,
                      planDate: task.planDate,
                      existing: task,
                    ),
                    child: const Text('แก้งาน'),
                  ),
                TextButton(
                  onPressed: () async {
                    final evening = ref.read(eveningRepositoryProvider);
                    Navigator.of(context).pop();
                    await evening.removeTask(task.id);
                  },
                  child: const Text('ลบงาน'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
