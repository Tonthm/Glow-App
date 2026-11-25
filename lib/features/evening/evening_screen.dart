import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/evening_planner.dart';
import '../../data/database.dart';
import '../../data/evening_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/empty_state.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/warning_bar.dart';
import 'evening_providers.dart';
import 'task_form_sheet.dart';

String formatClock(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:'
    '${t.minute.toString().padLeft(2, '0')}';

/// Tonight as a timeline, ending at the put-the-phone-down time (section 14).
class EveningScreen extends ConsumerStatefulWidget {
  /// Opens the stretching routine once the last block is done; null when the
  /// routine isn't available.
  final Future<void> Function()? onStartRoutine;

  const EveningScreen({super.key, this.onStartRoutine});

  @override
  ConsumerState<EveningScreen> createState() => _EveningScreenState();
}

class _EveningScreenState extends ConsumerState<EveningScreen> {
  late final Timer _tick;

  @override
  void initState() {
    super.initState();
    // Keeps "ช้าไป" and the current block up to date.
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick.cancel();
    super.dispose();
  }

  EveningRepository get _repo => ref.read(eveningRepositoryProvider);

  void _reload() => ref.invalidate(eveningViewProvider);

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(eveningViewProvider);
    final view = async.value;
    return Scaffold(
      appBar: AppBar(title: const Text('ตารางเย็นนี้')),
      body: view == null
          ? Center(
              child: async.hasError
                  ? Text('เกิดข้อผิดพลาด: ${async.error}')
                  : const CircularProgressIndicator(),
            )
          : _buildBody(context, view),
      bottomNavigationBar: view == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(GlowSpacing.md),
                child: GlowPrimaryButton(
                  label: 'เพิ่มงาน',
                  onPressed: () async {
                    await showTaskForm(context, planDate: view.eveningDate);
                    _reload();
                  },
                ),
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context, EveningView view) {
    final textTheme = Theme.of(context).textTheme;
    final now = ref.read(clockProvider)();
    final plan = view.plan;
    final late = behindBy(plan, now);
    final tonight = view.eveningDate == eveningDateFor(now);
    final phoneDownPassed = !now.isBefore(view.notifyTime);

    return ListView(
      padding: const EdgeInsets.all(GlowSpacing.pageMargin),
      children: [
        Text(
          'ตั้งแต่ ${formatClock(plan.start)} · '
          'วางมือถือ ${formatClock(view.notifyTime)}',
          style: textTheme.bodyMedium,
        ),
        if (view.canStartNow)
          TextButton(
            onPressed: () async {
              await _repo.startNow(now);
              _reload();
            },
            child: const Text('เริ่มตอนนี้'),
          ),
        if (view.redNight) ...[
          const SizedBox(height: GlowSpacing.sm),
          WarningBar(
            severity: WarningBarSeverity.red,
            message: plan.postponedForRedNight.isEmpty
                ? 'คืนนี้เวลาน้อย'
                : 'คืนนี้เวลาน้อย วางเฉพาะงานที่ส่งพรุ่งนี้หรือเลยกำหนด '
                      'งานอื่นจะเลื่อนให้เอง: '
                      '${plan.postponedForRedNight.map((id) => view.taskById(id)?.title).join(', ')}',
          ),
        ],
        if (phoneDownPassed && tonight) ...[
          const SizedBox(height: GlowSpacing.sm),
          Text(
            'ถึงเวลาวางมือถือแล้ว งานที่ยังไม่เสร็จเลื่อนไปพรุ่งนี้ให้เอง',
            style: textTheme.bodyLarge,
          ),
        ],
        if (late != null && !phoneDownPassed) ...[
          const SizedBox(height: GlowSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Text(
                  'ช้าไป ${late.inMinutes} นาที จัดใหม่ไหม',
                  style: textTheme.bodyLarge,
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _repo.replanFrom(now);
                  _reload();
                },
                child: const Text('จัดใหม่'),
              ),
            ],
          ),
        ],
        if (plan.overflow.isNotEmpty) _buildOverflow(context, view),
        if (view.suggestions.isNotEmpty && !phoneDownPassed) ...[
          const SizedBox(height: GlowSpacing.md),
          Wrap(
            spacing: GlowSpacing.sm,
            children: [
              for (final s in view.suggestions)
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: Text(
                    'แนะนำ: ${s.lightReview ? 'ทบทวนเบา ๆ' : 'อ่าน'} '
                    '${s.examTitle} ${s.minutes} นาที',
                  ),
                  onPressed: () async {
                    await _repo.addTask(
                      title:
                          '${s.lightReview ? 'ทบทวน' : 'อ่าน'}'
                          ' ${s.examTitle}',
                      minutes: s.minutes,
                      kind: EveningTaskKind.examStudy,
                      planDate: view.eveningDate,
                      examDate: s.examDate,
                      suggested: true,
                    );
                    _reload();
                  },
                ),
            ],
          ),
        ],
        const SizedBox(height: GlowSpacing.md),
        if (view.tasks.isEmpty && view.doneTasks.isEmpty)
          const EmptyState(
            icon: Icons.checklist_outlined,
            message: 'ยังไม่มีงานคืนนี้ แตะ "เพิ่มงาน" เพื่อจัดเวลาให้',
          ),
        for (final block in plan.blocks) _buildBlock(context, view, block),
        _buildLine(context, view.notifyTime, 'วางมือถือ'),
        if (view.tasks.isNotEmpty) ...[
          const Divider(height: GlowSpacing.xxl),
          Text('งานคืนนี้', style: textTheme.titleLarge),
          for (var i = 0; i < view.tasks.length; i++)
            _buildTaskRow(context, view, i),
        ],
        if (view.doneTasks.isNotEmpty) ...[
          const SizedBox(height: GlowSpacing.md),
          Text(
            'เสร็จแล้ว: ${view.doneTasks.map((t) => t.title).join(', ')}',
            style: textTheme.bodyMedium,
          ),
        ],
        // After the last block comes the routine.
        if (widget.onStartRoutine != null &&
            view.tasks.isEmpty &&
            view.doneTasks.isNotEmpty) ...[
          const SizedBox(height: GlowSpacing.lg),
          OutlinedButton.icon(
            icon: const Icon(Icons.self_improvement),
            label: const Text('เริ่มท่าก่อนนอน'),
            onPressed: () async {
              Navigator.of(context).pop();
              await widget.onStartRoutine!();
            },
          ),
        ],
      ],
    );
  }

  Widget _buildLine(BuildContext context, DateTime time, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: GlowSpacing.sm),
      child: Text(
        '${formatClock(time)}  $label',
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget _buildBlock(
    BuildContext context,
    EveningView view,
    EveningBlock block,
  ) {
    final theme = Theme.of(context);
    final isTask = block.kind == BlockKind.task;
    final carried = isTask && view.taskById(block.taskId!)?.carried == true;
    return Container(
      margin: const EdgeInsets.only(bottom: GlowSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: GlowSpacing.md),
      constraints: const BoxConstraints(minHeight: 48),
      decoration: BoxDecoration(
        color: isTask
            ? theme.colorScheme.primary.withValues(alpha: 0.16)
            : null,
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(GlowRadius.button),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formatClock(block.start)}–${formatClock(block.end)}'
                  '${carried ? ' · เลื่อนมา' : ''}',
                  style: theme.textTheme.labelSmall,
                ),
                Text(block.title, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
          if (isTask)
            TextButton(
              onPressed: () async {
                await _repo.finishBlock(
                  block.taskId!,
                  block.minutes,
                  ref.read(clockProvider)(),
                );
                _reload();
              },
              child: const Text('เสร็จ'),
            ),
        ],
      ),
    );
  }

  /// Work that doesn't fit. The choices never include going to bed later.
  Widget _buildOverflow(BuildContext context, EveningView view) {
    final textTheme = Theme.of(context).textTheme;
    final tomorrow = DateTime(
      view.eveningDate.year,
      view.eveningDate.month,
      view.eveningDate.day + 1,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: GlowSpacing.sm),
        WarningBar(
          severity: WarningBarSeverity.yellow,
          message: 'เย็นนี้งานเกินไป ${view.plan.overflowMinutes} นาที',
        ),
        for (final entry in view.plan.overflow.entries)
          if (view.taskById(entry.key) case final task?) ...[
            Text(
              '${task.title} · เกิน ${entry.value} นาที',
              style: textTheme.bodyLarge,
            ),
            if (task.dueDate != null && !task.dueDate!.isAfter(tomorrow))
              Text(
                'งานนี้ส่งพรุ่งนี้แต่เย็นนี้เวลาไม่พอ ลองแบ่งทำช่วงพัก'
                'พรุ่งนี้ หรือคุยกับครูเรื่องขอเลื่อนส่ง',
                style: textTheme.bodyMedium,
              ),
            Wrap(
              children: [
                TextButton(
                  onPressed: () async {
                    await _repo.postpone(task.id);
                    _reload();
                  },
                  child: const Text('เลื่อนไปพรุ่งนี้'),
                ),
                TextButton(
                  onPressed: () async {
                    await showTaskForm(
                      context,
                      planDate: view.eveningDate,
                      existing: task,
                    );
                    _reload();
                  },
                  child: const Text('ลดเวลา'),
                ),
                TextButton(
                  onPressed: () async {
                    await _repo.removeTask(task.id);
                    _reload();
                  },
                  child: const Text('เอาออก'),
                ),
              ],
            ),
          ],
      ],
    );
  }

  Widget _buildTaskRow(BuildContext context, EveningView view, int index) {
    final EveningTask task = view.tasks[index];
    final due = task.dueDate;
    Future<void> move(int delta) async {
      await _repo.move(view.tasks, index, delta);
      _reload();
    }

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(task.title),
      subtitle: Text(
        [
          '${task.minutes - task.doneMinutes} นาที',
          taskKindLabels[EveningTaskKind.values[task.kind]]!,
          if (due != null) 'ส่ง ${due.day}/${due.month}',
          if (task.carried) 'เลื่อนมา',
        ].join(' · '),
      ),
      onTap: () => _taskMenu(context, view, task),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_upward),
            tooltip: 'เลื่อน ${task.title} ขึ้น',
            onPressed: index == 0 ? null : () => move(-1),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            tooltip: 'เลื่อน ${task.title} ลง',
            onPressed: index == view.tasks.length - 1 ? null : () => move(1),
          ),
        ],
      ),
    );
  }

  Future<void> _taskMenu(
    BuildContext context,
    EveningView view,
    EveningTask task,
  ) async {
    final choice = await showGlowBottomSheet<String>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(task.title, style: Theme.of(context).textTheme.titleLarge),
          for (final (id, label) in const [
            ('edit', 'แก้'),
            ('postpone', 'เลื่อนไปพรุ่งนี้'),
            ('remove', 'เอาออก'),
          ])
            ListTile(
              title: Text(label),
              onTap: () => Navigator.of(context).pop(id),
            ),
        ],
      ),
    );
    if (choice == null || !context.mounted) return;
    switch (choice) {
      case 'edit':
        await showTaskForm(context, planDate: view.eveningDate, existing: task);
      case 'postpone':
        await _repo.postpone(task.id);
      case 'remove':
        await _repo.removeTask(task.id);
    }
    _reload();
  }
}
