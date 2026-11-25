import 'package:material_ui/material_ui.dart';

import '../settings/settings_screen.dart';

/// Settings shortcut shown at the top-right of each tab's AppBar
/// (CLAUDE.md section 1: "มีปุ่มตั้งค่าที่มุมบนขวา").
class SettingsButton extends StatelessWidget {
  const SettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.settings_outlined),
      tooltip: 'ตั้งค่า',
      onPressed: () =>
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => const SettingsScreen())),
    );
  }
}
