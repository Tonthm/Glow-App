import 'package:material_ui/material_ui.dart';

import '../tokens.dart';

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
    final color = severity == WarningBarSeverity.red
        ? const Color(0xFFED4956)
        : const Color(0xFFF2C94C);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(GlowRadius.card),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: GlowSpacing.lg,
          vertical: GlowSpacing.md,
        ),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(GlowRadius.card),
        ),
        child: Row(
          children: [
            Icon(
              severity == WarningBarSeverity.red
                  ? Icons.error_outline
                  : Icons.schedule_outlined,
              color: color,
              size: 22,
            ),
            const SizedBox(width: GlowSpacing.sm),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
