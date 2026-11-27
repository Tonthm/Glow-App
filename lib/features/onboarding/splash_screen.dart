import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_logo.dart';

/// Shown only while the saved settings are opening; never adds a launch delay.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
    body: SafeArea(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const GlowLogo(size: 144),
            const SizedBox(height: GlowSpacing.lg),
            Text(
              'Glow',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 56,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: GlowSpacing.sm),
            Text(
              'นอนดีขึ้น เริ่มจากคืนนี้',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 64),
            Semantics(
              label: 'กำลังเปิด Glow',
              child: Text(
                '• · ·',
                style: TextStyle(
                  letterSpacing: 6,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
