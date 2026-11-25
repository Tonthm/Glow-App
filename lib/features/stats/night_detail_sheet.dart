import 'package:material_ui/material_ui.dart';

import '../../core/check_in.dart';
import '../../core/quests.dart';
import '../../data/database.dart';
import '../../data/stats_repository.dart';
import '../../theme/tokens.dart';

const questModeLabels = {
  QuestMode.normal: 'ปกติ',
  QuestMode.light: 'เบา',
  QuestMode.minimum: 'ขั้นต่ำ',
};

const _resultLabels = {
  CheckInResultDb.enough: 'ครบ',
  CheckInResultDb.almostEnough: 'เกือบครบ',
  CheckInResultDb.notEnough: 'ไม่ครบ',
  CheckInResultDb.over: 'เกิน',
};

String _formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

/// One night's details (CLAUDE.md section 10), opened from a heatmap square
/// or a week ring.
class NightDetailSheet extends StatelessWidget {
  final HeatmapCell cell;
  final int fallAsleepMinutes;
  const NightDetailSheet({
    super.key,
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
        if (checkIn != null) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text(
            checkIn.pressedInBed ? 'กดเข้านอนแล้ว' : 'ไม่ได้กดเข้านอน',
            style: textTheme.bodyMedium,
          ),
        ],
        if (cell.questMode != null) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text(
            'โหมดเควส: ${questModeLabels[QuestMode.values[cell.questMode!]]}',
            style: textTheme.bodyMedium,
          ),
        ],
        if (cell.routineDone) ...[
          const SizedBox(height: GlowSpacing.xs),
          Text('ทำท่าก่อนนอนแล้ว', style: textTheme.bodyMedium),
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
