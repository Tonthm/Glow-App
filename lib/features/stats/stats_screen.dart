import 'package:material_ui/material_ui.dart';

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
      body: const Center(
        child: Text('หน้าสถิติจะมาในเฟส 2', style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
