import 'package:material_ui/material_ui.dart';

import '../../core/economy_config.dart';

/// The color of an owned blanket, or the starting one.
const int defaultBlanketColor = 0xFFBFC7D1;

Color blanketColorOf(String? itemId) {
  if (itemId == null) return const Color(defaultBlanketColor);
  final match = EconomyConfig.blankets.where((b) => b.id == itemId);
  if (match.isNotEmpty) return Color(match.first.colorValue);
  for (final blanket in EconomyConfig.fireLevelRewardBlankets.values) {
    if (blanket.id == itemId) return Color(blanket.colorValue);
  }
  if (itemId == EconomyConfig.examPeriodRewardBlanket.id) {
    return Color(EconomyConfig.examPeriodRewardBlanket.colorValue);
  }
  return const Color(defaultBlanketColor);
}
