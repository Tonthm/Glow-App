import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../core/check_in.dart';
import '../../data/database.dart';
import '../../data/stats_repository.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/empty_state.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/stat_tile.dart';
import '../shared/settings_button.dart';
import 'heatmap.dart';

enum _StatsRange { term, threeMonths, oneYear }

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

String _formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

const _resultLabels = {
  CheckInResultDb.enough: 'ครบ',
  CheckInResultDb.almostEnough: 'เกือบครบ',
  CheckInResultDb.notEnough: 'ไม่ครบ',
  CheckInResultDb.over: 'เกิน',
};

final _statsRangeProvider = StateProvider<_StatsRange>((ref) => _StatsRange.term);

final _statsCellsProvider = FutureProvider.autoDispose<List<HeatmapCell>>((
  ref,
) async {
  final range = ref.watch(_statsRangeProvider);
  ref.watch(fireStateStreamProvider); // refresh after a check-in
  final settings = await ref.watch(settingsStreamProvider.future);
  final today = _dateOnly(DateTime.now());

  final start = switch (range) {
    _StatsRange.term => settings.termStart != null
        ? _dateOnly(settings.termStart!)
        : today.subtract(const Duration(days: 90)),
    _StatsRange.threeMonths => today.subtract(const Duration(days: 90)),
    _StatsRange.oneYear => today.subtract(const Duration(days: 365)),
  };

  return ref.watch(statsRepositoryProvider).rangeCells(start, today);
});

/// Average hours of the last 30 days against the 30 days before them.
final _monthComparisonProvider = FutureProvider.autoDispose<String>((ref) async {
  final settings = await ref.watch(settingsStreamProvider.future);
  final repo = ref.watch(statsRepositoryProvider);
  final today = _dateOnly(DateTime.now());
  DateTime daysAgo(int n) => DateTime(today.year, today.month, today.day - n);
  StatsSummary summarize(List<HeatmapCell> cells) => repo.summarize(
    cells,
    fallAsleepMinutes: settings.fallAsleepMinutes,
  );

  final recent = summarize(await repo.rangeCells(daysAgo(29), today));
  final before = summarize(await repo.rangeCells(daysAgo(59), daysAgo(30)));
  if (recent.nightsWithData == 0 || before.nightsWithData == 0) {
    return 'เทียบกับเดือนก่อน: ข้อมูลยังไม่พอ';
  }
  final diff = (recent.averageSleepMinutes - before.averageSleepMinutes).round();
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
        actions: const [SettingsButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Wrap(
              spacing: GlowSpacing.sm,
              children: [
                ChoiceChip(
                  label: const Text('เทอมนี้'),
                  selected: range == _StatsRange.term,
                  onSelected: (_) =>
                      ref.read(_statsRangeProvider.notifier).state = _StatsRange.term,
                ),
                ChoiceChip(
                  label: const Text('3 เดือน'),
                  selected: range == _StatsRange.threeMonths,
                  onSelected: (_) => ref.read(_statsRangeProvider.notifier).state =
                      _StatsRange.threeMonths,
                ),
                ChoiceChip(
                  label: const Text('1 ปี'),
                  selected: range == _StatsRange.oneYear,
                  onSelected: (_) =>
                      ref.read(_statsRangeProvider.notifier).state = _StatsRange.oneYear,
                ),
              ],
            ),
            const SizedBox(height: GlowSpacing.lg),
            Expanded(
              child: cellsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
                data: (cells) {
                  final hasAnyData = cells.any((c) => c.checkIn != null);
                  if (!hasAnyData) {
                    return const EmptyState(
                      icon: Icons.bar_chart_outlined,
                      message: 'ยังไม่มีข้อมูล เช็กอินสักสองสามคืนแล้วค่อยกลับมาดู',
                    );
                  }
                  final fallAsleepMinutes =
                      ref.watch(settingsStreamProvider).value?.fallAsleepMinutes ??
                      15;
                  final summary = ref
                      .read(statsRepositoryProvider)
                      .summarize(cells, fallAsleepMinutes: fallAsleepMinutes);
                  final longestStreak =
                      ref.watch(fireStateStreamProvider).value?.longestStreak ?? 0;
                  final comparison = ref.watch(_monthComparisonProvider).value;
                  return ListView(
                    children: [
                      Heatmap(
                        cells: cells,
                        onCellTap: (cell) =>
                            _showCellDetail(context, cell, fallAsleepMinutes),
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
      builder: (context) => _CellDetailSheet(
        cell: cell,
        fallAsleepMinutes: fallAsleepMinutes,
      ),
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
                Expanded(child: tiles[i]),
                Expanded(child: tiles[i + 1]),
              ],
            ),
          ),
      ],
    );
  }
}

class _CellDetailSheet extends StatelessWidget {
  final HeatmapCell cell;
  final int fallAsleepMinutes;
  const _CellDetailSheet({
    required this.cell,
    required this.fallAsleepMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final checkIn = cell.checkIn;
    final slept = checkIn == null
        ? Duration.zero
        : actualSleepDuration(
            lightsOffAt: checkIn.lightsOffAt,
            wakeAt: checkIn.actualWakeAt,
            fallAsleepMinutes: fallAsleepMinutes,
          );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${cell.date.day}/${cell.date.month}/${cell.date.year}',
          style: textTheme.titleLarge,
        ),
        const SizedBox(height: GlowSpacing.md),
        if (checkIn == null)
          Text('ไม่มีข้อมูลคืนนี้', style: textTheme.bodyMedium)
        else ...[
          Text(
            '${_formatTime(checkIn.lightsOffAt)} → ${_formatTime(checkIn.actualWakeAt)}',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: GlowSpacing.xs),
          Text(
            'นอน ${slept.inHours} ชม. ${slept.inMinutes % 60} นาที '
            '· ${_resultLabels[checkIn.result]}'
            '${checkIn.onTime ? ' · ตรงเวลา' : ''}',
            style: textTheme.bodyMedium,
          ),
        ],
        if (cell.usedShield) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text('ใช้โล่คืนนี้', style: textTheme.bodyMedium),
        ],
        if (cell.isPreExamNight) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text('มีสอบ', style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}
