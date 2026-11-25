import 'package:material_ui/material_ui.dart';

import '../../theme/widgets/empty_state.dart';
import '../shared/settings_button.dart';

/// Placeholder — bed character, shop, and inventory are built in phase 3.
class RoomScreen extends StatelessWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ห้อง'),
        actions: const [SettingsButton()],
      ),
      body: const EmptyState(
        icon: Icons.bed_outlined,
        message: 'หน้าห้องจะมาในเฟส 3',
      ),
    );
  }
}
