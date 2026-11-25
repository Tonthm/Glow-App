import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

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
                  final summary = ref.read(statsRepositoryProvider).summarize(cells);
                  return ListView(
                    children: [
                      Heatmap(
                        cells: cells,
                        onCellTap: (cell) => _showCellDetail(context, cell),
                      ),
                      const SizedBox(height: GlowSpacing.md),
                      const HeatmapLegend(),
                      const SizedBox(height: GlowSpacing.xl),
                      _SummaryNumbers(summary: summary),
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

  void _showCellDetail(BuildContext context, HeatmapCell cell) {
    showGlowBottomSheet(
      context: context,
      builder: (context) => _CellDetailSheet(cell: cell),
    );
  }
}

class _SummaryNumbers extends StatelessWidget {
  final StatsSummary summary;
  const _SummaryNumbers({required this.summary});

  @override
  Widget build(BuildContext context) {
    final avgHours = summary.averageSleepMinutes ~/ 60;
    final avgMins = summary.averageSleepMinutes.toInt() % 60;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        StatTile(value: '$avgHours ชม. $avgMins น.', label: 'ชั่วโมงเฉลี่ย'),
        StatTile(
          value: '${summary.percentComplete.toStringAsFixed(0)}%',
          label: 'คืนที่ครบ',
        ),
        StatTile(
          value: '±${summary.lightsOffVarianceMinutes.toStringAsFixed(0)} นาที',
          label: 'ปิดไฟแกว่ง',
        ),
      ],
    );
  }
}

class _CellDetailSheet extends StatelessWidget {
  final HeatmapCell cell;
  const _CellDetailSheet({required this.cell});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final checkIn = cell.checkIn;
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
            '${checkIn.actualWakeAt.difference(checkIn.lightsOffAt).inHours} ชม. '
            '${checkIn.actualWakeAt.difference(checkIn.lightsOffAt).inMinutes % 60} นาที '
            '· ${_resultLabels[checkIn.result]}'
            '${checkIn.onTime ? ' · ตรงเวลา' : ''}',
            style: textTheme.bodyMedium,
          ),
          if (checkIn.usedShield) ...[
            const SizedBox(height: GlowSpacing.xs),
            Text('ใช้โล่คืนนี้', style: textTheme.bodyMedium),
          ],
        ],
        if (cell.isPreExamNight) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text('มีสอบ', style: textTheme.bodyMedium),
        ],
      ],
    );
  }
}
