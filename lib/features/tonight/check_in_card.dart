import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/check_in.dart';
import '../../data/check_in_repository.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// Morning check-in card shown in place of the main section (THEME.md
/// "ตอนเช้า การ์ดเช็กอินขึ้นแทนส่วนหลัก" / CLAUDE.md section 6).
class CheckInCard extends ConsumerStatefulWidget {
  final PendingCheckIn pending;
  final void Function(
    CheckInOutcome outcome,
    FireStateRow fireBefore,
    FireStateRow fireAfter,
  )
  onSubmitted;

  const CheckInCard({
    super.key,
    required this.pending,
    required this.onSubmitted,
  });

  @override
  ConsumerState<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends ConsumerState<CheckInCard> {
  late DateTime _lightsOffAt = widget.pending.plannedBedtime;
  late DateTime _wakeAt = widget.pending.plannedWakeTime;
  bool _submitting = false;

  Future<void> _editTimes() async {
    final result = await showGlowBottomSheet<(DateTime, DateTime)>(
      context: context,
      builder: (context) => _EditTimesSheet(
        initialLightsOff: _lightsOffAt,
        initialWake: _wakeAt,
      ),
    );
    if (result != null) {
      setState(() {
        _lightsOffAt = result.$1;
        _wakeAt = result.$2;
      });
    }
  }

  Future<void> _confirm() async {
    setState(() => _submitting = true);
    try {
      final fireRepo = ref.read(fireRepositoryProvider);
      final checkInRepo = ref.read(checkInRepositoryProvider);
      final now = DateTime.now();

      final fireBefore = await fireRepo.get();
      final outcome = await checkInRepo.recordCheckIn(
        wakeDate: widget.pending.wakeDate,
        lightsOffAt: _lightsOffAt,
        actualWakeAt: _wakeAt,
        now: now,
      );
      final fireAfter = await fireRepo.get();
      await ref
          .read(notificationServiceProvider)
          .cancelCheckInNotification(widget.pending.wakeDate);

      if (!mounted) return;
      widget.onSubmitted(outcome, fireBefore, fireAfter);
    } catch (e) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('บันทึกไม่สำเร็จ ลองใหม่อีกครั้ง: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final duration = _wakeAt.difference(_lightsOffAt);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('เมื่อคืน', style: textTheme.bodyMedium),
        const SizedBox(height: GlowSpacing.xs),
        Text(
          '${_formatTime(_lightsOffAt)} → ${_formatTime(_wakeAt)}',
          style: textTheme.displayLarge,
        ),
        const SizedBox(height: GlowSpacing.xs),
        Text(
          '${duration.inHours} ชม. ${duration.inMinutes % 60} นาที',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: GlowSpacing.xl),
        GlowPrimaryButton(
          label: 'ใช่ ตามนี้',
          onPressed: _submitting ? null : _confirm,
        ),
        const SizedBox(height: GlowSpacing.sm),
        TextButton(
          onPressed: _submitting ? null : _editTimes,
          child: const Text('แก้เวลา'),
        ),
      ],
    );
  }
}

String _formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

class _EditTimesSheet extends StatefulWidget {
  final DateTime initialLightsOff;
  final DateTime initialWake;

  const _EditTimesSheet({
    required this.initialLightsOff,
    required this.initialWake,
  });

  @override
  State<_EditTimesSheet> createState() => _EditTimesSheetState();
}

class _EditTimesSheetState extends State<_EditTimesSheet> {
  late DateTime _lightsOff = widget.initialLightsOff;
  late DateTime _wake = widget.initialWake;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('ปิดไฟ', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: 160,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: _lightsOff,
            onDateTimeChanged: (v) => setState(() => _lightsOff = v),
          ),
        ),
        const SizedBox(height: GlowSpacing.md),
        Text('ตื่น', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: 160,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            initialDateTime: _wake,
            onDateTimeChanged: (v) => setState(() => _wake = v),
          ),
        ),
        const SizedBox(height: GlowSpacing.lg),
        GlowPrimaryButton(
          label: 'บันทึก',
          onPressed: () => Navigator.of(context).pop((_lightsOff, _wake)),
        ),
      ],
    );
  }
}
