import 'package:material_ui/material_ui.dart';

import '../../core/ai_config.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// Shown before AI is first switched on. Pops true if the user agrees.
///
/// The facts about Google's terms were read on 26 Nov 2026. If this text
/// changes, raise [aiConsentVersion].
class AiConsentScreen extends StatelessWidget {
  const AiConsentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    Widget heading(String text) => Padding(
      padding: const EdgeInsets.only(
        top: GlowSpacing.lg,
        bottom: GlowSpacing.xs,
      ),
      child: Text(text, style: textTheme.titleLarge),
    );
    Widget body(String text) => Text(text, style: textTheme.bodyLarge);

    return Scaffold(
      appBar: AppBar(title: const Text('ก่อนเปิดผู้ช่วย AI')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          body(
            'ข้อความงานที่สั่งให้ประมวลผล จะถูกส่งตรงไปที่ $aiProviderName '
            'ด้วย API key ของคุณเอง ไม่ผ่านเซิร์ฟเวอร์ของ Glow',
          ),
          heading('ส่งอะไรบ้าง'),
          body(
            '• ข้อความที่พิมพ์หรือพูดในช่องงาน\n'
            '• ชื่องาน เวลาที่ใส่ไว้ และวันส่ง\n'
            '• วันที่ของวันนี้ (เพื่อแปลคำว่า "พรุ่งนี้")\n'
            '• ตอนกด "ทำไม?": สรุปแผนงานเย็นนี้ เช่น ชื่องาน จำนวนนาที '
            'และว่าพรุ่งนี้มีสอบไหม',
          ),
          heading('ไม่ส่ง'),
          body(
            'เวลานอน ตารางเรียน ประวัติการนอน ไฟ เควส เหรียญ ชื่อ '
            'หรือข้อมูลส่วนตัวอื่น (อย่าพิมพ์ข้อมูลส่วนตัวลงในชื่องาน)',
          ),
          heading('เงื่อนไขของ Google'),
          body(
            '• ผู้ใช้ Gemini API ต้องอายุ 18 ปีขึ้นไป และเงื่อนไขไม่อนุญาตให้ใช้ใน'
            'แอปที่ทำเพื่อ หรือน่าจะถูกใช้โดย ผู้ที่อายุต่ำกว่า 18 ปี\n'
            '• ถ้าใช้แบบฟรี Google อาจนำข้อความที่ส่งและคำตอบไปปรับปรุงบริการ '
            'และอาจมีคนอ่านตรวจ\n'
            '• ถ้าใช้แบบเสียเงิน Google ระบุว่าไม่นำไปปรับปรุงบริการ '
            'แต่เก็บไว้ช่วงหนึ่งเพื่อตรวจการใช้ผิดกฎ\n'
            '• ค่าใช้จ่ายคิดกับบัญชีของคุณเอง',
          ),
          const SizedBox(height: GlowSpacing.xl),
          GlowPrimaryButton(
            label: 'ยอมรับและเปิดใช้',
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยังไม่เปิด'),
          ),
        ],
      ),
    );
  }
}
