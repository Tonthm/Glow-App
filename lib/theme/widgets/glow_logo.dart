import 'package:material_ui/material_ui.dart';

/// The transparent Glow mascot supplied with the Figma design.
class GlowLogo extends StatelessWidget {
  final double size;

  const GlowLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'assets/mascot.png',
        width: size,
        height: size,
        semanticLabel: 'Glow',
      ),
    );
  }
}
