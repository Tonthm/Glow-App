import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/task_status.dart';
import '../../data/evening_repository.dart';
import '../../data/task_list_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../evening/task_form_sheet.dart';
import '../shared/subject_colors.dart';
import 'task_detail_sheet.dart';

const _stateLabels = {
  TaskState.doing: 'กำลังทำ',
  TaskState.missed: 'พลาด',
  TaskState.done: 'เสร็จ',
};

const _emptyMessages = {
  TaskState.doing: 'ไม่มีงานค้าง',
  TaskState.missed: 'ไม่มีงานที่เลยวันส่ง',
  TaskState.done: 'งานที่ทำเสร็จจะแสดงที่นี่',
};

/// Every task, filtered by where it stands.
class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  TaskState _filter = TaskState.doing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = ref.watch(clockProvider)();
    final all = ref.watch(taskEntriesProvider);
    final colors = ref.watch(subjectColorsProvider).value ?? const {};
    TaskState stateOf(TaskEntry e) =>
        taskState(done: e.done, due: e.task.dueDate, now: now);
    int count(TaskState s) => all?.where((e) => stateOf(e) == s).length ?? 0;

    final shown = [...?all?.where((e) => stateOf(e) == _filter)]
      ..sort((a, b) {
        // Soonest due first, then the ones with no due date.
        final x = a.task.dueDate, y = b.task.dueDate;
        final order = x == null
            ? (y == null ? 0 : 1)
            : y == null
            ? -1
            : x.compareTo(y);
        return order != 0 ? order : a.task.id.compareTo(b.task.id);
      });

    return Scaffold(
      appBar: AppBar(title: const Text('งานทั้งหมด')),
      body: all == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(GlowSpacing.pageMargin),
              children: [
                SegmentedButton<TaskState>(
                  showSelectedIcon: false,
                  segments: [
                    for (final entry in _stateLabels.entries)
                      ButtonSegment(
                        value: entry.key,
                        label: Text('${entry.value} ${count(entry.key)}'),
                      ),
                  ],
                  selected: {_filter},
                  onSelectionChanged: (v) =>
                      setState(() => _filter = v.single),
                ),
                const SizedBox(height: GlowSpacing.md),
                if (_filter == TaskState.missed && shown.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
                    child: Text(
                      'เลยวันส่งแล้ว ยังทำต่อได้ หรือติ๊กว่าเสร็จ',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                if (shown.isEmpty)
                  Text(
                    _emptyMessages[_filter]!,
                    style: theme.textTheme.bodyMedium,
                  ),
                for (final entry in shown)
                  Padding(
                    key: ValueKey(entry.task.id),
                    padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
                    child: GlowCard(
                      onTap: () => showTaskDetail(context, entry.task.id),
                      padding: const EdgeInsets.all(GlowSpacing.sm),
                      child: Row(
                        children: [
                          Semantics(
                            label: 'เสร็จ ${entry.task.title}',
                            child: Checkbox(
                              value: entry.done,
                              onChanged: (v) => ref
                                  .read(taskListRepositoryProvider)
                                  .setTaskDone(
                                    entry.task.id,
                                    v ?? false,
                                    now: now,
                                  ),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SubjectDot(colors, entry.task.title),
                                    Expanded(
                                      child: Text(
                                        entry.task.title,
                                        style: theme.textTheme.titleMedium,
                                      ),
                                    ),
                                  ],
                                ),
                                if (entry.task.dueDate case final due?)
                                  Text(
                                    'ส่ง ${due.day}/${due.month}',
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                StepProgressBar(entry.checklist),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GlowSpacing.md),
          child: GlowPrimaryButton(
            label: 'เพิ่มงาน',
            onPressed: () =>
                showTaskForm(context, planDate: eveningDateFor(now)),
          ),
        ),
      ),
    );
  }
}

Future<void> openTaskList(BuildContext context) => Navigator.of(context)
    .push(MaterialPageRoute<void>(builder: (_) => const TaskListScreen()));
