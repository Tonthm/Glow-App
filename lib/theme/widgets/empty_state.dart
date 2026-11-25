import 'package:material_ui/material_ui.dart';

import '../tokens.dart';

/// Shown on any screen with nothing in it yet, per THEME.md: an icon, a
/// short Thai message saying what to do next, and an optional action.
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final textSecondary = Theme.of(context).textTheme.bodyMedium;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(GlowSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: textSecondary?.color),
            const SizedBox(height: GlowSpacing.lg),
            Text(message, style: textSecondary, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: GlowSpacing.lg),
              TextButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
