import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';

/// The small label every AI result carries (CLAUDE.md section 16).
class AiBadge extends StatelessWidget {
  const AiBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.auto_awesome_outlined, size: 14),
        const SizedBox(width: GlowSpacing.xs),
        Text('AI ช่วยแนะนำ', style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
