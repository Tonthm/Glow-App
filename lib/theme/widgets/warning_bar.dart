import 'package:material_ui/material_ui.dart';

import '../glow_colors.dart';
import '../tokens.dart';
import 'glow_card.dart';

enum WarningBarSeverity { yellow, red }

/// Thin, rounded, icon-led bar for the busy-schedule / red-night warnings
/// (CLAUDE.md section 4). Never a loud solid fill — per THEME.md "ไม่ใช้พื้น
/// สีจัด" — just a tinted background and a colored icon.
class WarningBar extends StatelessWidget {
  final WarningBarSeverity severity;
  final String message;
  final VoidCallback? onTap;

  const WarningBar({
    super.key,
    required this.severity,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isRed = severity == WarningBarSeverity.red;
    return GlowCard(
      onTap: onTap,
      pastel: isRed ? GlowPastel.pink : GlowPastel.butter,
      padding: const EdgeInsets.symmetric(
        horizontal: GlowSpacing.lg,
        vertical: GlowSpacing.md,
      ),
      child: Row(
        children: [
          // The icon shape tells the two apart without relying on color.
          Icon(isRed ? Icons.error_outline : Icons.schedule_outlined, size: 22),
          const SizedBox(width: GlowSpacing.sm),
          Expanded(
            child: Text(message, style: Theme.of(context).textTheme.bodyLarge),
          ),
        ],
      ),
    );
  }
}
