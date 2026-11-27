/// Every word of the guide, the tour, the checklist, the (i) buttons and
/// "รู้จักการนอน" (CLAUDE.md section 21). Edit the text here; the screens only
/// lay it out.
library;

import 'package:material_ui/material_ui.dart';

import '../../core/guide.dart';

enum GuideGroup {
  sleep('นอน'),
  schedule('ตาราง'),
  tasks('งาน'),
  game('เกมและบัตร'),
  share('แชร์'),
  ai('ผู้ช่วย AI'),
  data('ข้อมูล');

  final String title;

  const GuideGroup(this.title);
}

class GuideEntry {
  final GuideGroup group;
  final IconData icon;
  final String title;

  /// At most two short lines.
  final String description;
  final Destination destination;

  /// Shown only with a working mic (true), only without one (false), or
  /// either way (null).
  final bool? mic;

  const GuideEntry({
    required this.group,
    required this.icon,
    required this.title,
    required this.description,
    required this.destination,
    this.mic,
  });
}

const guideEntries = [
  GuideEntry(
    group: GuideGroup.sleep,
    icon: Icons.bedtime_outlined,
    title: 'แผนคืนนี้',
    description: 'เวลาเข้านอน เวลาตื่น และปุ่มเข้านอนแล้ว',
    destination: Destination.sleep,
  ),
  GuideEntry(
    group: GuideGroup.sleep,
    icon: Icons.self_improvement,
    title: 'ท่าก่อนนอน',
    description: 'ยืดเบา ๆ และหายใจช้า เลือกท่าจากสิ่งที่ทำวันนี้',
    destination: Destination.routine,
  ),
  GuideEntry(
    group: GuideGroup.sleep,
    icon: Icons.bar_chart_outlined,
    title: 'สถิติการนอน',
    description: 'ดูย้อนหลังว่าแต่ละคืนนอนครบไหม',
    destination: Destination.stats,
  ),
  GuideEntry(
    group: GuideGroup.schedule,
    icon: Icons.calendar_today_outlined,
    title: 'ตารางของฉัน',
    description: 'คาบเรียน สอบ และกิจกรรม ใช้คิดเวลาเข้านอน',
    destination: Destination.schedule,
  ),
  GuideEntry(
    group: GuideGroup.schedule,
    icon: Icons.keyboard_outlined,
    title: 'เพิ่มคาบเรียน',
    description: 'พิมพ์ครั้งเดียว ใช้ซ้ำทุกสัปดาห์',
    destination: Destination.addClass,
  ),
  GuideEntry(
    group: GuideGroup.schedule,
    icon: Icons.mic_none_outlined,
    title: 'พูดใส่ตาราง',
    description: 'พูดวัน เวลา และชื่อวิชา แล้วตรวจก่อนบันทึก',
    destination: Destination.speakTimetable,
    mic: true,
  ),
  GuideEntry(
    group: GuideGroup.schedule,
    icon: Icons.notes_outlined,
    title: 'ใส่หลายคาบเป็นประโยค',
    description: 'พิมพ์รวดเดียวหลายคาบ แล้วตรวจก่อนบันทึก',
    destination: Destination.speakTimetable,
    mic: false,
  ),
  GuideEntry(
    group: GuideGroup.schedule,
    icon: Icons.image_outlined,
    title: 'นำเข้าตารางจากรูป',
    description: 'ใช้ผู้ช่วย AI อ่านรูปตาราง แล้วตรวจก่อนบันทึก',
    destination: Destination.importPicture,
  ),
  GuideEntry(
    group: GuideGroup.tasks,
    icon: Icons.checklist,
    title: 'จัดเย็นนี้',
    description: 'วางงานให้เสร็จก่อนเวลาวางมือถือ',
    destination: Destination.evening,
  ),
  GuideEntry(
    group: GuideGroup.tasks,
    icon: Icons.add_task,
    title: 'เพิ่มงาน',
    description: 'ใส่ชื่องาน เวลาที่ใช้ และวันส่ง',
    destination: Destination.addTask,
  ),
  GuideEntry(
    group: GuideGroup.game,
    icon: Icons.badge_outlined,
    title: 'บัตรของฉัน',
    description: 'ดูไฟ เหรียญ โล่ และร้านค้า',
    destination: Destination.card,
  ),
  GuideEntry(
    group: GuideGroup.game,
    icon: Icons.edit_outlined,
    title: 'แก้บัตร',
    description: 'เปลี่ยนชื่อ รูป และอวตารบนบัตร',
    destination: Destination.editCard,
  ),
  GuideEntry(
    group: GuideGroup.share,
    icon: Icons.ios_share,
    title: 'แชร์ลงสตอรี่',
    description: 'ทำภาพพื้นใสจากตัวเลขการนอน ไม่มีชื่อหรือรูปบนบัตร',
    destination: Destination.shareStory,
  ),
  GuideEntry(
    group: GuideGroup.ai,
    icon: Icons.auto_awesome_outlined,
    title: 'ตั้งค่าผู้ช่วย AI',
    description: 'ไม่เปิดก็ใช้แอปได้ครบ ใช้ได้เมื่ออายุ 18 ปีขึ้นไป',
    destination: Destination.aiSettings,
  ),
  GuideEntry(
    group: GuideGroup.data,
    icon: Icons.save_outlined,
    title: 'สำรองข้อมูล',
    description: 'ข้อมูลอยู่ในเครื่องนี้เท่านั้น สำรองไว้กันหาย',
    destination: Destination.backup,
  ),
];

