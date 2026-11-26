# Glow

แอปวางแผนการนอนสำหรับนักเรียน คำนวณเวลาเข้านอนย้อนกลับจากตารางเรียนและตารางสอบ
A sleep planner for students: bedtime worked out from the real class and exam timetable.

- เว็บแอป (แพลตฟอร์มหลัก): https://tonthm.github.io/Glow-App/
- ข้อมูลของแอปเก็บในเครื่อง ไม่มีบัญชี ไม่มีเซิร์ฟเวอร์ของเรา
- ผู้ช่วย AI ไม่บังคับ ปิดเป็นค่าเริ่มต้น ใช้ API key ของผู้ใช้เอง และต้องอายุ 18 ปีขึ้นไป
  ข้อความหรือรูปตารางที่ผู้ใช้สั่งให้ AI อ่านจะถูกส่งไปที่ Google

## เอกสาร

| ไฟล์ | เรื่อง |
| --- | --- |
| `CLAUDE.md` | สเปกหลัก |
| `THEME.md` | หน้าตา |
| `todo.md` | สถานะ สิ่งที่ยังต้องทดสอบ |
| `DEPLOY_WEB.md` | วิธีขึ้นเว็บ และข้อควรระวังเรื่อง API key |
| `PROJECT.md` | ข้อมูลสำหรับทำสไลด์ |

## คำสั่ง

```bash
flutter analyze
flutter test
dart run build_runner build        # หลังแก้ lib/data/database.dart
flutter run -d chrome
dart run tool/build_web.dart       # ตัวที่จะ deploy ต้อง build ด้วยคำสั่งนี้
dart run tool/make_icons.dart      # ไอคอนจาก assets/logo.png (ไม่แตะ favicon)
dart run tool/eval_timetable.dart  # วัดความแม่นยำการอ่านตารางจากรูป (ต้องใช้ key)
```

โค้ด Android ยังอยู่ แต่หยุดดูแลและไม่ได้ทดสอบในรอบ v2
