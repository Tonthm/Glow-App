import 'package:material_ui/material_ui.dart';

import 'guide_screen.dart';

/// The "?" that opens the guide.
class GuideButton extends StatelessWidget {
  const GuideButton({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.help_outline),
    tooltip: 'คู่มือ',
    onPressed: () =>
        Navigator.of(context)
            .push(MaterialPageRoute<void>(builder: (_) => const GuideScreen())),
  );
}