/// The entries this user can use.
List<GuideEntry> visibleGuideEntries(GuideAccess access, {required bool mic}) =>
    [
      for (final entry in guideEntries)
        if (canOpen(entry.destination, access) &&
            (entry.mic == null || entry.mic == mic))
          entry,
    ];

/// One card of the first-time tour. The button shows only if the user can
/// get there.
class TourCard {
  final IconData icon;
  final String title;
  final String text;
  final String actionLabel;
  final Destination destination;

  const TourCard({
    required this.icon,
    required this.title,
    required this.text,
    required this.actionLabel,
    required this.destination,
  });
}

const tourCards = [
  TourCard(
    icon: Icons.calendar_today_outlined,
    title: '1. ใส่ตาราง',
    text: 'ใส่คาบเรียนครั้งเดียว Glow ใช้คิดเวลาตื่นและเวลาเข้านอนให้',
    actionLabel: 'เพิ่มคาบเรียน',
    destination: Destination.addClass,
  ),
  TourCard(
    icon: Icons.bedtime_outlined,
    title: '2. เวลานอนและรอบการนอน',
    text:
        'หน้านอนบอกเวลาเข้านอนคืนนี้ พร้อมจำนวนรอบการนอนโดยประมาณ '
        'ซึ่งไม่ได้วัดจากร่างกายคุณ',
    actionLabel: 'ดูแผนคืนนี้',
    destination: Destination.sleep,
  ),
  TourCard(
    icon: Icons.self_improvement,
    title: '3. จัดเย็นและท่าก่อนนอน',
    text: 'ใส่งานคืนนี้ให้จบก่อนเวลาวางมือถือ แล้วยืดเบา ๆ ก่อนนอน',
    actionLabel: 'ลองจัดเย็นนี้',
    destination: Destination.evening,
  ),
  TourCard(
    icon: Icons.local_fire_department_outlined,
    title: '4. เช็กอินและไฟ',
    text:
        'กด "เข้านอนแล้ว" ตอนวางมือถือ ตื่นแล้วเช็กอิน '
        'นอนครบแล้วไฟจะเพิ่ม',
    actionLabel: 'ดูไฟบนบัตร',
    destination: Destination.card,
  ),
];

