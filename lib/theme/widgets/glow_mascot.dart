import 'package:material_ui/material_ui.dart';

enum GlowMascotPose { ready, sleeping, awake }

/// Each pose shares a canvas and baseline so changing pose keeps its place.
class GlowMascot extends StatelessWidget {
  final GlowMascotPose pose;

  const GlowMascot({super.key, required this.pose});

  @override
  Widget build(BuildContext context) => Center(
    child: Image.asset(
      'assets/mascots/${pose.name}.png',
      width: 128,
      height: 128,
      fit: BoxFit.contain,
      excludeFromSemantics: true,
    ),
  );
}
