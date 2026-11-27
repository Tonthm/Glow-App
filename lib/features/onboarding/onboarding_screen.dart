import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/birth_date.dart';
import '../../core/card_config.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/glow_colors.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../card/profile_fields.dart';
import '../settings/battery_optimization_sheet.dart';
import '../shared/minutes_stepper.dart';
import '../shared/time_of_day_field.dart';
import 'welcome_page.dart';
import 'onboarding_header.dart';

/// First the card (skippable), then only what the sleep time needs. Everything
/// else starts at its default and can be changed in settings.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _input = ProfileInput();
  Uint8List? _photo;
  String? _nameError;
  String? _birthDateError;
  DateTime? _birthDate;
  bool _skippedProfile = false;
  bool _onWelcome = true;

  TimeOfDay _earliestClass = const TimeOfDay(hour: 8, minute: 0);
  int _travelMinutes = 30;
  bool _notificationsRequested = false;
  bool _finishing = false;

  @override
  void dispose() {
    _input.dispose();
    super.dispose();
  }

  void _next() {
    final birth = parseBirthDate(
      _input.birthDate.text,
      now: ref.read(clockProvider)(),
    );
    final noName = _input.name.text.trim().isEmpty;
    setState(() {
      _nameError = noName ? 'ใส่ชื่อก่อน หรือกด "ข้าม"' : null;
      _birthDateError = birth.problem == null
          ? null
          : birthDateProblemMessage(birth.problem!);
      if (noName || birth.problem != null) return;
      _birthDate = birth.date;
      _skippedProfile = false;
      _onWelcome = false;
    });
  }

  void _skip() => setState(() {
    _skippedProfile = true;
    _onWelcome = false;
  });

  Future<void> _requestNotifications() async {
    final permissions = ref.read(permissionsServiceProvider);
    final granted = await permissions.requestNotifications();
    await permissions.requestExactAlarms();
    if (mounted) setState(() => _notificationsRequested = granted);
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);
    final settings = ref.read(settingsRepositoryProvider);
    final cards = ref.read(cardRepositoryProvider);
    final now = ref.read(clockProvider)();

    await settings.ensureRowExists();
    await settings.updatePrepAndTravel(travelMinutes: _travelMinutes);
    await settings.updateEarliestClass(
      _earliestClass.hour * 60 + _earliestClass.minute,
    );
    if (!_skippedProfile) {
      await cards.saveDetails(
        displayName: _input.name.text,
        school: _input.school.text,
        classYear: _input.classYear.text,
        avatarId: defaultAvatarId,
      );
      await cards.setBirthDate(_birthDate, now: now);
      if (_photo != null) await cards.savePhoto(_photo!);
    }
    // Section 1: onboarding ends with entering the first schedule.
    ref.read(selectedTabIndexProvider.notifier).state = 1;
    // The short tour comes first (section 21).
    await ref.read(guideRepositoryProvider).setTourPending(true);
    await settings.markOnboardingCompleted(now);
  }

  @override
  Widget build(BuildContext context) {
    if (_onWelcome) {
      return WelcomePage(
        input: _input,
        nameError: _nameError,
        birthDateError: _birthDateError,
        photo: _photo,
        onPhotoChanged: (jpeg) async => setState(() => _photo = jpeg),
        onNext: _next,
        onSkip: _skip,
      );
    }
    final textTheme = Theme.of(context).textTheme;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) setState(() => _onWelcome = true);
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                  children: [
                    const OnboardingHeader(step: 2),
                    Text('อีก 2 ข้อ ก็พร้อมแล้ว', style: textTheme.titleLarge),
                    const SizedBox(height: GlowSpacing.sm),
                    Text(
                      'ใช้คิดเวลาเข้านอน ที่เหลือตั้งค่าเริ่มต้นให้แล้ว',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: GlowSpacing.xxl),
                    _SetupValueCard(
                      label: 'เรียนเช้าสุดกี่โมง',
                      value: formatTimeOfDay(_earliestClass),
                      pastel: GlowPastel.sky,
                      onMinus: () => setState(
                        () =>
                            _earliestClass = stepTimeOfDay(_earliestClass, -5),
                      ),
                      onPlus: () => setState(
                        () => _earliestClass = stepTimeOfDay(_earliestClass, 5),
                      ),
                      onPick: () async {
                        final picked = await showTimeWheel(
                          context,
                          title: 'เรียนเช้าสุดกี่โมง',
                          initial: _earliestClass,
                        );
                        if (picked != null && mounted) {
                          setState(() => _earliestClass = picked);
                        }
                      },
                    ),
                    const SizedBox(height: GlowSpacing.lg),
                    _SetupValueCard(
                      label: 'เวลาเดินทางไปเรียน',
                      value: formatMinutesAsHours(_travelMinutes),
                      pastel: GlowPastel.mint,
                      onMinus: _travelMinutes < 5
                          ? null
                          : () => setState(() => _travelMinutes -= 5),
                      onPlus: () => setState(() => _travelMinutes += 5),
                    ),
                    const SizedBox(height: GlowSpacing.lg),
                    Text(
                      'ใช้เวลานี้ในวันจันทร์–ศุกร์ จนกว่าจะใส่ตารางเรียนจริง',
                      style: textTheme.bodyMedium,
                    ),
                    if (ref
                        .watch(platformCapabilitiesProvider)
                        .deviceSetupHelp) ...[
                      const Divider(height: GlowSpacing.xxl),
                      OutlinedButton(
                        onPressed: _notificationsRequested
                            ? null
                            : _requestNotifications,
                        child: Text(
                          _notificationsRequested
                              ? 'ขอสิทธิ์แจ้งเตือนแล้ว'
                              : 'ขอสิทธิ์แจ้งเตือน',
                        ),
                      ),
                      const SizedBox(height: GlowSpacing.sm),
                      OutlinedButton(
                        onPressed: () => showBatteryOptimizationSheet(context),
                        child: const Text('ปิดการประหยัดแบตให้ Glow'),
                      ),
                    ],
                    const SizedBox(height: GlowSpacing.xxl),
                    GlowCard(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.nightlight_outlined, size: 22),
                          const SizedBox(width: GlowSpacing.md),
                          Expanded(
                            child: Text(
                              'แอปนี้ไม่ใช่คำแนะนำทางการแพทย์ ถ้านอนไม่หลับหรือง่วงมาก'
                              'ต่อเนื่องหลายสัปดาห์ ควรปรึกษาแพทย์',
                              style: textTheme.bodyMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GlowPrimaryButton(
                      label: 'เริ่มใช้งาน',
                      onPressed: _finishing ? null : _finish,
                    ),
                    BackButton(
                      onPressed: () => setState(() => _onWelcome = true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SetupValueCard extends StatelessWidget {
  final String label;
  final String value;
  final GlowPastel pastel;
  final VoidCallback? onMinus;
  final VoidCallback onPlus;
  final VoidCallback? onPick;

  const _SetupValueCard({
    required this.label,
    required this.value,
    required this.pastel,
    required this.onMinus,
    required this.onPlus,
    this.onPick,
  });

  @override
  Widget build(BuildContext context) => GlowCard(
    pastel: pastel,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: GlowSpacing.md),
        Row(
          children: [
            IconButton(
              tooltip: 'ลด $label 5 นาที',
              onPressed: onMinus,
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: TextButton(
                onPressed: onPick,
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  disabledForegroundColor: Theme.of(context)
                      .colorScheme
                      .onSurface,
                ),
                child: Text(
                  value,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            IconButton(
              tooltip: 'เพิ่ม $label 5 นาที',
              onPressed: onPlus,
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ],
    ),
  );
}
