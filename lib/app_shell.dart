import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/demo/demo_button.dart';
import 'features/room/room_screen.dart';
import 'features/schedule/schedule_screen.dart';
import 'features/stats/stats_screen.dart';
import 'features/tonight/tonight_screen.dart';
import 'providers.dart';
import 'theme/tokens.dart';

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
  _TabSpec(outlined: Icons.badge_outlined, filled: Icons.badge, label: 'บัตร'),
];

/// Four labelled tabs in the floating capsule from the Figma design.
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
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Material(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(GlowRadius.pill),
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Row(
              children: [
                for (final (i, spec) in _tabSpecs.indexed)
                  Expanded(
                    child: Semantics(
                      label: spec.label,
                      selected: index == i,
                      button: true,
                      child: Material(
                        color: index == i
                            ? theme.colorScheme.primaryContainer
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () =>
                              ref
                                      .read(selectedTabIndexProvider.notifier)
                                      .state =
                                  i,
                          child: ExcludeSemantics(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  minHeight: 40,
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      index == i ? spec.filled : spec.outlined,
                                      size: 20,
                                      color: index == i
                                          ? theme.colorScheme.onPrimaryContainer
                                          : theme.colorScheme.onSurface,
                                    ),
                                    Text(
                                      spec.label,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: index == i
                                                ? theme
                                                      .colorScheme
                                                      .onPrimaryContainer
                                                : theme.colorScheme.onSurface,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
