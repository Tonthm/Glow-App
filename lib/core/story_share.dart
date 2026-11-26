/// What goes on the picture shared to a story: only numbers, times and dots.
/// There is no name, photo or school here, so none can end up in it.
library;

import 'check_in.dart';

/// The last night, the last 7, or the last 30. These are rolling windows that
/// end at the newest recorded night, not calendar weeks or months.
enum StoryView {
  night(1),
  week(7),
  month(30);

  final int nights;
  const StoryView(this.nights);
}

/// One night's dot. Each is also a different shape, not only a color.
enum StoryDot {
  /// Slept enough.
  full,

  /// Short by no more than [slightlyShortMinutes].
  slightlyShort,

  /// Short by more.
  veryShort,

  /// Nothing recorded.
  none,
}

/// Which dot each check-in verdict gets. The verdict is the one saved at
/// check-in ([classifyCheckIn]); nothing is judged a second time here.
/// "Over" lost no sleep, so it is a full dot.
const Map<CheckInResult, StoryDot> storyDotByResult = {
  CheckInResult.enough: StoryDot.full,
  CheckInResult.over: StoryDot.full,
  CheckInResult.almostEnough: StoryDot.slightlyShort,
  CheckInResult.notEnough: StoryDot.veryShort,
};

StoryDot storyDotFor(CheckInResult? result) =>
    result == null ? StoryDot.none : storyDotByResult[result]!;

/// A recorded night.
class StoryNight {
  final DateTime wakeDate;
  final DateTime lightsOffAt;
  final DateTime wakeAt;
  final CheckInResult result;

  const StoryNight({
    required this.wakeDate,
    required this.lightsOffAt,
    required this.wakeAt,
    required this.result,
  });
}

class StoryCell {
  final DateTime wakeDate;
  final StoryDot dot;

  const StoryCell(this.wakeDate, this.dot);
}

class StorySummary {
  final StoryView view;

  /// One per night of the window, oldest first.
  final List<StoryCell> cells;
  final int nightsWithData;

  /// Averages over the recorded nights only. Null with none.
  final Duration? sleep;

  /// Minutes since midnight.
  final int? bedMinutes;
  final int? wakeMinutes;

  const StorySummary({
    required this.view,
    required this.cells,
    required this.nightsWithData,
    this.sleep,
    this.bedMinutes,
    this.wakeMinutes,
  });

  bool get canShare => nightsWithData > 0;
  bool get isIncomplete => nightsWithData < view.nights;

  /// Shown when some nights of the window have no data.
  String? get missingNote =>
      canShare && isIncomplete ? 'จาก $nightsWithData คืน' : null;
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _addDays(DateTime d, int days) =>
    DateTime(d.year, d.month, d.day + days);

/// Clock time as minutes from the midnight that starts [wakeDate], so 23:30
/// the evening before is -30 and 00:30 is 30. Averaging these can't land on
/// noon the way averaging clock readings would.
int _fromWakeMidnight(DateTime wakeDate, DateTime time) {
  // Counted in UTC so a clock change can't add or lose an hour.
  final days = DateTime.utc(time.year, time.month, time.day)
      .difference(DateTime.utc(wakeDate.year, wakeDate.month, wakeDate.day))
      .inDays;
  return days * 24 * 60 + time.hour * 60 + time.minute;
}

/// A half rounds up, before midnight (negative here) as well as after.
int _average(Iterable<int> values) =>
    (values.reduce((a, b) => a + b) / values.length + 0.5).floor();

int _clockOfDay(int minutes) => minutes % (24 * 60);

StorySummary buildStory(
  Iterable<StoryNight> nights,
  StoryView view, {
  required DateTime now,
  required int fallAsleepMinutes,
}) {
  final today = _dateOnly(now);
  final byDate = {
    for (final n in nights)
      if (!_dateOnly(n.wakeDate).isAfter(today)) _dateOnly(n.wakeDate): n,
  };
  var end = today;
  if (byDate.isNotEmpty) {
    end = byDate.keys.reduce((a, b) => a.isAfter(b) ? a : b);
  }

  final cells = <StoryCell>[];
  final recorded = <StoryNight>[];
  for (var i = view.nights - 1; i >= 0; i--) {
    final date = _addDays(end, -i);
    final found = byDate[date];
    if (found != null) recorded.add(found);
    cells.add(StoryCell(date, storyDotFor(found?.result)));
  }

  if (recorded.isEmpty) {
    return StorySummary(view: view, cells: cells, nightsWithData: 0);
  }
  final sleepMinutes = _average(
    recorded.map(
      (n) => actualSleepDuration(
        lightsOffAt: n.lightsOffAt,
        wakeAt: n.wakeAt,
        fallAsleepMinutes: fallAsleepMinutes,
      ).inMinutes,
    ),
  );
  return StorySummary(
    view: view,
    cells: cells,
    nightsWithData: recorded.length,
    sleep: Duration(minutes: sleepMinutes),
    bedMinutes: _clockOfDay(
      _average(
        recorded.map(
          (n) => _fromWakeMidnight(_dateOnly(n.wakeDate), n.lightsOffAt),
        ),
      ),
    ),
    wakeMinutes: _clockOfDay(
      _average(
        recorded.map(
          (n) => _fromWakeMidnight(_dateOnly(n.wakeDate), n.wakeAt),
        ),
      ),
    ),
  );
}

(int hours, int minutes) storyDuration(Duration d) =>
    (d.inHours, d.inMinutes % 60);

String storyClock(int minutes) =>
    '${(minutes ~/ 60).toString().padLeft(2, '0')}:'
    '${(minutes % 60).toString().padLeft(2, '0')}';

const _dayLetters = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

String storyDayLetter(DateTime date) => _dayLetters[date.weekday - 1];
