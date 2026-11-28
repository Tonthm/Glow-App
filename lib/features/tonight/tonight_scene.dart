import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_mascot.dart';

/// The supplied village artwork follows appearance; the pose follows the
/// recorded bedtime press, never a claim that sleep has been measured.
class TonightScene extends StatelessWidget {
  final bool inBed;
  final Widget header;

  const TonightScene({super.key, required this.inBed, required this.header});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appearance = theme.brightness == Brightness.dark ? 'dark' : 'light';
    return LayoutBuilder(
      builder: (context, constraints) {
        final mascotSize = (constraints.maxWidth * .44).clamp(128.0, 192.0);
        return Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/scenes/tonight_$appearance.webp',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                excludeFromSemantics: true,
              ),
            ),
            Column(
              children: [
                // Leave the moon clear while keeping 48dp action targets.
                Padding(
                  padding: EdgeInsets.only(right: constraints.maxWidth * .2),
                  child: header,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlowSpacing.lg,
                  ),
                  child: Column(
                    children: [
                      Text(
                        inBed ? 'ฝันดีนะ พักให้เต็มที่' : 'คืนนี้ พักไปด้วยกัน',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: GlowSpacing.xs),
                      Text(
                        inBed
                            ? 'บอกว่าเข้านอนแล้ว · แล้วเจอกันตอนเช้า'
                            : 'วางวันนี้ลง แล้วค่อยเริ่มใหม่พรุ่งนี้',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: .85,
                  child: GlowMascot(
                    pose: inBed
                        ? GlowMascotPose.sleeping
                        : GlowMascotPose.ready,
                    size: mascotSize,
                  ),
                ),
                const SizedBox(height: GlowSpacing.sm),
              ],
            ),
          ],
        );
      },
    );
  }
}
