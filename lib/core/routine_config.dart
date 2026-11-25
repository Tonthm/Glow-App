/// The one place for the activity-to-body-part mapping and the pose library
/// (CLAUDE.md section 13). Only gentle stretches that work on or beside a
/// bed, with nothing but a wall or a towel.
library;

enum DayActivityKind {
  sitting,
  screen,
  reading,
  running,
  walking,
  sport,
  standing,
  lifting,
  relaxed,
}

enum BodyPart {
  neck,
  shoulders,
  upperBack,
  wrists,
  lowerBack,
  hips,
  hamstrings,
  quads,
  calves,
  ankles,
}

/// In the order a routine runs, so it finishes lying in bed.
enum PosePosition { standing, sitting, lying }

const Map<DayActivityKind, String> activityLabels = {
  DayActivityKind.sitting: 'นั่งเรียน / นั่งนาน',
  DayActivityKind.screen: 'ใช้คอม / มือถือนาน',
  DayActivityKind.reading: 'อ่านหนังสือนาน',
  DayActivityKind.running: 'วิ่ง',
  DayActivityKind.walking: 'เดินเยอะ',
  DayActivityKind.sport: 'เล่นกีฬา',
  DayActivityKind.standing: 'ยืนนาน',
  DayActivityKind.lifting: 'ยกของ / เล่นเวท',
  DayActivityKind.relaxed: 'วันสบาย ๆ',
};

/// Used for a relaxed day, or when nothing is picked.
const List<BodyPart> generalParts = [BodyPart.neck, BodyPart.lowerBack];

const Map<DayActivityKind, List<BodyPart>> activityParts = {
  DayActivityKind.sitting: [
    BodyPart.lowerBack,
    BodyPart.hips,
    BodyPart.hamstrings,
  ],
  DayActivityKind.screen: [
    BodyPart.neck,
    BodyPart.shoulders,
    BodyPart.upperBack,
    BodyPart.wrists,
  ],
  DayActivityKind.reading: [
    BodyPart.neck,
    BodyPart.shoulders,
    BodyPart.upperBack,
  ],
  DayActivityKind.running: [
    BodyPart.calves,
    BodyPart.quads,
    BodyPart.hamstrings,
    BodyPart.ankles,
  ],
  DayActivityKind.walking: [BodyPart.calves, BodyPart.ankles, BodyPart.hips],
  DayActivityKind.sport: [
    BodyPart.calves,
    BodyPart.quads,
    BodyPart.hamstrings,
    BodyPart.hips,
    BodyPart.ankles,
  ],
  DayActivityKind.standing: [BodyPart.calves, BodyPart.lowerBack],
  DayActivityKind.lifting: [
    BodyPart.shoulders,
    BodyPart.upperBack,
    BodyPart.lowerBack,
  ],
  DayActivityKind.relaxed: generalParts,
};

/// Shown on every routine screen.
const String routineSafetyNote =
    'ยืดแค่พอตึง ไม่ต้องสุด ถ้าเจ็บให้หยุดทันที '
    'ถ้าเจ็บต่อเนื่องหลายวัน ควรปรึกษาแพทย์';

class Pose {
  final String id;
  final String name;

  /// Null for the breathing exercise.
  final BodyPart? part;
  final PosePosition position;

  /// Total time, covering both sides when [bothSides] is set.
  final int seconds;
  final bool bothSides;
  final List<String> steps;

  const Pose({
    required this.id,
    required this.name,
    required this.part,
    required this.position,
    required this.seconds,
    required this.steps,
    this.bothSides = false,
  });
}

const Pose breathingPose = Pose(
  id: 'breathing',
  name: 'หายใจช้า',
  part: null,
  position: PosePosition.lying,
  seconds: 60,
  steps: [
    'นอนหงายสบาย ๆ วางมือบนท้อง',
    'หายใจเข้าทางจมูก นับ 1 ถึง 4',
    'หายใจออกช้า ๆ นับ 1 ถึง 6 แล้วทำต่อไปเรื่อย ๆ',
  ],
);

