import 'package:material_ui/material_ui.dart';

import '../tokens.dart';
import 'glow_card.dart';

/// A card that is one line until tapped, for everything a screen doesn't
/// need to show up front.
class GlowFold extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? summary;
  final Widget child;

  const GlowFold({
    super.key,
    required this.icon,
    required this.title,
    this.summary,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GlowCard(
      padding: EdgeInsets.zero,
      child: ExpansionTile(
        // The card already draws the outline.
        shape: const Border(),
        collapsedShape: const Border(),
        // What was picked inside stays when it is folded again.
        maintainState: true,
        leading: Icon(icon),
        title: Text(title, style: textTheme.titleMedium),
        subtitle: summary == null
            ? null
            : Text(
                summary!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium,
              ),
        childrenPadding: const EdgeInsets.fromLTRB(
          GlowSpacing.lg,
          0,
          GlowSpacing.lg,
          GlowSpacing.lg,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.stretch,
        children: [child],
      ),
    );
  }
}
