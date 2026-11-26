/// Why tonight's plan looks the way it does (CLAUDE.md section 16, job 4).
/// Every fact has a ready-made Thai sentence. Those sentences are what the AI
/// may summarise, and what is shown when AI is off or its summary fails the
/// check.
///
/// No fact holds a clock time: the phone-down time comes from the sleep plan,
/// which never leaves the phone. Timetable names are left out too.
library;

import 'evening_planner.dart';

/// In the order they matter; the template shows the first few.
enum EveningFactKind {
  overflow,
  redNightPostponed,
  examTomorrow,
  userOrdered,
  dueFirst,
  allFit,
  carriedOver,
  totalWork,
  nothingToDo,
}

const int _templateFacts = 3;

class EveningFact {
  final EveningFactKind kind;
  final String? task;
  final String? otherTask;
  final int? minutes;
  final int? count;

  const EveningFact(
    this.kind, {
    this.task,
    this.otherTask,
    this.minutes,
    this.count,
  });

  String get sentence => switch (kind) {
    EveningFactKind.overflow =>
      'งาน "$task" ยังเกินเวลาอยู่ $minutes นาที เลือกเลื่อน ลดเวลา '
          'หรือเอาออกได้',
    EveningFactKind.redNightPostponed =>
      'คืนนี้เวลาน้อย เลยเลื่อนงานที่รอได้ $count งาน',
    EveningFactKind.examTomorrow => 'พรุ่งนี้มีสอบ',
    EveningFactKind.userOrdered => 'ลำดับงานเป็นไปตามที่จัดไว้เอง',
    EveningFactKind.dueFirst =>
      'งาน "$task" อยู่ก่อน "$otherTask" เพราะต้องส่งก่อน',
    EveningFactKind.allFit => 'งานทั้งหมดวางลงในเย็นนี้ได้พอดี',
    EveningFactKind.carriedOver => 'มีงานที่เลื่อนมาจากวันก่อน $count งาน',
    EveningFactKind.totalWork => 'คืนนี้วางงานไว้รวม $minutes นาที',
    EveningFactKind.nothingToDo => 'คืนนี้ยังไม่มีงานให้วาง',
  };
}

/// [tasks] are tonight's unfinished tasks in planning order.
List<EveningFact> buildEveningFacts({
  required EveningPlan plan,
  required List<PlannerTask> tasks,
  required DateTime eveningDate,
  required bool redNight,
  required bool examTomorrow,
  int carriedCount = 0,
}) {
  final byId = {for (final t in tasks) t.id: t};
  final facts = <EveningFact>[
    for (final entry in plan.overflow.entries)
      if (byId[entry.key] case final task?)
        EveningFact(
          EveningFactKind.overflow,
          task: task.title,
          minutes: entry.value,
        ),
    if (redNight && plan.postponedForRedNight.isNotEmpty)
      EveningFact(
        EveningFactKind.redNightPostponed,
        count: plan.postponedForRedNight.length,
      ),
    if (examTomorrow) const EveningFact(EveningFactKind.examTomorrow),
  ];

  final planned = [
    for (final task in tasks)
      if (!plan.postponedForRedNight.contains(task.id)) task,
  ];
  if (planned.any((t) => t.userOrder != null)) {
    facts.add(const EveningFact(EveningFactKind.userOrdered));
  } else {
    for (var i = 0; i + 1 < planned.length; i++) {
      final first = planned[i];
      final second = planned[i + 1];
      if (first.due == null) continue;
      if (second.due == null || first.due!.isBefore(second.due!)) {
        facts.add(
          EveningFact(
            EveningFactKind.dueFirst,
            task: first.title,
            otherTask: second.title,
          ),
        );
        break;
      }
    }
  }

  final worked = plan.blocks
      .where((b) => b.kind == BlockKind.task)
      .fold(0, (sum, b) => sum + b.minutes);
  if (worked > 0 &&
      plan.overflow.isEmpty &&
      plan.postponedForRedNight.isEmpty) {
    facts.add(const EveningFact(EveningFactKind.allFit));
  }
  if (carriedCount > 0) {
    facts.add(EveningFact(EveningFactKind.carriedOver, count: carriedCount));
  }
  if (worked > 0) {
    facts.add(EveningFact(EveningFactKind.totalWork, minutes: worked));
  }
  if (tasks.isEmpty) facts.add(const EveningFact(EveningFactKind.nothingToDo));

  facts.sort((a, b) => a.kind.index.compareTo(b.kind.index));
  return facts;
}

/// The explanation that needs no AI.
String templateExplanation(List<EveningFact> facts) =>
    facts.take(_templateFacts).map((f) => f.sentence).join('\n');
