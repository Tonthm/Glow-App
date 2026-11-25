import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/fire.dart';
import '../../providers.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';

/// Simple fire-level readout for the Tonight screen (PROMPTS.md phase 2
/// step 7: "ใช้รูปทรงง่าย ๆ ไปก่อน"). A proper bedside-lamp character comes
/// later with the room screen (section 7: "ไฟแสดงเป็นโคมไฟหัวเตียงของตัว
/// ละคร").
class FireBadge extends ConsumerWidget {
  const FireBadge({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fireAsync = ref.watch(fireStateStreamProvider);
    return fireAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => const SizedBox.shrink(),
      data: (fire) {
        final lampOpacity = 0.3 + 0.7 * (fire.level / maxFireLevel);
        return Row(
          children: [
            Icon(
              Icons.local_fire_department,
              color: context.glowColors.lampGlow.withValues(alpha: lampOpacity),
              size: 28,
            ),
            const SizedBox(width: GlowSpacing.sm),
            Text(
              '${fireLevelNames[fire.level]} · ${fire.points} แต้ม',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (fire.shields > 0) ...[
              const SizedBox(width: GlowSpacing.sm),
              Icon(Icons.shield_outlined, size: 18, color: Theme.of(context).textTheme.bodyMedium?.color),
              const SizedBox(width: GlowSpacing.xs),
              Text('${fire.shields}', style: Theme.of(context).textTheme.bodyMedium),
            ],
          ],
        );
      },
    );
  }
}
