import 'schedule_models.dart';
import 'sleep_calculator.dart';

enum EveningLoadLevel { normal, yellow, red }

/// Result of classifying tonight's evening load, per CLAUDE.md section 4.
class EveningLoadResult {
  final EveningLoadLevel level;
  /// Null when there is nothing scheduled that evening (always normal).
  final DateTime? arriveHomeAt;
  /// The "วางมือถือ" reminder time, shown in the yellow warning as the
  /// deadline to finish other tasks by.
  final DateTime notifyTime;

  const EveningLoadResult({
    required this.level,
    required this.notifyTime,
    this.arriveHomeAt,
  });
}

/// Classifies how busy tonight's evening is, per CLAUDE.md section 4:
/// - ว่างเย็น = เวลาเตือนวางมือถือ − (เวลาจบนัดสุดท้าย + เวลาเดินทางกลับ)
/// - ปกติ: ว่าง >= 120 นาที (โหมดสอบ >= 180)
/// - เหลือง: ว่างน้อยกว่านั้น
/// - แดง: ถึงบ้านหลังเวลาเข้านอนตามแผน, หรือเวลาตั้งแต่ถึงบ้านถึงตื่น < เป้าต่ำสุด + 15 นาที
///
/// [entriesForEveningDate] must already be resolved (schedule_resolver) for
/// the calendar date of the evening leading into [plannedBedtime] — i.e. the
/// day *before* the wake date, not the wake date itself.
EveningLoadResult classifyEveningLoad({
  required List<ScheduleEntry> entriesForEveningDate,
  required DateTime plannedBedtime,
  required DateTime plannedWakeTime,
  required bool isPreExamNight,
  required SleepSettings settings,
}) {
  final notifyOffsetMinutes = isPreExamNight ? 90 : 60;
  final notifyTime = plannedBedtime.subtract(
    Duration(minutes: notifyOffsetMinutes),
  );

  DateTime? lastAppointmentEnd;
  for (final entry in entriesForEveningDate) {
    if (lastAppointmentEnd == null || entry.end.isAfter(lastAppointmentEnd)) {
      lastAppointmentEnd = entry.end;
    }
  }

  if (lastAppointmentEnd == null) {
    return EveningLoadResult(
      level: EveningLoadLevel.normal,
      notifyTime: notifyTime,
    );
  }

  final arriveHome = lastAppointmentEnd.add(
    Duration(minutes: settings.travelMinutes),
  );

  final arrivesAfterBedtime = arriveHome.isAfter(plannedBedtime);
  final availableSleepMinutes = plannedWakeTime
      .difference(arriveHome)
      .inMinutes;
  final cannotMeetMinimum =
      availableSleepMinutes < settings.targetMinMinutes + 15;

  if (arrivesAfterBedtime || cannotMeetMinimum) {
    return EveningLoadResult(
      level: EveningLoadLevel.red,
      notifyTime: notifyTime,
      arriveHomeAt: arriveHome,
    );
  }

  final freeEveningMinutes = notifyTime.difference(arriveHome).inMinutes;
  final normalThresholdMinutes = isPreExamNight ? 180 : 120;

  final level = freeEveningMinutes >= normalThresholdMinutes
      ? EveningLoadLevel.normal
      : EveningLoadLevel.yellow;

  return EveningLoadResult(
    level: level,
    notifyTime: notifyTime,
    arriveHomeAt: arriveHome,
  );
}
