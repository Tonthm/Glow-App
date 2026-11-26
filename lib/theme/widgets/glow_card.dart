import 'package:material_ui/material_ui.dart';

import '../glow_colors.dart';
import '../tokens.dart';

/// The app's card: rounded, with a thin ink outline and an optional pastel
/// fill. Use it instead of drawing a box in a screen.
class GlowCard extends StatelessWidget {
  final Widget child;
  final GlowPastel? pastel;
  final EdgeInsetsGeometry padding;
  final VoidCallback? onTap;

  const GlowCard({
    super.key,
    required this.child,
    this.pastel,
    this.padding = const EdgeInsets.all(GlowSpacing.lg),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: pastel == null
          ? theme.colorScheme.surface
          : context.glowColors.pastel(pastel!),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(GlowRadius.card),
        side: BorderSide(
          color: theme.colorScheme.outline,
          width: GlowStroke.outline,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
