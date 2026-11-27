import 'package:material_ui/material_ui.dart';

/// The app's logo with rounded corners. The picture itself is a full square
/// (tool/make_icons.dart).
class GlowLogo extends StatelessWidget {
  final double size;

  const GlowLogo({super.key, this.size = 96});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.22),
        child: Image.asset(
          'assets/logo_square.png',
          width: size,
          height: size,
          semanticLabel: 'Glow',
        ),
      ),
    );
  }
}
