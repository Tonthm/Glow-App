import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/night_date.dart';
import '../../core/schedule_load.dart';
import '../../core/sleep_calculator.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/warning_bar.dart';
import '../shared/settings_button.dart';

class TonightPlanData {
  final DateTime wakeDate;
  final NightPlanDraft draft;
  final EveningLoadResult load;
  final ({OneTimeItem exam, int daysUntil})? examCountdown;

  const TonightPlanData({
    required this.wakeDate,
    required this.draft,
    required this.load,
    required this.examCountdown,
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

  if (settings != null) {
    final notificationService = ref.watch(notificationServiceProvider);
    await notificationService.rescheduleAll(
      repo: repo,
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
  return TonightPlanData(
    wakeDate: wakeDate,
    draft: draft,
    load: load,
    examCountdown: examCountdown,
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
  bool _checkedIn = false;
  bool? _notificationsOk;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    final ok = await ref.read(permissionsServiceProvider).hasNotificationsPermission();
    if (mounted) setState(() => _notificationsOk = ok);
  }

  @override
  Widget build(BuildContext context) {
    final hasSchedule = ref.watch(_hasAnyScheduleProvider);
    final planAsync = ref.watch(tonightPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('คืนนี้'),
        actions: const [SettingsButton()],
      ),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(tonightPlanProvider),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_notificationsOk == false) const _PermissionWarningBanner(),
            if (!hasSchedule) const _EmptyScheduleCard(),
            if (hasSchedule)
              planAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Text('เกิดข้อผิดพลาด: $e'),
                data: (plan) => _PlanContent(
                  plan: plan,
                  checkedIn: _checkedIn,
                  onCheckIn: () async {
                    await ref
                        .read(notificationServiceProvider)
                        .cancelBedtimeNotification(plan.wakeDate);
                    setState(() => _checkedIn = true);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('บันทึกแล้ว ฝันดีนะ')),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _PermissionWarningBanner extends StatelessWidget {
  const _PermissionWarningBanner();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.errorContainer,
      child: const Padding(
        padding: EdgeInsets.all(12),
        child: Text('สิทธิ์แจ้งเตือนถูกปิดอยู่ แจ้งเตือนจะไม่ทำงาน ไปเปิดในตั้งค่าเครื่องได้'),
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
            const Text('ยังไม่มีตารางเรียน ใส่ตารางก่อนเพื่อให้ Glow แนะนำเวลานอนได้'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => ref.read(selectedTabIndexProvider.notifier).state = 1,
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
  final bool checkedIn;
  final VoidCallback onCheckIn;

  const _PlanContent({
    required this.plan,
    required this.checkedIn,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final duration = plan.draft.wakeTime.difference(plan.draft.bedtime);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (plan.examCountdown != null) _ExamCountdownBanner(plan.examCountdown!),
        const SizedBox(height: GlowSpacing.md),
        Text('เข้านอนคืนนี้', style: textTheme.bodyMedium),
        const SizedBox(height: GlowSpacing.xs),
        Text(_formatTime(plan.draft.bedtime), style: textTheme.displayLarge),
        const SizedBox(height: GlowSpacing.xs),
        Text(
          'ตื่น ${_formatTime(plan.draft.wakeTime)} '
          '· รวม ${duration.inHours} ชม. ${duration.inMinutes % 60} นาที',
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
            message: 'คืนนั้นนอนครบไม่ได้ตามตาราง ลองย้ายกิจกรรม, '
                'ลดเวลาเตรียมตัววันนั้น, หรือเข้านอนเร็วขึ้นคืนก่อนหน้า',
          ),
        const SizedBox(height: GlowSpacing.xl),
        GlowPrimaryButton(
          label: checkedIn ? 'เข้านอนแล้ว ✓' : 'เข้านอนแล้ว',
          onPressed: checkedIn ? null : onCheckIn,
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
