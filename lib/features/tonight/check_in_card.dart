import 'package:material_ui/material_ui.dart';
import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/bed_press.dart';
import '../../core/check_in.dart';
import '../../data/check_in_repository.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/widgets/arrow_span.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../services/app_clock.dart';

/// Morning check-in card shown in place of the main section (THEME.md
/// "ตอนเช้า การ์ดเช็กอินขึ้นแทนส่วนหลัก" / CLAUDE.md section 6).
class CheckInCard extends ConsumerStatefulWidget {
  final PendingCheckIn pending;
  final void Function(
    CheckInRecordResult result,
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
  late DateTime _lightsOffAt = widget.pending.defaultLightsOff;
  late LightsOffSource _source = widget.pending.defaultSource;

  /// A wake time the user picked. While null, the wake time is the moment
  /// "ตื่นแล้ว" is pressed, if that can still tell.
  DateTime? _pickedWake;
  bool _submitting = false;

  WakeTimeAnswer _answerAt(DateTime now) => wakeTimeAnswer(
    wakeDate: widget.pending.wakeDate,
    plannedWakeTime: widget.pending.plannedWakeTime,
    now: now,
  );

  Future<void> _editTimes() async {
    final now = ref.read(clockProvider)();
    final asked = _pickedWake == null ? _answerAt(now) : null;
    final result = await showGlowBottomSheet<(DateTime, DateTime)>(
      context: context,
      builder: (context) => _EditTimesSheet(
        wakeDate: widget.pending.wakeDate,
        initialLightsOff: _lightsOffAt,
        // The wheel has to start somewhere; nothing is saved from it until
        // the user saves the sheet and then confirms.
        initialWake:
            _pickedWake ??
            (asked == WakeTimeAnswer.pressTime
                ? toMinute(now)
                : widget.pending.plannedWakeTime),
      ),
    );
    if (result != null) {
      setState(() {
        if (result.$1 != _lightsOffAt) _source = LightsOffSource.edited;
        _lightsOffAt = result.$1;
        _pickedWake = result.$2;
      });
    }
  }

  /// "ตื่นแล้ว". If the card has been open so long that the press no longer
  /// tells the wake time, it asks instead of saving.
  Future<void> _confirm() async {
    final now = ref.read(clockProvider)();
    final picked = _pickedWake;
    if (picked == null && _answerAt(now) != WakeTimeAnswer.pressTime) {
      setState(() {});
      return;
    }
    await _submit(picked ?? toMinute(now), now);
  }

  /// "เพิ่งตื่นตอนนี้", said by the user after a late opening.
  Future<void> _wokeJustNow() async {
    final now = ref.read(clockProvider)();
    // Past midnight it is no longer "now"; the card then only lets them pick.
    if (_answerAt(now) == WakeTimeAnswer.askNextDay) {
      setState(() {});
      return;
    }
    await _submit(toMinute(now), now);
  }

  Future<void> _submit(DateTime wakeAt, DateTime now) async {
    setState(() => _submitting = true);
    try {
      final fireRepo = ref.read(fireRepositoryProvider);
      final checkInRepo = ref.read(checkInRepositoryProvider);

      final fireBefore = await fireRepo.get();
      final result = await checkInRepo.recordCheckIn(
        wakeDate: widget.pending.wakeDate,
        lightsOffAt: _lightsOffAt,
        actualWakeAt: wakeAt,
        now: now,
        source: _source,
      );
      final fireAfter = await fireRepo.get();
      await ref
          .read(notificationServiceProvider)
          .cancelCheckInNotification(widget.pending.wakeDate);

      if (!mounted) return;
      widget.onSubmitted(result, fireBefore, fireAfter);
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
    final fallAsleepMinutes =
        ref.watch(settingsStreamProvider).value?.fallAsleepMinutes ?? 15;
    final now = ref.watch(clockProvider)();
    final picked = _pickedWake;
    final answer = _answerAt(now);
    final pressTells = picked == null && answer == WakeTimeAnswer.pressTime;
    // Null while the user still has to say when they woke.
    final wakeAt = picked ?? (pressTells ? toMinute(now) : null);
    final duration = wakeAt == null
        ? null
        : actualSleepDuration(
            lightsOffAt: _lightsOffAt,
            wakeAt: wakeAt,
            fallAsleepMinutes: fallAsleepMinutes,
          );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('เมื่อคืน', style: textTheme.bodyMedium),
        const SizedBox(height: GlowSpacing.xs),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '${_formatTime(_lightsOffAt)} '),
              arrowSpan(textTheme.displayLarge),
              TextSpan(
                text: wakeAt == null ? ' --:--' : ' ${_formatTime(wakeAt)}',
              ),
            ],
          ),
          style: textTheme.displayLarge,
        ),
        const SizedBox(height: GlowSpacing.xs),
        if (duration != null)
          Text(
            'นอน ${duration.inHours} ชม. ${duration.inMinutes % 60} นาที',
            style: textTheme.bodyMedium,
          )
        else
          Text('ตื่นกี่โมง', style: textTheme.titleLarge),
        if (pressTells)
          Text(
            'เวลาตื่นคือตอนที่กดปุ่ม ถ้าไม่ตรงให้แก้เวลา',
            style: textTheme.labelSmall,
          ),
        if (!widget.pending.countsAsPressed)
          Text('เมื่อคืนไม่ได้กดเข้านอน', style: textTheme.labelSmall),
        const SizedBox(height: GlowSpacing.xl),
        if (wakeAt != null) ...[
          GlowPrimaryButton(
            label: 'ตื่นแล้ว · ใช่ ตามนี้',
            onPressed: _submitting ? null : _confirm,
          ),
          const SizedBox(height: GlowSpacing.sm),
          TextButton(
            onPressed: _submitting ? null : _editTimes,
            child: const Text('แก้เวลา'),
          ),
        ] else ...[
          GlowPrimaryButton(
            label: 'เลือกเวลาตื่น',
            onPressed: _submitting ? null : _editTimes,
          ),
          if (answer == WakeTimeAnswer.askSameDay) ...[
            const SizedBox(height: GlowSpacing.sm),
            TextButton(
              onPressed: _submitting ? null : _wokeJustNow,
              child: const Text('เพิ่งตื่นตอนนี้'),
            ),
          ],
        ],
      ],
    );
  }
}

