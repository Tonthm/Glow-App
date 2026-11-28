import 'package:material_ui/material_ui.dart';

enum GlowMascotPose { ready, sleeping, awake }

/// Each pose shares a canvas and baseline so changing pose keeps its place.
class GlowMascot extends StatelessWidget {
  final GlowMascotPose pose;
  final double size;

  const GlowMascot({super.key, required this.pose, this.size = 128});

  @override
  Widget build(BuildContext context) => Center(
    child: Image.asset(
      'assets/mascots/${pose.name}.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    ),
  );
}
