/// Days left until exams and deadlines, and the line about sleep that goes
/// with them (CLAUDE.md section 14). No line may ever suggest sleeping later
/// or less.
library;

/// How far ahead the home screen counts.
const int countdownDays = 14;
const int maxCountdowns = 3;

enum CountdownKind { exam, deadline }

class CountdownSource {
  final CountdownKind kind;
  final String title;
  final DateTime date;

  /// When an exam with a time is over.
  final DateTime? endsAt;

  const CountdownSource({
    required this.kind,
    required this.title,
    required this.date,
    this.endsAt,
  });
}

class Countdown {
  final CountdownKind kind;
  final String title;
  final int daysLeft;

  const Countdown({
    required this.kind,
    required this.title,
    required this.daysLeft,
  });
}

int _daysBetween(DateTime from, DateTime to) => DateTime.utc(
  to.year,
  to.month,
  to.day,
).difference(DateTime.utc(from.year, from.month, from.day)).inDays;

/// The nearest few: by days left, exams first.
List<Countdown> countdowns(
  List<CountdownSource> sources, {
  required DateTime now,
}) {
  final result = <Countdown>[
    for (final s in sources)
      if (_daysBetween(now, s.date) case final days
          when days >= 0 &&
              days <= countdownDays &&
              (s.endsAt == null || s.endsAt!.isAfter(now)))
        Countdown(kind: s.kind, title: s.title, daysLeft: days),
  ];
  result.sort((a, b) {
    var order = a.daysLeft.compareTo(b.daysLeft);
    if (order == 0) order = a.kind.index.compareTo(b.kind.index);
    return order != 0 ? order : a.title.compareTo(b.title);
  });
  return result.take(maxCountdowns).toList();
}

String daysLeftLabel(int days) => switch (days) {
  0 => 'วันนี้',
  1 => 'พรุ่งนี้',
  _ => 'อีก $days วัน',
};

String sleepReminder(CountdownKind kind, int days) => switch ((kind, days)) {
  (CountdownKind.exam, 0) =>
    'สอบวันนี้ ทำเต็มที่ คืนนี้นอนตามแผนเหมือนเดิม',
  (CountdownKind.exam, 1) =>
    'สอบพรุ่งนี้ คืนนี้นอนตามแผน การนอนช่วยให้จำสิ่งที่อ่านได้',
  (CountdownKind.exam, _) => 'สอบอีก $days วัน เริ่มนอนตามแผนไว้',
  (CountdownKind.deadline, 0) =>
    'ส่งงานวันนี้ ทำเท่าที่ทัน แล้วนอนตามแผน',
  (CountdownKind.deadline, 1) =>
    'ส่งงานพรุ่งนี้ ทำช่วงเย็นแล้วนอนตามแผน',
  (CountdownKind.deadline, _) =>
    'ส่งงานอีก $days วัน แบ่งทำทีละนิด แล้วนอนตามแผน',
};
