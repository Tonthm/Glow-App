import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/database.dart';
import '../../providers.dart';
import '../shared/minutes_stepper.dart';
import 'intro_page.dart';
import '../settings/battery_optimization_sheet.dart';
import '../../services/app_clock.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  AgeGroup _ageGroup = AgeGroup.under18;
  int _targetMinMinutes = 8 * 60;
  int _targetMaxMinutes = 10 * 60;
  int _prepMinutes = 45;
  int _travelMinutes = 30;
  TimeOfDay _freeDayWake = const TimeOfDay(hour: 7, minute: 30);
  bool _notificationsRequested = false;
  bool _showIntro = true;

  void _onAgeGroupChanged(AgeGroup group) {
    setState(() {
      _ageGroup = group;
      if (group == AgeGroup.under18) {
        _targetMinMinutes = 8 * 60;
        _targetMaxMinutes = 10 * 60;
      } else {
        _targetMinMinutes = 7 * 60;
        _targetMaxMinutes = 9 * 60;
      }
    });
  }

  Future<void> _requestNotifications() async {
    final granted = await ref
        .read(permissionsServiceProvider)
        .requestNotifications();
    await ref.read(permissionsServiceProvider).requestExactAlarms();
    setState(() => _notificationsRequested = granted);
  }

  Future<void> _finish() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    await settingsRepo.applyAgeGroupDefaults(_ageGroup);
    await settingsRepo.updateTargetHours(
      minMinutes: _targetMinMinutes,
      maxMinutes: _targetMaxMinutes,
    );
    await settingsRepo.updatePrepAndTravel(
      prepMinutes: _prepMinutes,
      travelMinutes: _travelMinutes,
    );
    await settingsRepo.updateFreeDayWakeMinutes(
      _freeDayWake.hour * 60 + _freeDayWake.minute,
    );
    // Section 1: onboarding ends with entering the first schedule.
    ref.read(selectedTabIndexProvider.notifier).state = 1;
    await settingsRepo.markOnboardingCompleted(ref.read(clockProvider)());
  }

  @override
  Widget build(BuildContext context) {
    if (_showIntro) {
      return IntroPage(onStart: () => setState(() => _showIntro = false));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('ยินดีต้อนรับสู่ Glow')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Glow ช่วยวางแผนเวลาเข้านอนจากตารางเรียนของคุณ '
                'แอปนี้ไม่ใช่คำแนะนำทางการแพทย์ ถ้านอนไม่หลับหรือง่วงมากต่อเนื่อง'
                'หลายสัปดาห์ ควรปรึกษาแพทย์',
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('ช่วงอายุ', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioGroup<AgeGroup>(
            groupValue: _ageGroup,
            onChanged: (v) => _onAgeGroupChanged(v!),
            child: const Column(
              children: [
                RadioListTile<AgeGroup>(
                  title: Text('ต่ำกว่า 18 ปี'),
                  value: AgeGroup.under18,
                ),
                RadioListTile<AgeGroup>(
                  title: Text('18 ปีขึ้นไป'),
                  value: AgeGroup.adult,
                ),
              ],
            ),
          ),
          const Divider(height: 32),
          Text(
            'เป้าชั่วโมงนอน: ${formatMinutesAsHours(_targetMinMinutes)} - ${formatMinutesAsHours(_targetMaxMinutes)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          MinutesStepper(
            label: 'ต่ำสุด',
            minutes: _targetMinMinutes,
            step: 15,
            onChanged: (v) => setState(() => _targetMinMinutes = v),
          ),
          MinutesStepper(
            label: 'สูงสุด',
            minutes: _targetMaxMinutes,
            step: 15,
            onChanged: (v) => setState(() => _targetMaxMinutes = v),
          ),
          const Divider(height: 32),
          const Text(
            'เวลาเตรียมตัวและเดินทาง',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          MinutesStepper(
            label: 'เวลาเตรียมตัว',
            minutes: _prepMinutes,
            step: 5,
            onChanged: (v) => setState(() => _prepMinutes = v),
          ),
          MinutesStepper(
            label: 'เวลาเดินทาง',
            minutes: _travelMinutes,
            step: 5,
            onChanged: (v) => setState(() => _travelMinutes = v),
          ),
          const Divider(height: 32),
          const Text(
            'เวลาตื่นวันว่าง (วันที่ไม่มีนัดตอนเช้า)',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text(_freeDayWake.format(context)),
            trailing: const Icon(Icons.access_time),
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: _freeDayWake,
              );
              if (picked != null) setState(() => _freeDayWake = picked);
            },
          ),
          const Divider(height: 32),
          const Text(
            'การแจ้งเตือน',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          FilledButton.tonal(
            onPressed: _notificationsRequested ? null : _requestNotifications,
            child: Text(
              _notificationsRequested
                  ? 'ขอสิทธิ์แจ้งเตือนแล้ว'
                  : 'ขอสิทธิ์แจ้งเตือน',
            ),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => showBatteryOptimizationSheet(context),
            child: const Text('ปิดการประหยัดแบตให้ Glow'),
          ),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () async {
              await _finish();
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text('เริ่มใช้งาน'),
            ),
          ),
        ],
      ),
    );
  }
}
