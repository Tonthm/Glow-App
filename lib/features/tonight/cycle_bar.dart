import 'package:material_ui/material_ui.dart';

import '../../core/sleep_cycles.dart';
import '../../data/night_planning_repository.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';

/// Tonight from bedtime to wake as estimated sleep cycles (CLAUDE.md section
/// 20). Every cycle looks the same: the app knows nothing about which part of
/// a night is which kind of sleep.
class CycleBar extends StatelessWidget {
  final NightCycles cycles;

  const CycleBar({super.key, required this.cycles});

  static const _height = 14.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final count = cycleCountLabel(
      cyclesInSleep(cycles.sleepMinutes, cycles.cycleMinutes),
    );
    final reason = cycleReason(
      shiftMinutes: cycles.shiftMinutes,
      sleepMinutes: cycles.sleepMinutes,
      cycleMinutes: cycles.cycleMinutes,
    );
    final parts = cycleBarParts(
      fallAsleepMinutes: cycles.fallAsleepMinutes,
      sleepMinutes: cycles.sleepMinutes,
      cycleMinutes: cycles.cycleMinutes,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ExcludeSemantics(
          child: SizedBox(
            height: _height,
            child: Row(
              // An empty box has no height of its own.
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final (i, part) in parts.indexed) ...[
                  if (i > 0) const SizedBox(width: 3),
                  Expanded(
                    flex: part.minutes,
                    child: DecoratedBox(
                      key: ValueKey(
                        part.fallingAsleep ? 'fall-asleep' : 'cycle-$i',
                      ),
                      decoration: BoxDecoration(
                        color: part.fallingAsleep
                            ? theme.dividerColor
                            : context.glowColors.pastel(GlowPastel.lilac),
                        borderRadius: BorderRadius.circular(GlowRadius.cell),
                        border: Border.all(
                          color: theme.colorScheme.primary.withValues(
                            alpha: 0.35,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: GlowSpacing.xs),
        Text(
          'ประมาณ $count รอบ'
          '${cycles.fallAsleepMinutes > 0 ? ' · เผื่อหลับ ${cycles.fallAsleepMinutes} นาที' : ''}',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
        Text(
          cycleDisclaimer,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelSmall,
        ),
        if (reason != null) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text(
            reason,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
