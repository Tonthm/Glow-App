import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_logo.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// The very first screen: what makes Glow different, readable in five
/// seconds.
class IntroPage extends StatelessWidget {
  final VoidCallback onStart;

  const IntroPage({super.key, required this.onStart});

  static const headline = 'ใส่ตารางเรียน 2 นาที แล้วรู้เวลานอนทั้งสัปดาห์';

  static const _points = [
    (Icons.calendar_today_outlined, 'เวลานอนคิดจากตารางเรียนจริง'),
    (Icons.favorite_border, 'วันที่ตารางแน่น เควสลดลง ไม่ลงโทษ'),
    (Icons.self_improvement, 'ท่ายืดก่อนนอนตามสิ่งที่ทำมาวันนี้'),
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(GlowSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const GlowLogo(size: 112),
                        const SizedBox(height: GlowSpacing.lg),
                        Text(
                          headline,
                          textAlign: TextAlign.center,
                          style: textTheme.headlineLarge,
                        ),
                        const SizedBox(height: GlowSpacing.xl),
                        for (final (icon, text) in _points)
                          ListTile(leading: Icon(icon), title: Text(text)),
                      ],
                    ),
                  ),
                ),
              ),
              GlowPrimaryButton(label: 'เริ่มเลย', onPressed: onStart),
            ],
          ),
        ),
      ),
    );
  }
}
