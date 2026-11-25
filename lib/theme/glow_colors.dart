import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

enum SleepResult { noData, notEnough, almostEnough, enough, enoughOnTime, over }

/// ThemeExtension carrying colors THEME.md defines but ThemeData has no slot
/// for: the two-directional sleep-result palette and the bedside lamp glow.
/// Access via `Theme.of(context).extension<GlowColors>()!` (or the
/// [GlowColorsX.glowColors] shortcut below).
class GlowColors extends ThemeExtension<GlowColors> {
  final Color lampGlow;
  final Color noData;
  final Color notEnough;
  final Color almostEnough;
  final Color enough;
  final Color enoughOnTime;
  final Color over;

  const GlowColors({
    required this.lampGlow,
    required this.noData,
    required this.notEnough,
    required this.almostEnough,
    required this.enough,
    required this.enoughOnTime,
    required this.over,
  });

  static const light = GlowColors(
    lampGlow: GlowBaseColors.lampGlow,
    noData: GlowResultColors.noDataLight,
    notEnough: GlowResultColors.notEnoughLight,
    almostEnough: GlowResultColors.almostEnoughLight,
    enough: GlowResultColors.enoughLight,
    enoughOnTime: GlowResultColors.enoughOnTimeLight,
    over: GlowResultColors.overLight,
  );

  static const dark = GlowColors(
    lampGlow: GlowBaseColors.lampGlow,
    noData: GlowResultColors.noDataDark,
    notEnough: GlowResultColors.notEnoughDark,
    almostEnough: GlowResultColors.almostEnoughDark,
    enough: GlowResultColors.enoughDark,
    enoughOnTime: GlowResultColors.enoughOnTimeDark,
    over: GlowResultColors.overDark,
  );

  Color forResult(SleepResult result) => switch (result) {
    SleepResult.noData => noData,
    SleepResult.notEnough => notEnough,
    SleepResult.almostEnough => almostEnough,
    SleepResult.enough => enough,
    SleepResult.enoughOnTime => enoughOnTime,
    SleepResult.over => over,
  };

  @override
  GlowColors copyWith({
    Color? lampGlow,
    Color? noData,
    Color? notEnough,
    Color? almostEnough,
    Color? enough,
    Color? enoughOnTime,
    Color? over,
  }) {
    return GlowColors(
      lampGlow: lampGlow ?? this.lampGlow,
      noData: noData ?? this.noData,
      notEnough: notEnough ?? this.notEnough,
      almostEnough: almostEnough ?? this.almostEnough,
      enough: enough ?? this.enough,
      enoughOnTime: enoughOnTime ?? this.enoughOnTime,
      over: over ?? this.over,
    );
  }

  @override
  GlowColors lerp(ThemeExtension<GlowColors>? other, double t) {
    if (other is! GlowColors) return this;
    return GlowColors(
      lampGlow: Color.lerp(lampGlow, other.lampGlow, t)!,
      noData: Color.lerp(noData, other.noData, t)!,
      notEnough: Color.lerp(notEnough, other.notEnough, t)!,
      almostEnough: Color.lerp(almostEnough, other.almostEnough, t)!,
      enough: Color.lerp(enough, other.enough, t)!,
      enoughOnTime: Color.lerp(enoughOnTime, other.enoughOnTime, t)!,
      over: Color.lerp(over, other.over, t)!,
    );
  }
}

extension GlowColorsX on BuildContext {
  GlowColors get glowColors => Theme.of(this).extension<GlowColors>()!;
}