/// The five lines of "เริ่มต้นใช้งาน" and where each one leads.
const checklistText = {
  ChecklistStep.schedule: ('ใส่ตารางเรียน', Destination.schedule),
  ChecklistStep.viewPlan: ('ดูแผนคืนนี้', Destination.sleep),
  ChecklistStep.eveningTask: ('เพิ่มงานค่ำ', Destination.addTask),
  ChecklistStep.routine: ('ลองท่าก่อนนอน', Destination.routine),
  ChecklistStep.checkIn: ('เช็กอินตอนเช้าครั้งแรก', Destination.sleep),
};

/// The (i) buttons.
enum GuideTip {
  cycles(
    'รอบการนอน',
    'การนอนสลับเป็นรอบ รอบละประมาณ 70–100 นาที\n'
        'Glow ใช้ความยาวรอบที่ตั้งไว้มาประมาณจำนวนรอบ ไม่ได้วัดจากร่างกายคุณ\n'
        'ปรับความยาวหรือปิดการจัดเวลาได้ในตั้งค่าขั้นสูง',
  ),
  questModes(
    'โหมดของคืน',
    'ปกติ: นอนครบ ตรงเวลา และท่าก่อนนอน\n'
        'เบา (เย็นแน่น): เควสเหมือนปกติ แต่ท่าก่อนนอนเป็นชุดสั้น\n'
        'ขั้นต่ำ (ตารางแน่นมาก หรือกด "วันนี้หมดแรง"): '
        'เหลือข้อเดียว คือหลับตามแผน',
  ),
  fireAndShields(
    'ไฟและโล่',
    'นอนครบ กดเข้านอนแล้ว และเช็กอิน ได้ไฟ +1\n'
        'เกือบครบ นอนเกิน ครบแต่ไม่ได้กดเข้านอน '
        'หรือคืนที่ตารางบังคับ ไฟคงเดิม\n'
        'ไม่ครบหรือไม่เช็กอิน ใช้โล่ให้เอง ถ้าไม่มีโล่ ไฟลด 1 ระดับ\n'
        'ได้โล่ฟรีทุกวันจันทร์ ถือได้ 2 อัน',
  ),
  evening(
    'ตารางเย็น',
    'Glow วางงานตั้งแต่ถึงบ้านจนถึงเวลาวางมือถือ\n'
        'ถ้างานเกินเวลา เลือกเลื่อนไปพรุ่งนี้ ลดเวลา หรือเอาออก '
        'เวลานอนไม่ถูกเลื่อน',
  );

  final String title;
  final String body;

  const GuideTip(this.title, this.body);
}

/// "รู้จักการนอน": our own plain words, three lines a card at most.
const sleepFacts = [
  (
    Icons.wb_sunny_outlined,
    'นาฬิกาในร่างกาย',
    [
      'ร่างกายมีจังหวะของตัวเองว่าเมื่อไรตื่น',
      'แสงช่วยปลุกให้ตื่น',
      'ตกกลางคืนร่างกายหลั่งเมลาโทนิน',
    ],
  ),
  (
    Icons.autorenew,
    'รอบการนอน',
    [
      'ช่วง NREM กับ REM สลับกันเป็นรอบ',
      'รอบละราว 70–100 นาที คืนละ 4–6 รอบ',
      'แต่ละคนและแต่ละวัยไม่เท่ากัน',
    ],
  ),
  (
    Icons.hourglass_bottom,
    'เมื่อนอนไม่พอ',
    ['มักง่วงในตอนกลางวัน', 'สมาธิลดลง', 'ความจำลดลง'],
  ),
];

const sleepFactsSource =
    'อรพินทร์ เชียงปิ๋ว. (2555). นาฬิกาชีวภาพกับการนอนหลับ. '
    'วารสารมหาวิทยาลัยศรีนครินทรวิโรฒ (สาขาวิทยาศาสตร์และเทคโนโลยี), '
    '4(7), 145–155.';

const sleepFactsNotice = 'เป็นข้อมูลทั่วไป ไม่ใช่คำแนะนำทางการแพทย์';
