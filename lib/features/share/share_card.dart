import 'package:material_ui/material_ui.dart';

import '../../core/check_in.dart';
import '../../core/fire.dart';
import '../../data/database.dart';
import '../../data/stats_repository.dart';
import '../../theme/glow_colors.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/arrow_span.dart';
import '../../theme/widgets/bed_character.dart';
import '../stats/heatmap.dart';

/// The card's layout size; rendered at 3x it is 1080 x 1920.
const Size shareCardSize = Size(360, 640);

const _dayLabels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

/// "ครบ" is a check icon instead: the bundled fonts have no check character.
const _resultMarks = {
  CheckInResultDb.almostEnough: '≈',
  CheckInResultDb.notEnough: '−',
  CheckInResultDb.over: '+',
};

String _clock(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:'
    '${t.minute.toString().padLeft(2, '0')}';

/// One week as a picture to share (CLAUDE.md section 15). It carries no name
/// or other personal details, and no clock times unless the user turns them
/// on.
class ShareCard extends StatelessWidget {
  final List<HeatmapCell> week;
  final int fireLevel;
  final Color blanketColor;
  final bool showTimes;
  final int fallAsleepMinutes;

  const ShareCard({
    super.key,
    required this.week,
    required this.fireLevel,
    required this.blanketColor,
    required this.showTimes,
    required this.fallAsleepMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = context.glowColors;
    final complete = week
        .where((c) => c.checkIn?.result == CheckInResultDb.enough)
        .length;
    final first = week.first.date;
    final last = week.last.date;
    final checkedIn = week.where((c) => c.checkIn != null).toList();

    return SizedBox(
      width: shareCardSize.width,
      height: shareCardSize.height,
      child: ColoredBox(
        color: theme.scaffoldBackgroundColor,
        child: Padding(
          padding: const EdgeInsets.all(GlowSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    'Glow',
                    style: textTheme.displayLarge?.copyWith(
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'สัปดาห์ ${first.day}/${first.month} – '
                    '${last.day}/${last.month}',
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
              SizedBox(
                width: 180,
                height: 150,
                child: BedCharacter(
                  blanketColor: blanketColor,
                  isFluffy: complete * 2 >= checkedIn.length,
                  lampOpacity: 0.3 + 0.7 * (fireLevel / maxFireLevel),
                ),
              ),
              Column(
                children: [
                  Text('คืนที่ครบ $complete/7', style: textTheme.headlineLarge),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.local_fire_department, color: colors.lampGlow),
                      const SizedBox(width: GlowSpacing.xs),
                      Text(
                        fireLevelNames[fireLevel],
                        style: textTheme.titleLarge,
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  for (final cell in week)
                    Column(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: toSleepResult(cell.checkIn) == null
                                ? colors.noData
                                : colors.forResult(
                                    toSleepResult(cell.checkIn)!,
                                  ),
                            borderRadius: BorderRadius.circular(
                              GlowRadius.button,
                            ),
                          ),
                          // A mark as well as a color.
                          child: cell.checkIn?.result == CheckInResultDb.enough
                              ? const Icon(
                                  Icons.check,
                                  color: GlowBaseColors.ink,
                                )
                              : Text(
                                  _resultMarks[cell.checkIn?.result] ?? '',
                                  style: textTheme.titleLarge?.copyWith(
                                    color: GlowBaseColors.ink,
                                  ),
                                ),
                        ),
                        Text(
                          _dayLabels[cell.date.weekday - 1],
                          style: textTheme.labelSmall,
                        ),
                      ],
                    ),
                ],
              ),
              Text.rich(
                TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Icon(
                        Icons.check,
                        size: textTheme.labelSmall?.fontSize,
                        color: textTheme.labelSmall?.color,
                      ),
                    ),
                    const TextSpan(
                      text: ' ครบ · ≈ เกือบครบ · − ไม่ครบ · + เกิน',
                    ),
                  ],
                ),
                style: textTheme.labelSmall,
              ),
              if (showTimes)
                Column(
                  children: [
                    for (final cell in checkedIn)
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text:
                                  '${_dayLabels[cell.date.weekday - 1]}  '
                                  '${_clock(cell.checkIn!.lightsOffAt)} ',
                            ),
                            arrowSpan(textTheme.labelSmall),
                            TextSpan(
                              text:
                                  ' ${_clock(cell.checkIn!.actualWakeAt)}  '
                                  '(${_hours(cell)})',
                            ),
                          ],
                        ),
                        style: textTheme.labelSmall,
                      ),
                  ],
                )
              else
                Text('นอนให้พอ แล้วไฟจะสว่างขึ้น', style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  String _hours(HeatmapCell cell) {
    final slept = actualSleepDuration(
      lightsOffAt: cell.checkIn!.lightsOffAt,
      wakeAt: cell.checkIn!.actualWakeAt,
      fallAsleepMinutes: fallAsleepMinutes,
    );
    return '${slept.inHours} ชม. ${slept.inMinutes % 60} น.';
  }
}
