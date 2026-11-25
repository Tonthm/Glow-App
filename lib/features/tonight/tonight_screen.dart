import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/economy_config.dart';
import '../../core/night_date.dart';
import '../../core/quests.dart';
import '../../core/schedule_load.dart';
import '../../core/schedule_models.dart';
import '../../core/sleep_calculator.dart';
import '../../data/check_in_repository.dart';
import '../../data/database.dart';
import '../../data/stats_repository.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/night_ring.dart';
import '../../theme/widgets/warning_bar.dart';
import '../shared/settings_button.dart';
import '../stats/heatmap.dart';
import '../stats/night_detail_sheet.dart';
import 'check_in_card.dart';
import 'check_in_result_screen.dart';
import 'fire_badge.dart';

class TonightPlanData {
  final DateTime wakeDate;
  final NightPlanDraft draft;
  final EveningLoadResult load;
  final ({OneTimeItem exam, int daysUntil})? examCountdown;
  final PendingCheckIn? pendingCheckIn;
  final int weeklyOnTimeCount;
  final bool inBed;
  final ScheduleEntry? firstAppointment;
  final List<HeatmapCell> weekCells;

  const TonightPlanData({
    required this.wakeDate,
    required this.draft,
    required this.load,
    required this.examCountdown,
    required this.pendingCheckIn,
    required this.weeklyOnTimeCount,
    required this.inBed,
    required this.firstAppointment,
    required this.weekCells,
  });
}

/// Recomputes whenever schedule or settings change — and, since it's the
/// only place that watches all three, also reschedules local notifications
/// then (CLAUDE.md section 5: "ลบแล้วตั้งใหม่ทั้งชุดเมื่อ...แก้ตารางหรือ
/// ตั้งค่า"). TonightScreen stays mounted under the bottom nav's
/// IndexedStack even when another tab is showing, so this keeps firing
/// regardless of which tab is visible.
final tonightPlanProvider = FutureProvider.autoDispose<TonightPlanData>((
  ref,
) async {
  ref.watch(weeklyItemsStreamProvider);
  ref.watch(oneTimeItemsStreamProvider);
  final settings = ref.watch(settingsStreamProvider).value;
  final repo = ref.watch(nightPlanningRepositoryProvider);
  final now = DateTime.now();

  final fireRepo = ref.watch(fireRepositoryProvider);
  final checkInRepo = ref.watch(checkInRepositoryProvider);
  final questRepo = ref.watch(questRepositoryProvider);
  // This provider can be rebuilt while an earlier run is still going; one
  // transaction keeps the two from applying the same reward or penalty twice.
  await ref.watch(databaseProvider).transaction(() async {
    await repo.lockElapsedNights(now);
    await fireRepo.grantFreeShieldIfNewWeek(now);
    await checkInRepo.sweepMissedNights(now);
    await questRepo.claimWeeklyRewardIfComplete(now);
    await questRepo.claimExamPeriodRewardsIfComplete(now);
  });

  if (settings != null) {
    final notificationService = ref.watch(notificationServiceProvider);
    await notificationService.rescheduleAll(
      repo: repo,
      checkInRepo: ref.watch(checkInRepositoryProvider),
      settings: settings,
      now: now,
    );
    await notificationService.maybeSendRedNightAheadAlert(
      repo: repo,
      enabled: settings.notifyBusyNight,
      now: now,
    );
  }

  final wakeDate = resolveTonightWakeDate(now);
  final draft = await repo.getOrLockPlan(wakeDate, now: now);
  final load = await repo.computeEveningLoad(draft);
  final examCountdown = await repo.nextExamCountdown(now);
  final pendingCheckIn = await ref
      .watch(checkInRepositoryProvider)
      .findPendingCheckIn(now);
  final weeklyOnTimeCount = await questRepo.currentWeekOnTimeCount(now);
  return TonightPlanData(
    wakeDate: wakeDate,
    draft: draft,
    load: load,
    examCountdown: examCountdown,
    pendingCheckIn: pendingCheckIn,
    weeklyOnTimeCount: weeklyOnTimeCount,
    inBed: (await repo.getPlanRow(wakeDate))?.inBedAt != null,
    firstAppointment: await repo.firstAppointment(wakeDate),
    weekCells: await ref
        .watch(statsRepositoryProvider)
        .rangeCells(
          mondayOfWeek(wakeDate),
          mondayOfWeek(wakeDate).add(const Duration(days: 6)),
        ),
  );
});

