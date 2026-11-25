import 'package:material_ui/material_ui.dart';

import '../../core/routine_config.dart';

/// Placeholder picture for a pose. Kept in one widget so real drawings can
/// replace it later.
class PoseIllustration extends StatelessWidget {
  final Pose pose;

  const PoseIllustration({super.key, required this.pose});

  @override
  Widget build(BuildContext context) {
    final icon = pose.part == null
        ? Icons.air
        : switch (pose.position) {
            PosePosition.standing => Icons.accessibility_new,
            PosePosition.sitting => Icons.self_improvement,
            PosePosition.lying => Icons.airline_seat_flat,
          };
    return Icon(
      icon,
      size: 96,
      color: Theme.of(context).colorScheme.primary,
      semanticLabel: pose.name,
    );
  }
}
