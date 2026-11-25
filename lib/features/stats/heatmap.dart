import 'package:material_ui/material_ui.dart';

import '../../data/database.dart';
import '../../data/stats_repository.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';

const _dayLabels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];
const double _cellSize = 14;
const double _cellGap = 3;

SleepResult? toSleepResult(CheckInRow? row) {
  if (row == null) return null;
  switch (row.result) {
    case CheckInResultDb.enough:
      return row.onTime ? SleepResult.enoughOnTime : SleepResult.enough;
    case CheckInResultDb.almostEnough:
      return SleepResult.almostEnough;
    case CheckInResultDb.notEnough:
      return SleepResult.notEnough;
    case CheckInResultDb.over:
      return SleepResult.over;
  }
}

/// GitHub-contribution-style grid (columns = weeks, rows = Mon..Sun) per
/// CLAUDE.md section 10, colored two-directionally (orange/yellow/green/
/// blue — never red, since that's reserved for meanings red would clash
/// with for colorblind readers) rather than GitHub's "more is better" green
/// scale.
class Heatmap extends StatelessWidget {
  final List<HeatmapCell> cells;
  final ValueChanged<HeatmapCell> onCellTap;

  const Heatmap({super.key, required this.cells, required this.onCellTap});

  @override
  Widget build(BuildContext context) {
    if (cells.isEmpty) return const SizedBox.shrink();

    // Pad the front so the first column starts on a Monday.
    final leadingPad = cells.first.date.weekday - DateTime.monday;
    final padded = [
      ...List.generate(leadingPad, (_) => null),
      ...cells,
    ];
    final weekCount = (padded.length / 7).ceil();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (var week = 0; week < weekCount; week++)
            Padding(
              padding: const EdgeInsets.only(right: _cellGap),
              child: Column(
                children: [
                  for (var day = 0; day < 7; day++)
                    Padding(
                      padding: const EdgeInsets.only(bottom: _cellGap),
                      child: _buildCell(context, padded, week * 7 + day),
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCell(BuildContext context, List<HeatmapCell?> padded, int i) {
    final cell = i < padded.length ? padded[i] : null;
    if (cell == null) {
      return const SizedBox(width: _cellSize, height: _cellSize);
    }
    final glowColors = context.glowColors;
    final result = toSleepResult(cell.checkIn);
    final color = result == null
        ? glowColors.noData
        : glowColors.forResult(result);

    return GestureDetector(
      onTap: () => onCellTap(cell),
      child: Semantics(
        label: '${_dayLabels[cell.date.weekday - 1]} ${cell.date.day}/${cell.date.month}',
        child: Stack(
          children: [
            Container(
              width: _cellSize,
              height: _cellSize,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            if (cell.isPreExamNight)
              Positioned(
                top: 1,
                right: 1,
                child: Container(
                  width: 3,
                  height: 3,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            if (cell.checkIn?.usedShield == true)
              const Positioned(
                bottom: 0,
                right: 0,
                child: Icon(Icons.shield, size: 8),
              ),
          ],
        ),
      ),
    );
  }
}

/// Color legend shown under the heatmap — THEME.md requires one whenever
/// result colors are used without another cue.
class HeatmapLegend extends StatelessWidget {
  const HeatmapLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final glowColors = context.glowColors;
    final entries = {
      'ไม่มีข้อมูล': glowColors.noData,
      'ไม่ครบ': glowColors.notEnough,
      'เกือบครบ': glowColors.almostEnough,
      'ครบ': glowColors.enough,
      'ครบ+ตรงเวลา': glowColors.enoughOnTime,
      'เกิน': glowColors.over,
    };
    return Wrap(
      spacing: GlowSpacing.md,
      runSpacing: GlowSpacing.xs,
      children: [
        for (final entry in entries.entries)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: entry.value,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: GlowSpacing.xs),
              Text(entry.key, style: Theme.of(context).textTheme.labelSmall),
            ],
          ),
      ],
    );
  }
}
