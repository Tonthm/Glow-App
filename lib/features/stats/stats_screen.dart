import 'package:material_ui/material_ui.dart';

import '../../theme/widgets/empty_state.dart';
import '../shared/settings_button.dart';

/// Placeholder — heatmap and stats are built in phase 2.
class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('สถิติ'),
        actions: const [SettingsButton()],
      ),
      body: const EmptyState(
        icon: Icons.bar_chart_outlined,
        message: 'หน้าสถิติจะมาในเฟส 2',
      ),
    );
  }
}
