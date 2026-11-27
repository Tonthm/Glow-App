import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import 'guide_entries.dart';

/// "รู้จักการนอน": three short cards and where they come from.
class LearnSleepScreen extends StatelessWidget {
  const LearnSleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('รู้จักการนอน')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          for (final (icon, title, lines) in sleepFacts) ...[
            GlowCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(icon),
                      const SizedBox(width: GlowSpacing.md),
                      Expanded(
                        child: Text(title, style: textTheme.titleMedium),
                      ),
                    ],
                  ),
                  const SizedBox(height: GlowSpacing.sm),
                  for (final line in lines)
                    Text(line, style: textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: GlowSpacing.md),
          ],
          const SizedBox(height: GlowSpacing.md),
          Text('ที่มา: $sleepFactsSource', style: textTheme.labelSmall),
          const SizedBox(height: GlowSpacing.sm),
          Text(sleepFactsNotice, style: textTheme.labelSmall),
        ],
      ),
    );
  }
}
