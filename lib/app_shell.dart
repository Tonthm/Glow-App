import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/room/room_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/tonight/tonight_screen.dart';
import 'providers.dart';

const _tabs = [
  TonightScreen(),
  ScheduleScreen(),
  StatsScreen(),
  RoomScreen(),
];

/// Bottom nav with the 4 tabs from CLAUDE.md section 1, plus the settings
/// shortcut in the top-right corner.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedTabIndexProvider);

    return Scaffold(
      body: IndexedStack(index: index, children: _tabs),
      bottomNavigationBar: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: (i) =>
            ref.read(selectedTabIndexProvider.notifier).state = i,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.nightlight_outlined), label: 'คืนนี้'),
          NavigationDestination(icon: Icon(Icons.calendar_today_outlined), label: 'ตาราง'),
          NavigationDestination(icon: Icon(Icons.bar_chart_outlined), label: 'สถิติ'),
          NavigationDestination(icon: Icon(Icons.bed_outlined), label: 'ห้อง'),
        ],
      ),
    );
  }
}
