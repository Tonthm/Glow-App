import 'package:material_ui/material_ui.dart';

import '../../core/ai_config.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// The separate agreement before the first picture is ever sent. Pops true if
/// the user agrees. If this text changes, raise [aiImageConsentVersion].
class AiImageConsentScreen extends StatelessWidget {
  const AiImageConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('ก่อนส่งรูป')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          Text(
            '• รูปตารางเรียนที่คุณเลือก (หลังครอบตัด) จะถูกส่งตรงไปที่ '
            '$aiProviderName ด้วย API key ของคุณ\n'
            '• ทุกอย่างที่เห็นในรูปจะถูกส่งไปด้วย รวมชื่อ รหัสนักเรียน '
            'หรือรูปคน ถ้าไม่ครอบตัดออก\n'
            '• ถ้าใช้ Gemini แบบฟรี Google อาจนำรูปและคำตอบไปปรับปรุง'
            'บริการ และอาจมีคนอ่านตรวจ\n'
            '• Glow ไม่เก็บรูปนี้ไว้หลังอ่านเสร็จ และไม่บันทึกคำตอบดิบ\n'
            '• ผู้ใช้ต้องอายุ 18 ปีขึ้นไป',
            style: textTheme.bodyLarge,
          ),
          const SizedBox(height: GlowSpacing.xl),
          GlowPrimaryButton(
            label: 'ยอมรับให้ส่งรูป',
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ไม่ยอมรับ'),
          ),
        ],
      ),
    );
  }
}
