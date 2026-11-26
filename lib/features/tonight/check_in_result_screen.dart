import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/check_in.dart';
import '../../core/fire.dart';
import '../../core/quests.dart';
import '../../data/check_in_repository.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../share/share_screen.dart';

const _resultLabels = {
  CheckInResult.enough: 'ครบ',
  CheckInResult.almostEnough: 'เกือบครบ',
  CheckInResult.notEnough: 'ไม่ครบ',
  CheckInResult.over: 'เกิน',
};

const _dayLabels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

SleepResult _toSleepResult(CheckInRow row) {
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

/// Shown right after a morning check-in: result, how fire changed, and this
/// week's stats with a 7-day bar chart (CLAUDE.md section 6).
class CheckInResultScreen extends ConsumerWidget {
  final DateTime wakeDate;
  final CheckInRecordResult result;
  final FireStateRow fireBefore;
  final FireStateRow fireAfter;

  const CheckInResultScreen({
    super.key,
    required this.wakeDate,
    required this.result,
    required this.fireBefore,
    required this.fireAfter,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ผลเช็กอิน')),
      body: FutureBuilder<List<WeekCheckInSummary>>(
        future: ref.read(checkInRepositoryProvider).weekSummary(wakeDate),
        builder: (context, snapshot) {
          final week = snapshot.data;
          return ListView(
            padding: const EdgeInsets.all(GlowSpacing.pageMargin),
            children: [
              Center(
                child: Column(
                  children: [
                    Text(
                      _resultLabels[result.outcome.result]!,
                      style: textTheme.displayLarge,
                    ),
                    const SizedBox(height: GlowSpacing.xs),
                    Text(
                      result.outcome.onTime ? 'ตรงเวลา' : 'ไม่ตรงเวลา',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: GlowSpacing.xs),
                    Text(
                      '${result.outcome.sleepDuration.inHours} ชม. '
                      '${result.outcome.sleepDuration.inMinutes % 60} นาที',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: GlowSpacing.xs),
                    Text(
                      '+${result.coinsEarned} เหรียญ',
                      style: textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              if (result.outcome.result == CheckInResult.notEnough) ...[
                const SizedBox(height: GlowSpacing.md),
                Text(
                  'คืนนี้ลองปิดไฟเร็วขึ้น 20 นาที',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: GlowSpacing.xl),
              const Divider(),
              const SizedBox(height: GlowSpacing.lg),
              _FireChangeRow(before: fireBefore, after: fireAfter),
              if (!result.pressedInBed &&
                  result.outcome.result == CheckInResult.enough)
                Text(
                  'คืนหน้ากด "เข้านอนแล้ว" ตอนวางมือถือด้วย ไฟจะขึ้นได้',
                  style: textTheme.bodyMedium,
                ),
              if (result.mode == QuestMode.minimum)
                Text(
                  result.outcome.onTime
                      ? 'โหมดขั้นต่ำ: หลับตามแผนสำเร็จ'
                      : 'โหมดขั้นต่ำ: พักได้ คืนหน้าค่อยว่ากัน',
                  style: textTheme.bodyMedium,
                ),
              const SizedBox(height: GlowSpacing.xl),
              const Divider(),
              const SizedBox(height: GlowSpacing.lg),
              Text('สัปดาห์นี้', style: textTheme.titleLarge),
              const SizedBox(height: GlowSpacing.md),
              if (week != null)
                _WeekStats(
                  week: week,
                  fallAsleepMinutes:
                      ref
                          .watch(settingsStreamProvider)
                          .value
                          ?.fallAsleepMinutes ??
                      15,
                ),
              // Monday wraps up the week that just ended.
              if (wakeDate.weekday == DateTime.monday)
                TextButton.icon(
                  icon: const Icon(Icons.ios_share_outlined),
                  label: const Text('แชร์ลงสตอรี่'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ShareScreen()),
                  ),
                ),
              const SizedBox(height: GlowSpacing.xl),
              GlowPrimaryButton(
                label: 'ตกลง',
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FireChangeRow extends StatelessWidget {
  final FireStateRow before;
  final FireStateRow after;
  const _FireChangeRow({required this.before, required this.after});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final String message;
    if (after.level > before.level) {
      message = 'ไฟขึ้นเป็น ${fireLevelNames[after.level]}';
    } else if (after.level < before.level) {
      message = 'ไฟลดเป็น ${fireLevelNames[after.level]}';
    } else if (after.shields < before.shields) {
      message = 'ใช้โล่ไปแล้ว 1 อัน ไฟคงเดิมที่ ${fireLevelNames[after.level]}';
    } else {
      message =
          'ไฟยังอยู่ที่ ${fireLevelNames[after.level]} (${after.points} แต้ม)';
    }
    return Row(
      children: [
        Icon(
          Icons.local_fire_department,
          color: context.glowColors.lampGlow,
          size: 28,
        ),
        const SizedBox(width: GlowSpacing.sm),
        Expanded(child: Text(message, style: textTheme.bodyLarge)),
      ],
    );
  }
}

class _WeekStats extends StatelessWidget {
  final List<WeekCheckInSummary> week;
  final int fallAsleepMinutes;
  const _WeekStats({required this.week, required this.fallAsleepMinutes});

  @override
  Widget build(BuildContext context) {
    final completeCount = week
        .where((d) => d.checkIn?.result == CheckInResultDb.enough)
        .length;
    final sleptMinutes = week
        .where((d) => d.checkIn != null)
        .map(
          (d) => actualSleepDuration(
            lightsOffAt: d.checkIn!.lightsOffAt,
            wakeAt: d.checkIn!.actualWakeAt,
            fallAsleepMinutes: fallAsleepMinutes,
          ).inMinutes,
        )
        .toList();
    final avgMinutes = sleptMinutes.isEmpty
        ? 0
        : sleptMinutes.reduce((a, b) => a + b) ~/ sleptMinutes.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'คืนที่ครบ $completeCount/7 · เฉลี่ย ${avgMinutes ~/ 60} ชม. ${avgMinutes % 60} นาที',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: GlowSpacing.md),
        SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < 7; i++)
                _DayBar(
                  dayLabel: _dayLabels[i],
                  checkIn: week[i].checkIn,
                  fallAsleepMinutes: fallAsleepMinutes,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// One bar of the "กราฟแท่ง 7 วัน" (section 6): height ∝ hours slept, colored
/// by that night's sleep-result bucket; empty-outline bar when no data.
class _DayBar extends StatelessWidget {
  final String dayLabel;
  final CheckInRow? checkIn;

  final int fallAsleepMinutes;

  const _DayBar({
    required this.dayLabel,
    required this.checkIn,
    required this.fallAsleepMinutes,
  });

  static const double _maxBarHeight = 90;
  static const double _minutesForFullBar = 12 * 60;

  @override
  Widget build(BuildContext context) {
    final glowColors = context.glowColors;
    final checkIn = this.checkIn;
    final sleptMinutes = checkIn == null
        ? 0
        : actualSleepDuration(
            lightsOffAt: checkIn.lightsOffAt,
            wakeAt: checkIn.actualWakeAt,
            fallAsleepMinutes: fallAsleepMinutes,
          ).inMinutes;
    final barHeight = checkIn == null
        ? 0.0
        : (_maxBarHeight * sleptMinutes / _minutesForFullBar).clamp(
            4.0,
            _maxBarHeight,
          );
    final color = checkIn == null
        ? glowColors.noData
        : glowColors.forResult(_toSleepResult(checkIn));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: _maxBarHeight,
          width: 24,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: checkIn == null ? 4 : barHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(GlowRadius.button),
              ),
            ),
          ),
        ),
        const SizedBox(height: GlowSpacing.xs),
        Text(dayLabel, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}
