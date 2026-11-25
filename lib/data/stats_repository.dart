import 'package:drift/drift.dart';

import 'database.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// One heatmap square's data, per CLAUDE.md section 10.
class HeatmapCell {
  final DateTime date;
  final CheckInRow? checkIn;
  final bool isPreExamNight;

  const HeatmapCell({
    required this.date,
    required this.checkIn,
    required this.isPreExamNight,
  });
}

class StatsSummary {
  final double averageSleepMinutes;
  final double percentComplete;
  final double lightsOffVarianceMinutes;
  final int nightsWithData;

  const StatsSummary({
    required this.averageSleepMinutes,
    required this.percentComplete,
    required this.lightsOffVarianceMinutes,
    required this.nightsWithData,
  });

  static const empty = StatsSummary(
    averageSleepMinutes: 0,
    percentComplete: 0,
    lightsOffVarianceMinutes: 0,
    nightsWithData: 0,
  );
}

/// "Continuous" minutes-since-midnight for a lights-off time, measured from
/// the evening before [wakeDate] — the same trick sleep_calculator uses so
/// an after-midnight lights-off (e.g. 00:30) compares sensibly against an
/// earlier one (e.g. 22:00) instead of looking like it's 22 hours apart.
int _continuousLightsOffMinutes(DateTime wakeDate, DateTime lightsOffAt) {
  final eveningAnchor = _dateOnly(wakeDate).subtract(const Duration(days: 1));
  return lightsOffAt.difference(eveningAnchor).inMinutes;
}

/// Reads check-in history for the stats screen's heatmap and summary
/// numbers (CLAUDE.md section 10).
class StatsRepository {
  final AppDatabase db;

  StatsRepository(this.db);

  Future<List<HeatmapCell>> rangeCells(DateTime start, DateTime end) async {
    final startDate = _dateOnly(start);
    final endDate = _dateOnly(end);
    final checkIns =
        await (db.select(db.checkIns)..where(
              (t) =>
                  t.wakeDate.isBiggerOrEqualValue(startDate) &
                  t.wakeDate.isSmallerOrEqualValue(endDate),
            ))
            .get();
    final plans =
        await (db.select(db.nightPlans)..where(
              (t) =>
                  t.wakeDate.isBiggerOrEqualValue(startDate) &
                  t.wakeDate.isSmallerOrEqualValue(endDate),
            ))
            .get();
    final checkInByDate = {for (final c in checkIns) _dateOnly(c.wakeDate): c};
    final preExamByDate = {
      for (final p in plans) _dateOnly(p.wakeDate): p.isPreExamNight,
    };

    final cells = <HeatmapCell>[];
    for (
      var d = startDate;
      !d.isAfter(endDate);
      d = d.add(const Duration(days: 1))
    ) {
      cells.add(
        HeatmapCell(
          date: d,
          checkIn: checkInByDate[d],
          isPreExamNight: preExamByDate[d] ?? false,
        ),
      );
    }
    return cells;
  }

  StatsSummary summarize(List<HeatmapCell> cells) {
    final withData = cells.where((c) => c.checkIn != null).toList();
    if (withData.isEmpty) return StatsSummary.empty;

    final sleepMinutes = withData
        .map(
          (c) => c.checkIn!.actualWakeAt
              .difference(c.checkIn!.lightsOffAt)
              .inMinutes
              .toDouble(),
        )
        .toList();
    final avgSleep =
        sleepMinutes.reduce((a, b) => a + b) / sleepMinutes.length;

    final completeCount = withData
        .where((c) => c.checkIn!.result == CheckInResultDb.enough)
        .length;

    final lightsOffMinutes = withData
        .map((c) => _continuousLightsOffMinutes(c.date, c.checkIn!.lightsOffAt).toDouble())
        .toList();
    final avgLightsOff =
        lightsOffMinutes.reduce((a, b) => a + b) / lightsOffMinutes.length;
    final meanAbsDeviation =
        lightsOffMinutes
            .map((m) => (m - avgLightsOff).abs())
            .reduce((a, b) => a + b) /
        lightsOffMinutes.length;

    return StatsSummary(
      averageSleepMinutes: avgSleep,
      percentComplete: completeCount / withData.length * 100,
      lightsOffVarianceMinutes: meanAbsDeviation,
      nightsWithData: withData.length,
    );
  }
}