final _hasAnyScheduleProvider = Provider.autoDispose<bool>((ref) {
  final weekly = ref.watch(weeklyItemsStreamProvider).value ?? [];
  final oneTime = ref.watch(oneTimeItemsStreamProvider).value ?? [];
  return weekly.isNotEmpty || oneTime.isNotEmpty;
});

class TonightScreen extends ConsumerStatefulWidget {
  const TonightScreen({super.key});

  @override
  ConsumerState<TonightScreen> createState() => _TonightScreenState();
}

class _TonightScreenState extends ConsumerState<TonightScreen> {
  bool? _notificationsOk;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    // Coming back from the background counts as opening the app: the day may
    // have changed, and permissions may have been switched off meanwhile.
    _lifecycle = AppLifecycleListener(
      onResume: () {
        ref.invalidate(tonightPlanProvider);
        _checkPermissions();
      },
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    final ok = await ref
        .read(permissionsServiceProvider)
        .hasNotificationsPermission();
    if (mounted) setState(() => _notificationsOk = ok);
  }

  @override
  Widget build(BuildContext context) {
    final hasSchedule = ref.watch(_hasAnyScheduleProvider);
    final planAsync = ref.watch(tonightPlanProvider);

    final plan = hasSchedule ? planAsync.value : null;
    final showBedButton = plan != null && plan.pendingCheckIn == null;

    return Scaffold(
      appBar: AppBar(
        // The one place that uses the wordmark font (THEME.md).
        title: const Text(
          'Glow',
          style: TextStyle(fontFamily: 'Nunito', fontWeight: FontWeight.w800),
        ),
        actions: const [SettingsButton()],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async => ref.invalidate(tonightPlanProvider),
              child: ListView(
                padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                children: [
                  if (_notificationsOk == false)
                    const WarningBar(
                      severity: WarningBarSeverity.red,
                      message:
                          'สิทธิ์แจ้งเตือนถูกปิดอยู่ แจ้งเตือนจะไม่ทำงาน '
                          'เปิดได้ในตั้งค่าเครื่อง',
                    ),
                  if (!hasSchedule) ...[
                    const _EmptyScheduleCard(),
                    const SizedBox(height: GlowSpacing.lg),
                    const FireBadge(),
                  ] else
                    planAsync.when(
                      loading: () => const Padding(
                        padding: EdgeInsets.symmetric(vertical: 48),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      error: (e, _) => Text('เกิดข้อผิดพลาด: $e'),
                      data: _buildPlan,
                    ),
                ],
              ),
            ),
          ),
          if (showBedButton)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                GlowSpacing.pageMargin,
                GlowSpacing.sm,
                GlowSpacing.pageMargin,
                GlowSpacing.md,
              ),
              child: GlowPrimaryButton(
                label: plan.inBed ? 'เข้านอนแล้ว ✓' : 'เข้านอนแล้ว',
                onPressed: plan.inBed ? null : () => _goToBed(plan),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPlan(TonightPlanData plan) {
    final pending = plan.pendingCheckIn;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _WeekRings(cells: plan.weekCells, tonight: plan.wakeDate),
        const SizedBox(height: GlowSpacing.xl),
        if (pending != null)
          CheckInCard(
            pending: pending,
            onSubmitted: (result, fireBefore, fireAfter) {
              ref.invalidate(tonightPlanProvider);
              if (!mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CheckInResultScreen(
                    wakeDate: pending.wakeDate,
                    result: result,
                    fireBefore: fireBefore,
                    fireAfter: fireAfter,
                  ),
                ),
              );
            },
          )
        else
          _PlanContent(plan: plan),
      ],
    );
  }

  Future<void> _goToBed(TonightPlanData plan) async {
    final notifications = ref.read(notificationServiceProvider);
    await ref
        .read(nightPlanningRepositoryProvider)
        .markInBed(plan.wakeDate, DateTime.now());
    await notifications.cancelBedtimeNotification(plan.wakeDate);
    if (!mounted) return;
    ref.invalidate(tonightPlanProvider);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('บันทึกแล้ว ฝันดีนะ')));
  }
}

/// The week's seven nights (THEME.md "วงคืนในสัปดาห์"). Tap one for details.
class _WeekRings extends StatelessWidget {
  final List<HeatmapCell> cells;
  final DateTime tonight;

  const _WeekRings({required this.cells, required this.tonight});

