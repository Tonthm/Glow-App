import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import 'guide_entries.dart';

export 'guide_entries.dart' show GuideTip;

/// The small (i) beside a heading.
class InfoButton extends StatelessWidget {
  final GuideTip tip;

  const InfoButton(this.tip, {super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.info_outline, size: 20),
      tooltip: 'อธิบาย: ${tip.title}',
      onPressed: () => showGlowBottomSheet<void>(
        context: context,
        builder: (context) {
          final textTheme = Theme.of(context).textTheme;
          return SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(tip.title, style: textTheme.titleLarge),
                for (final line in tip.body.split('\n')) ...[
                  const SizedBox(height: GlowSpacing.sm),
                  Text(line, style: textTheme.bodyLarge),
                ],
                const SizedBox(height: GlowSpacing.md),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('เข้าใจแล้ว'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