const List<Pose> poseLibrary = [
  Pose(
    id: 'neck_side',
    name: 'เอียงคอข้าง',
    part: BodyPart.neck,
    position: PosePosition.sitting,
    seconds: 60,
    bothSides: true,
    steps: [
      'นั่งหลังตรง ปล่อยไหล่สบาย',
      'ค่อย ๆ เอียงหูเข้าหาไหล่ข้างหนึ่ง',
      'ค้างไว้ หายใจตามปกติ ไม่ต้องใช้มือกด',
    ],
  ),
  Pose(
    id: 'shoulder_rolls',
    name: 'หมุนไหล่',
    part: BodyPart.shoulders,
    position: PosePosition.sitting,
    seconds: 45,
    steps: [
      'นั่งสบาย ๆ แขนวางข้างตัว',
      'ยกไหล่ขึ้น หมุนไปด้านหลังเป็นวงช้า ๆ',
      'ครบครึ่งเวลาแล้วหมุนกลับไปด้านหน้า',
    ],
  ),
  Pose(
    id: 'upper_back_reach',
    name: 'ประสานมือดันไปข้างหน้า',
    part: BodyPart.upperBack,
    position: PosePosition.sitting,
    seconds: 45,
    steps: [
      'ประสานมือแล้วยื่นแขนไปข้างหน้า',
      'ดันฝ่ามือออกไป ให้สะบักแยกออกจากกัน',
      'ก้มหน้าเล็กน้อย หายใจช้า ๆ',
    ],
  ),
  Pose(
    id: 'wrist_stretch',
    name: 'ยืดข้อมือ',
    part: BodyPart.wrists,
    position: PosePosition.sitting,
    seconds: 60,
    bothSides: true,
    steps: [
      'ยื่นแขนไปข้างหน้า หงายฝ่ามือ',
      'ใช้มืออีกข้างดึงนิ้วลงเบา ๆ',
      'ค้างไว้พอรู้สึกตึง',
    ],
  ),
  Pose(
    id: 'childs_pose',
    name: 'ท่าเด็ก',
    part: BodyPart.lowerBack,
    position: PosePosition.lying,
    seconds: 60,
    steps: [
      'คุกเข่าบนที่นอน แยกเข่าเล็กน้อย',
      'นั่งไปทางส้นเท้า แล้วโน้มตัวไปข้างหน้า',
      'วางแขนและหน้าผากสบาย ๆ ถ้าเจ็บเข่าให้กดข้าม',
    ],
  ),
  Pose(
    id: 'knees_to_chest',
    name: 'นอนกอดเข่า',
    part: BodyPart.lowerBack,
    position: PosePosition.lying,
    seconds: 45,
    steps: [
      'นอนหงาย งอเข่าทั้งสองข้าง',
      'กอดเข่าเข้าหาอกเบา ๆ',
      'ปล่อยหลังแนบที่นอน หายใจช้า ๆ',
    ],
  ),
  Pose(
    id: 'figure_four',
    name: 'ท่าเลขสี่นอนหงาย',
    part: BodyPart.hips,
    position: PosePosition.lying,
    seconds: 60,
    bothSides: true,
    steps: [
      'นอนหงาย ชันเข่าทั้งสองข้าง',
      'วางข้อเท้าข้างหนึ่งบนเข่าอีกข้าง',
      'ดึงขาข้างล่างเข้าหาตัวเบา ๆ พอตึงที่สะโพก',
    ],
  ),
  Pose(
    id: 'towel_hamstring',
    name: 'นอนยกขาดึงด้วยผ้าขนหนู',
    part: BodyPart.hamstrings,
    position: PosePosition.lying,
    seconds: 60,
    bothSides: true,
    steps: [
      'นอนหงาย คล้องผ้าขนหนูที่ฝ่าเท้าข้างหนึ่ง',
      'ยกขาขึ้นช้า ๆ งอเข่าได้เล็กน้อย',
      'ดึงผ้าเบา ๆ พอตึงที่ต้นขาด้านหลัง',
    ],
  ),
  Pose(
    id: 'side_quad',
    name: 'นอนตะแคงดึงเท้าไปหาก้น',
    part: BodyPart.quads,
    position: PosePosition.lying,
    seconds: 60,
    bothSides: true,
    steps: [
      'นอนตะแคง หนุนศีรษะให้สบาย',
      'งอเข่าขาบน ใช้มือจับข้อเท้าหรือขากางเกง',
      'ดึงส้นเท้าเข้าหาก้นเบา ๆ เข่าชิดกันไว้',
    ],
  ),
  Pose(
    id: 'wall_calf',
    name: 'ยืดน่องกับผนัง',
    part: BodyPart.calves,
    position: PosePosition.standing,
    seconds: 60,
    bothSides: true,
    steps: [
      'ยืนหันหน้าเข้าผนัง วางมือบนผนัง',
      'ก้าวขาข้างหนึ่งไปข้างหลัง ส้นเท้าติดพื้น',
      'ย่อเข่าหน้าช้า ๆ พอตึงที่น่องขาหลัง',
    ],
  ),
  Pose(
    id: 'ankle_circles',
    name: 'หมุนข้อเท้า',
    part: BodyPart.ankles,
    position: PosePosition.sitting,
    seconds: 60,
    bothSides: true,
    steps: [
      'นั่งบนเตียง ยกเท้าข้างหนึ่งขึ้นเล็กน้อย',
      'หมุนข้อเท้าเป็นวงช้า ๆ',
      'ครบครึ่งเวลาแล้วหมุนกลับอีกทาง',
    ],
  ),
];
