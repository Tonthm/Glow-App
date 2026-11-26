import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/birth_date.dart';
import '../../core/card_config.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../card/profile_fields.dart';
import '../settings/battery_optimization_sheet.dart';
import '../shared/minutes_stepper.dart';
import '../shared/time_of_day_field.dart';
import 'welcome_page.dart';

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
        appBar: AppBar(
          title: const Text('อีก 2 ข้อ'),
          leading: BackButton(
            onPressed: () => setState(() => _onWelcome = true),
          ),
        ),
        body: ListView(
          padding: const EdgeInsets.all(GlowSpacing.pageMargin),
          children: [
            Text(
              'ใช้คิดเวลาเข้านอน ที่เหลือตั้งค่าเริ่มต้นให้แล้ว',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: GlowSpacing.lg),
            TimeOfDayField(
              label: 'เรียนเช้าสุดกี่โมง',
              time: _earliestClass,
              onChanged: (v) => setState(() => _earliestClass = v),
            ),
            MinutesStepper(
              label: 'เวลาเดินทางไปเรียน',
              minutes: _travelMinutes,
              step: 5,
              onChanged: (v) => setState(() => _travelMinutes = v),
            ),
            Text(
              'ใช้เวลานี้ในวันจันทร์–ศุกร์ จนกว่าจะใส่ตารางเรียนจริง',
              style: textTheme.bodyMedium,
            ),
            if (ref.watch(platformCapabilitiesProvider).deviceSetupHelp) ...[
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
            const SizedBox(height: GlowSpacing.xl),
            Text(
              'แอปนี้ไม่ใช่คำแนะนำทางการแพทย์ ถ้านอนไม่หลับหรือง่วงมาก'
              'ต่อเนื่องหลายสัปดาห์ ควรปรึกษาแพทย์',
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: GlowSpacing.lg),
            GlowPrimaryButton(
              label: 'เริ่มใช้งาน',
              onPressed: _finishing ? null : _finish,
            ),
          ],
        ),
      ),
    );
  }
}
