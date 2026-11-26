import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';

const _steps = [
  (Icons.ios_share, 'กดปุ่มแชร์ใน Safari'),
  (Icons.add_box_outlined, 'เลือก "เพิ่มไปยังหน้าจอโฮม"'),
  (Icons.touch_app_outlined, 'เปิด Glow จากไอคอนบนหน้าจอโฮม'),
];

/// Shown when the web version isn't opened from the home screen.
class InstallGuideScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const InstallGuideScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ติดตั้ง Glow')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          Text(
            'ติดตั้งลงหน้าจอโฮมก่อน ไม่งั้นข้อมูลอาจถูกลบเมื่อไม่ได้เปิดนาน',
            style: textTheme.titleLarge,
          ),
          const SizedBox(height: GlowSpacing.lg),
          for (var i = 0; i < _steps.length; i++)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(_steps[i].$1),
              title: Text('${i + 1}. ${_steps[i].$2}'),
            ),
          const SizedBox(height: GlowSpacing.md),
          Text(
            'บน iPhone ข้อมูลของแอปที่ติดตั้งอาจแยกจากที่ใช้ใน Safari ถ้าใส่ข้อมูลใน '
            'Safari ไว้แล้ว ให้สำรองเป็นไฟล์ก่อน แล้วนำเข้าในแอปที่ติดตั้ง',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: GlowSpacing.xl),
          GlowPrimaryButton(
            label: 'ใช้ต่อในเบราว์เซอร์',
            onPressed: onContinue,
          ),
        ],
      ),
    );
  }
}
