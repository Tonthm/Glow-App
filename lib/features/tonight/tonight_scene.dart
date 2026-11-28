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
        final width = constraints.maxWidth;
        final narrow = width < 350;
        final mascotSize = width * (narrow ? .41 : .44);
        final largeText = MediaQuery.textScalerOf(context).scale(18) > 18;
        final sceneHeader = Padding(
          padding: EdgeInsets.only(right: width * .2),
          child: header,
        );
        final copy = Padding(
          padding: const EdgeInsets.symmetric(horizontal: GlowSpacing.lg),
          child: Column(
            children: [
              Text(
                inBed ? 'ฝันดีนะ พักให้เต็มที่' : 'คืนนี้ พักไปด้วยกัน',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: narrow ? 16 : 18,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                inBed
                    ? 'บอกว่าเข้านอนแล้ว · แล้วเจอกันตอนเช้า'
                    : 'วางวันนี้ลง แล้วค่อยเริ่มใหม่พรุ่งนี้',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: narrow ? 11 : 12,
                  color: theme.colorScheme.onSurface.withValues(alpha: .85),
                ),
              ),
            ],
          ),
        );
        final mascot = Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned(
              bottom: 0,
              child: Container(
                width: width * .29,
                height: 10,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(GlowRadius.pill),
                  color: theme.shadowColor.withValues(alpha: .10),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: .15),
                      blurRadius: 6,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
            GlowMascot(
              pose: inBed ? GlowMascotPose.sleeping : GlowMascotPose.ready,
              size: mascotSize,
            ),
          ],
        );
        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Paint 10dp below the layout edge, underneath the next card.
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: -10,
              child: Image.asset(
                'assets/scenes/tonight_$appearance.webp',
                fit: BoxFit.cover,
                alignment: Alignment.bottomCenter,
                excludeFromSemantics: true,
              ),
            ),
            // Scaled text flows naturally instead of colliding with the mascot.
            if (largeText)
              Column(children: [sceneHeader, copy, mascot])
            else ...[
              SizedBox(width: width, height: width * 2 / 3 - 10),
              sceneHeader,
              Positioned(top: narrow ? 52 : 56, left: 0, right: 0, child: copy),
              Positioned(bottom: -2, left: 0, right: 0, child: mascot),
            ],
          ],
        );
      },
    );
  }
}
