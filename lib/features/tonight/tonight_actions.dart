/// Tonight's three actions, shared by the sleep tab and the guide. They take
/// a context rather than a widget's ref, so they still work after the page
/// that asked has closed.
library;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/bed_press.dart';
import '../../core/routine_builder.dart';
import '../../core/routine_config.dart';
import '../../data/night_planning_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../evening/evening_screen.dart';
import '../routine/routine_screen.dart';
import 'tonight_screen.dart';

/// True after the app is (re)opened, until answered. Pressing "เข้านอนแล้ว"
/// during this visit doesn't count as coming back.
final justOpenedProvider = StateProvider<bool>((ref) => true);

bool canPressInBedAt(DateTime now, TonightPlanData plan) => canPressInBed(
  now: now,
  notifyTime: NightPlanningRepository.notifyTimeOf(plan.draft),
  plannedWakeTime: plan.draft.wakeTime,
);

/// [picked] is the activity chips as they are on screen, if changed.
List<Pose> routineFor(TonightPlanData plan, {Set<DayActivityKind>? picked}) =>
    buildRoutine(
      wakeDate: plan.wakeDate,
      activities: picked ?? plan.activities,
      mode: plan.mode,
      hiddenPoseIds: plan.hiddenPoseIds,
    );

Future<void> goToBed(BuildContext context, TonightPlanData plan) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final messenger = ScaffoldMessenger.of(context);
  container.read(justOpenedProvider.notifier).state = false;
  final notifications = container.read(notificationServiceProvider);
  HapticFeedback.lightImpact();
  await container
      .read(nightPlanningRepositoryProvider)
      .markInBed(plan.wakeDate, container.read(clockProvider)());
  await notifications.cancelBedtimeNotification(plan.wakeDate);
  container.invalidate(tonightPlanProvider);
  messenger.showSnackBar(const SnackBar(content: Text('บันทึกแล้ว ฝันดีนะ')));
}

Future<void> startRoutine(
  BuildContext context,
  TonightPlanData plan, {
  Set<DayActivityKind>? picked,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final navigator = Navigator.of(context);
  // Starting settles what today involved.
  await container
      .read(routineRepositoryProvider)
      .saveActivities(
        plan.wakeDate,
        picked ?? plan.activities,
        confirmed: true,
      );
  if (!navigator.mounted) return;
  await navigator.push(
    MaterialPageRoute<void>(
      builder: (_) => RoutineScreen(
        wakeDate: plan.wakeDate,
        poses: routineFor(plan, picked: picked),
        mode: plan.mode,
        onInBed:
            plan.inBedAt == null &&
                canPressInBedAt(container.read(clockProvider)(), plan)
            // The navigator outlives whichever page asked.
            ? () => goToBed(navigator.context, plan)
            : null,
      ),
    ),
  );
  if (navigator.mounted) container.invalidate(tonightPlanProvider);
}

Future<void> openEvening(
  BuildContext context,
  TonightPlanData plan, {
  Set<DayActivityKind>? picked,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final navigator = Navigator.of(context);
  await navigator.push(
    MaterialPageRoute<void>(
      builder: (_) => EveningScreen(
        onStartRoutine: plan.routineEnabled && plan.inBedAt == null
            ? () => startRoutine(navigator.context, plan, picked: picked)
            : null,
      ),
    ),
  );
  if (navigator.mounted) container.invalidate(tonightPlanProvider);
}
