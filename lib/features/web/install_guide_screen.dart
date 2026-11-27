import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/glow_colors.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_logo.dart';
import '../../theme/widgets/glow_primary_button.dart';

const _steps = [
  (Icons.ios_share, 'กดปุ่มแชร์ใน Safari', GlowPastel.lilac),
  (Icons.add, 'เลือก "เพิ่มไปยังหน้าจอโฮม"', GlowPastel.butter),
  (Icons.check, 'เปิด Glow จากไอคอนบนหน้าจอโฮม', GlowPastel.mint),
];

/// Shown when the web version isn't opened from the home screen.
class InstallGuideScreen extends StatelessWidget {
  final VoidCallback onContinue;

  const InstallGuideScreen({super.key, required this.onContinue});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                children: [
                  Text('ติดตั้ง Glow สำหรับ iOS', style: textTheme.titleMedium),
                  const SizedBox(height: GlowSpacing.xl),
                  const GlowLogo(size: 128),
                  const SizedBox(height: GlowSpacing.lg),
                  Text(
                    'ให้ Glow อยู่ใกล้คุณ',
                    textAlign: TextAlign.center,
                    style: textTheme.titleLarge,
                  ),
                  const SizedBox(height: GlowSpacing.sm),
                  Text(
                    'ติดตั้งลงหน้าจอโฮมก่อน\nไม่งั้นข้อมูลอาจถูกลบเมื่อไม่ได้เปิดนาน',
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium,
                  ),
                  const SizedBox(height: GlowSpacing.xxl),
                  for (final (icon, label, pastel) in _steps) ...[
                    GlowCard(
                      padding: const EdgeInsets.all(GlowSpacing.md),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(GlowSpacing.sm),
                            decoration: BoxDecoration(
                              color: context.glowColors.pastel(pastel),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, size: 20),
                          ),
                          const SizedBox(width: GlowSpacing.md),
                          Expanded(
                            child: Text(label, style: textTheme.bodyLarge),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: GlowSpacing.md),
                  ],
                  const SizedBox(height: GlowSpacing.lg),
                  Text(
                    'บน iPhone ข้อมูลของแอปที่ติดตั้งอาจแยกจากที่ใช้ใน Safari ถ้าใส่ข้อมูลใน '
                    'Safari ไว้แล้ว ให้สำรองเป็นไฟล์ก่อน แล้วนำเข้าในแอปที่ติดตั้ง',
                    style: textTheme.labelSmall,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(GlowSpacing.pageMargin),
              child: GlowPrimaryButton(
                label: 'ใช้ต่อในเบราว์เซอร์',
                onPressed: onContinue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
