import 'dart:async';

import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/quests.dart';
import '../../core/routine_config.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/app_theme.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'pose_illustration.dart';

/// The stretching routine, one pose at a time on a dark screen (CLAUDE.md
/// section 13).
class RoutineScreen extends ConsumerStatefulWidget {
  final DateTime wakeDate;
  final List<Pose> poses;
  final QuestMode mode;

  /// Null when "เข้านอนแล้ว" can't be pressed right now.
  final Future<void> Function()? onInBed;

  const RoutineScreen({
    super.key,
    required this.wakeDate,
    required this.poses,
    required this.mode,
    this.onInBed,
  });

  @override
  ConsumerState<RoutineScreen> createState() => _RoutineScreenState();
}

class _RoutineScreenState extends ConsumerState<RoutineScreen> {
  late final _screen = ref.read(screenServiceProvider);
  final _skipped = <String>{};
  int _index = 0;
  late int _secondsLeft = widget.poses.first.seconds;
  Timer? _timer;

  /// Coins earned, once the whole set is over.
  int? _earned;

  Pose get _pose => widget.poses[_index];

  @override
  void initState() {
    super.initState();
    _screen.keepOn(true);
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    _screen.keepOn(false);
    super.dispose();
  }

  void _tick() {
    if (!mounted) return;
    if (_secondsLeft <= 1) {
      HapticFeedback.mediumImpact();
      _advance();
      return;
    }
    setState(() => _secondsLeft--);
    if (_pose.bothSides && _secondsLeft == _pose.seconds ~/ 2) {
      HapticFeedback.mediumImpact();
    }
  }

  void _advance({bool skip = false}) {
    if (_earned != null) return;
    if (skip) _skipped.add(_pose.id);
    if (_index + 1 < widget.poses.length) {
      setState(() {
        _index++;
        _secondsLeft = _pose.seconds;
      });
    } else {
      _finish();
    }
  }

  Future<void> _finish() async {
    _timer?.cancel();
    final earned = await ref
        .read(routineRepositoryProvider)
        .finishRoutine(
          wakeDate: widget.wakeDate,
          poses: widget.poses,
          skippedPoseIds: _skipped,
          mode: widget.mode,
        );
    _screen.keepOn(false);
    if (mounted) setState(() => _earned = earned);
  }

  @override
  Widget build(BuildContext context) {
    // Always dark: it is used with the lights off.
    return Theme(
      data: GlowAppTheme.dark(),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('ท่าก่อนนอน')),
          body: SafeArea(
            child: DefaultTextStyle(
              style: Theme.of(context).textTheme.bodyLarge!,
              child: _earned == null
                  ? _buildPose(context)
                  : _buildDone(context, _earned!),
            ),
          ),
        ),
      ),
    );
  }

  Widget _safetyNote(BuildContext context) => Text(
    routineSafetyNote,
    textAlign: TextAlign.center,
    style: Theme.of(context).textTheme.bodyMedium,
  );

  Widget _buildPose(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final pose = _pose;
    final secondSide = pose.bothSides && _secondsLeft <= pose.seconds ~/ 2;
    // Read the clock offset so demo-only controls appear only in a demo.
    final inDemo =
        kDebugMode && ref.watch(clockOffsetProvider) != Duration.zero;

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(GlowSpacing.pageMargin),
            children: [
              Text(
                'ท่าที่ ${_index + 1} จาก ${widget.poses.length}',
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
              Text(
                pose.name,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge,
              ),
              const SizedBox(height: GlowSpacing.md),
              Center(
                child: SizedBox(
                  width: 168,
                  height: 168,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox.expand(
                        child: CircularProgressIndicator(
                          value: _secondsLeft / pose.seconds,
                          strokeWidth: 6,
                          backgroundColor: Theme.of(context).dividerColor,
                        ),
                      ),
                      PoseIllustration(pose: pose),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: GlowSpacing.sm),
              Text(
                '$_secondsLeft วินาที',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge,
              ),
              if (pose.bothSides)
                Text(
                  secondSide ? 'สลับข้าง: ทำอีกข้าง' : 'ข้างแรก',
                  textAlign: TextAlign.center,
                  style: textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              const SizedBox(height: GlowSpacing.md),
              for (final step in pose.steps)
                Padding(
                  padding: const EdgeInsets.only(bottom: GlowSpacing.sm),
                  child: Text(step, style: textTheme.titleLarge),
                ),
              const SizedBox(height: GlowSpacing.md),
              _safetyNote(context),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () => _advance(skip: true),
              child: const Text('ข้าม'),
            ),
            if (inDemo)
              TextButton(
                onPressed: _advance,
                child: const Text('เดโม: จบท่านี้'),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildDone(BuildContext context, int earned) {
    final textTheme = Theme.of(context).textTheme;
    final onInBed = widget.onInBed;
    return Padding(
      padding: const EdgeInsets.all(GlowSpacing.pageMargin),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'จบชุดแล้ว',
            textAlign: TextAlign.center,
            style: textTheme.headlineLarge,
          ),
          if (earned > 0)
            Text(
              '+$earned เหรียญ',
              textAlign: TextAlign.center,
              style: textTheme.titleLarge,
            ),
          const SizedBox(height: GlowSpacing.lg),
          _safetyNote(context),
          const SizedBox(height: GlowSpacing.xl),
          if (onInBed != null)
            GlowPrimaryButton(
              label: 'เข้านอนแล้ว',
              onPressed: () async {
                await onInBed();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('กลับหน้าคืนนี้'),
          ),
        ],
      ),
    );
  }
}
