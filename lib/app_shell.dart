import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/demo/demo_button.dart';
import 'features/room/room_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/tonight/tonight_screen.dart';
import 'providers.dart';

const _tabs = [TonightScreen(), ScheduleScreen(), StatsScreen(), RoomScreen()];

class _TabSpec {
  final IconData outlined;
  final IconData filled;
  final String label;

  const _TabSpec({
    required this.outlined,
    required this.filled,
    required this.label,
  });
}

const _tabSpecs = [
  _TabSpec(
    outlined: Icons.nightlight_outlined,
    filled: Icons.nightlight,
    label: 'คืนนี้',
  ),
  _TabSpec(
    outlined: Icons.calendar_today_outlined,
    filled: Icons.calendar_today,
    label: 'ตาราง',
  ),
  _TabSpec(
    outlined: Icons.bar_chart_outlined,
    filled: Icons.bar_chart,
    label: 'สถิติ',
  ),
  _TabSpec(
    outlined: Icons.badge_outlined,
    filled: Icons.badge,
    label: 'บัตรของฉัน',
  ),
];

/// Bottom nav with the 4 tabs from CLAUDE.md section 1 (icons only, per
/// THEME.md "ไม่มีตัวหนังสือ"), plus the settings shortcut in each tab's
/// top-right corner.
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final index = ref.watch(selectedTabIndexProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          IndexedStack(index: index, children: _tabs),
          // Top middle: clear of titles, actions, and the main button.
          if (kDebugMode)
            const SafeArea(
              child: Align(alignment: Alignment.topCenter, child: DemoButton()),
            ),
        ],
      ),
      bottomNavigationBar: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: theme.dividerColor, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          onTap: (i) => ref.read(selectedTabIndexProvider.notifier).state = i,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            for (final spec in _tabSpecs)
              BottomNavigationBarItem(
                icon: Semantics(label: spec.label, child: Icon(spec.outlined)),
                activeIcon: Semantics(
                  label: spec.label,
                  child: Icon(spec.filled),
                ),
                label: spec.label,
              ),
          ],
        ),
      ),
    );
  }
}