  static const _labels = ['จ', 'อ', 'พ', 'พฤ', 'ศ', 'ส', 'อา'];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final cell in cells)
            NightRing(
              dayLabel: _labels[cell.date.weekday - 1],
              result: toSleepResult(cell.checkIn),
              isTonight: cell.date == tonight,
              onTap: () => showGlowBottomSheet(
                context: context,
                builder: (_) => NightDetailSheet(
                  cell: cell,
                  fallAsleepMinutes:
                      ref
                          .read(settingsStreamProvider)
                          .value
                          ?.fallAsleepMinutes ??
                      15,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyScheduleCard extends ConsumerWidget {
  const _EmptyScheduleCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'ยังไม่มีตารางเรียน ใส่ตารางก่อนเพื่อให้ Glow แนะนำเวลานอนได้',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () =>
                  ref.read(selectedTabIndexProvider.notifier).state = 1,
              child: const Text('ไปตั้งตาราง'),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanContent extends StatelessWidget {
  final TonightPlanData plan;

  const _PlanContent({required this.plan});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final first = plan.firstAppointment;
    final firstLabel = first == null
        ? 'วันว่าง'
        : '${switch (first.kind) {
            ItemKind.exam => 'สอบ',
            ItemKind.classSession => 'เรียนคาบแรก',
            _ => 'นัดแรก',
          }} ${_formatTime(first.start)}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (plan.examCountdown != null) ...[
          _ExamCountdownBanner(plan.examCountdown!),
          const SizedBox(height: GlowSpacing.md),
        ],
        Text('เข้านอนคืนนี้', style: textTheme.bodyMedium),
        const SizedBox(height: GlowSpacing.xs),
        Text(_formatTime(plan.draft.bedtime), style: textTheme.displayLarge),
        const SizedBox(height: GlowSpacing.xs),
        Text(
          'ตื่น ${_formatTime(plan.draft.wakeTime)} · $firstLabel',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: GlowSpacing.xl),
        if (plan.load.level == EveningLoadLevel.yellow)
          WarningBar(
            severity: WarningBarSeverity.yellow,
            message:
                'เย็นนี้แน่น ทำงานให้เสร็จก่อน ${_formatTime(plan.load.notifyTime)}',
          ),
        if (plan.load.level == EveningLoadLevel.red)
          const WarningBar(
            severity: WarningBarSeverity.red,
            message:
                'คืนนั้นนอนครบไม่ได้ตามตาราง ลองย้ายกิจกรรม, '
                'ลดเวลาเตรียมตัววันนั้น, หรือเข้านอนเร็วขึ้นคืนก่อนหน้า',
          ),
        const SizedBox(height: GlowSpacing.lg),
        const FireBadge(),
        const SizedBox(height: GlowSpacing.md),
        Text(
          'เควสวันนี้: นอนครบ +${EconomyConfig.dailyCompleteCoins} เหรียญ '
          '· ตรงเวลา +${EconomyConfig.dailyOnTimeBonusCoins}',
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: GlowSpacing.sm),
        _QuestProgressDots(count: plan.weeklyOnTimeCount),
      ],
    );
  }
}

/// ●●●○○ weekly "ตรงเวลา 5 ใน 7" quest progress (CLAUDE.md section 8).
class _QuestProgressDots extends StatelessWidget {
  final int count;
  const _QuestProgressDots({required this.count});

  @override
  Widget build(BuildContext context) {
    final target = weeklyOnTimeQuestTarget;
    final filled = count.clamp(0, target);
    final accent = Theme.of(context).colorScheme.primary;
    final empty = Theme.of(context).dividerColor;
    return Row(
      children: [
        for (var i = 0; i < target; i++)
          Padding(
            padding: const EdgeInsets.only(right: GlowSpacing.xs),
            child: Icon(
              Icons.circle,
              size: 12,
              color: i < filled ? accent : empty,
            ),
          ),
        const SizedBox(width: GlowSpacing.xs),
        Expanded(
          child: Text(
            'ตรงเวลา $count/$target สัปดาห์นี้',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ),
      ],
    );
  }
}

class _ExamCountdownBanner extends StatelessWidget {
  final ({OneTimeItem exam, int daysUntil}) countdown;
  const _ExamCountdownBanner(this.countdown);

  @override
  Widget build(BuildContext context) {
    final days = countdown.daysUntil;
    final label = days == 0 ? 'วันนี้' : 'อีก $days วัน';
    return Card(
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('สอบ${countdown.exam.title} $label'),
            const SizedBox(height: 4),
            const Text(
              'นอนให้พอช่วยให้จำสิ่งที่อ่านได้ดีขึ้น ไม่ควรโต้รุ่ง',
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

String _formatTime(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
