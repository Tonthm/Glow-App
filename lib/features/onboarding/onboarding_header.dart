import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';

class OnboardingHeader extends StatelessWidget {
  final int step;

  const OnboardingHeader({super.key, required this.step});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text('0$step / 02', style: Theme.of(context).textTheme.labelSmall),
      const SizedBox(height: GlowSpacing.md),
      ClipRRect(
        borderRadius: BorderRadius.circular(GlowRadius.pill),
        child: LinearProgressIndicator(value: step / 2, minHeight: 4),
      ),
      const SizedBox(height: GlowSpacing.xl),
    ],
  );
}
