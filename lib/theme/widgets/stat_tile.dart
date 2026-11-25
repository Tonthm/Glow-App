import 'package:material_ui/material_ui.dart';

import '../tokens.dart';

/// A big-number-over-small-caption stat, per THEME.md's "ตัวเลขหนาด้านบน
/// คำอธิบายเล็กด้านล่าง" pattern (ห้อง's level/coins/streak row, สถิติ's
/// summary row).
class StatTile extends StatelessWidget {
  final String value;
  final String label;

  const StatTile({super.key, required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            fontFamily: 'NotoSansThai',
          ),
        ),
        const SizedBox(height: GlowSpacing.xs),
        Text(label, style: textTheme.labelSmall, textAlign: TextAlign.center),
      ],
    );
  }
}
