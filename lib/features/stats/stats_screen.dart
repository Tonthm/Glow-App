import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/stats_repository.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/stat_tile.dart';
import '../share/share_screen.dart';
import '../shared/settings_button.dart';
import 'heatmap.dart';
import 'night_detail_sheet.dart';
import '../../services/app_clock.dart';

enum _StatsRange { term, threeMonths, oneYear }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

final _statsRangeProvider = StateProvider<_StatsRange>(
  (ref) => _StatsRange.term,
);

final _statsCellsProvider = FutureProvider.autoDispose<List<HeatmapCell>>((
  ref,
) async {
  final range = ref.watch(_statsRangeProvider);
  ref.watch(nightHistoryChangesProvider);
  final settings = await ref.watch(settingsStreamProvider.future);
  final today = _dateOnly(ref.watch(clockProvider)());

  final start = switch (range) {
    _StatsRange.term =>
      settings.termStart != null
          ? _dateOnly(settings.termStart!)
          : today.subtract(const Duration(days: 90)),
    _StatsRange.threeMonths => today.subtract(const Duration(days: 90)),
    _StatsRange.oneYear => today.subtract(const Duration(days: 365)),
  };

  return ref.watch(statsRepositoryProvider).rangeCells(start, today);
});

/// Average hours of the last 30 days against the 30 days before them.
final _monthComparisonProvider = FutureProvider.autoDispose<String>((
  ref,
) async {
  final settings = await ref.watch(settingsStreamProvider.future);
  ref.watch(nightHistoryChangesProvider);
  final repo = ref.watch(statsRepositoryProvider);
  final today = _dateOnly(ref.watch(clockProvider)());
  DateTime daysAgo(int n) => DateTime(today.year, today.month, today.day - n);
  StatsSummary summarize(List<HeatmapCell> cells) =>
      repo.summarize(cells, fallAsleepMinutes: settings.fallAsleepMinutes);

  final recent = summarize(await repo.rangeCells(daysAgo(29), today));
  final before = summarize(await repo.rangeCells(daysAgo(59), daysAgo(30)));
  if (recent.nightsWithData == 0 || before.nightsWithData == 0) {
    return 'เทียบกับเดือนก่อน: ข้อมูลยังไม่พอ';
  }
  final diff = (recent.averageSleepMinutes - before.averageSleepMinutes)
      .round();
  if (diff == 0) return 'เทียบกับเดือนก่อน: นอนเฉลี่ยเท่าเดิม';
  return 'เทียบกับเดือนก่อน: นอนเฉลี่ย${diff > 0 ? 'มากขึ้น' : 'น้อยลง'} '
      '${diff.abs()} นาที';
});

/// Heatmap + summary stats per CLAUDE.md section 10.
class StatsScreen extends ConsumerWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final range = ref.watch(_statsRangeProvider);
    final cellsAsync = ref.watch(_statsCellsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('สถิติ'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_outlined),
            tooltip: 'แชร์ลงสตอรี่',
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const ShareScreen())),
          ),
          const SettingsButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<_StatsRange>(
              showSelectedIcon: false,
              segments: const [
                ButtonSegment(value: _StatsRange.term, label: Text('เทอมนี้')),
                ButtonSegment(
                  value: _StatsRange.threeMonths,
                  label: Text('3 เดือน'),
                ),
                ButtonSegment(value: _StatsRange.oneYear, label: Text('1 ปี')),
              ],
              selected: {range},
              onSelectionChanged: (v) =>
                  ref.read(_statsRangeProvider.notifier).state = v.single,
            ),
            const SizedBox(height: GlowSpacing.lg),
            Expanded(
              child: cellsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
                data: (cells) {
                  final hasAnyData = cells.any((c) => c.checkIn != null);
                  if (!hasAnyData) {
                    return GlowCard(
                      child: SizedBox.expand(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.bar_chart_rounded, size: 88),
                                const SizedBox(height: GlowSpacing.xl),
                                Text(
                                  'คืนนี้คือจุดเริ่มต้น',
                                  style: Theme.of(context).textTheme.titleLarge,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: GlowSpacing.sm),
                                Text(
                                  'ยังไม่มีข้อมูล เช็กอินสักสองสามคืน\nแล้วค่อยกลับมาดู',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: GlowSpacing.xxl),
                                Text(
                                  'ทุกคืนที่นอนดี มีความหมาย',
                                  style: Theme.of(context).textTheme.labelSmall,
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  final fallAsleepMinutes =
                      ref
                          .watch(settingsStreamProvider)
                          .value
                          ?.fallAsleepMinutes ??
                      15;
                  final summary = ref
                      .read(statsRepositoryProvider)
                      .summarize(cells, fallAsleepMinutes: fallAsleepMinutes);
                  final longestStreak =
                      ref.watch(fireStateStreamProvider).value?.longestStreak ??
                      0;
                  final comparison = ref.watch(_monthComparisonProvider).value;
                  return ListView(
                    children: [
                      GlowCard(
                        child: Heatmap(
                          cells: cells,
                          onCellTap: (cell) =>
                              _showCellDetail(context, cell, fallAsleepMinutes),
                        ),
                      ),
                      const SizedBox(height: GlowSpacing.md),
                      const HeatmapLegend(),
                      const SizedBox(height: GlowSpacing.xl),
                      _SummaryNumbers(
                        summary: summary,
                        longestStreak: longestStreak,
                      ),
                      if (comparison != null) ...[
                        const SizedBox(height: GlowSpacing.lg),
                        Text(
                          comparison,
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCellDetail(
    BuildContext context,
    HeatmapCell cell,
    int fallAsleepMinutes,
  ) {
    showGlowBottomSheet(
      context: context,
      builder: (context) =>
          NightDetailSheet(cell: cell, fallAsleepMinutes: fallAsleepMinutes),
    );
  }
}

class _SummaryNumbers extends StatelessWidget {
  final StatsSummary summary;
  final int longestStreak;
  const _SummaryNumbers({required this.summary, required this.longestStreak});

  @override
  Widget build(BuildContext context) {
    final avgHours = summary.averageSleepMinutes ~/ 60;
    final avgMins = summary.averageSleepMinutes.toInt() % 60;
    final tiles = [
      StatTile(value: '$avgHours ชม. $avgMins น.', label: 'ชั่วโมงเฉลี่ย'),
      StatTile(
        value: '${summary.percentComplete.toStringAsFixed(0)}%',
        label: 'คืนที่ครบ',
      ),
      StatTile(value: '$longestStreak คืน', label: 'สตรีคยาวสุด'),
      StatTile(
        value: '±${summary.lightsOffVarianceMinutes.toStringAsFixed(0)} นาที',
        label: 'เวลาปิดไฟแกว่ง',
      ),
    ];
    // Two per row so nothing overflows on narrow phones.
    return Column(
      children: [
        for (var i = 0; i < tiles.length; i += 2)
          Padding(
            padding: const EdgeInsets.only(bottom: GlowSpacing.lg),
            child: Row(
              children: [
                Expanded(child: GlowCard(child: tiles[i])),
                const SizedBox(width: GlowSpacing.sm),
                Expanded(child: GlowCard(child: tiles[i + 1])),
              ],
            ),
          ),
      ],
    );
  }
}