String _formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

class _EditTimesSheet extends StatefulWidget {
  final DateTime wakeDate;
  final DateTime initialLightsOff;
  final DateTime initialWake;

  const _EditTimesSheet({
    required this.wakeDate,
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
    // The wheels only pick a clock time; the date is worked out from it.
    final times = resolveCheckInTimes(
      wakeDate: widget.wakeDate,
      lightsOffHour: _lightsOff.hour,
      lightsOffMinute: _lightsOff.minute,
      wakeHour: _wake.hour,
      wakeMinute: _wake.minute,
    );
    final isValid = times.wakeAt.isAfter(times.lightsOffAt);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('ปิดไฟ', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: 130,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: _lightsOff,
            onDateTimeChanged: (v) => setState(() => _lightsOff = v),
          ),
        ),
        const SizedBox(height: GlowSpacing.md),
        Text('ตื่น', style: Theme.of(context).textTheme.bodyMedium),
        SizedBox(
          height: 130,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.time,
            use24hFormat: true,
            initialDateTime: _wake,
            onDateTimeChanged: (v) => setState(() => _wake = v),
          ),
        ),
        const SizedBox(height: GlowSpacing.lg),
        if (!isValid)
          const Padding(
            padding: EdgeInsets.only(bottom: GlowSpacing.sm),
            child: Text('เวลาตื่นต้องอยู่หลังเวลาปิดไฟ'),
          ),
        GlowPrimaryButton(
          label: 'บันทึก',
          onPressed: isValid
              ? () =>
                    Navigator.of(context).pop((times.lightsOffAt, times.wakeAt))
              : null,
        ),
      ],
    );
  }
}
