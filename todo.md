# Glow — สถานะล่าสุดและสิ่งที่เหลือ

อ่าน `CLAUDE.md`, `THEME.md`, `PROMPTS.md` ก่อนทำงานต่อทุกครั้ง

## สถานะ (ล่าสุด commit `5898861`)

เฟส 1, 2, 3 เขียนโค้ดเสร็จหมดแล้ว (ตาม PROMPTS.md), `flutter analyze` สะอาด, unit test ผ่านทั้งหมด (61 เคส) **แต่ยังไม่ได้ทดสอบบนอุปกรณ์จริงเลยสักหน้า** เพราะเครื่องที่ทำงานล่าสุดเปิด emulator ไม่ได้ (เครื่อง VMware Workstation ชนกับ Hyper-V/WHP ลองเปิด Windows Hypervisor Platform แล้วไม่ช่วย) และไม่มีมือถือ Android ต่อทดสอบ

### งานใหญ่ที่ทำไปแล้ว
- **ธีม** (`lib/theme/`): ฟอนต์ Noto Sans Thai + Nunito (variable font, OFL), tokens, ThemeData สว่าง/มืด, `GlowColors` extension, widget ใช้ซ้ำ 6 ตัว, Theme gallery (debug), ย้ายทุกหน้าจอมาใช้ธีมนี้แล้ว
- **เฟส 2**: `core/check_in.dart`, `core/fire.dart` (unit test ครบ), ตาราง CheckIn/FireState + migration, การ์ดเช็กอิน + หน้าผลเช็กอิน, heatmap หน้าสถิติ, แจ้งเตือนเช็กอิน, ปุ่มสร้างข้อมูลตัวอย่าง 60 คืน (debug)
- **เฟส 3**: `core/quests.dart`, `core/economy_config.dart` (ไฟล์ราคา/รางวัลไฟล์เดียว), Wallet/Shop/Quest repository, หน้าห้อง + `BedCharacter` + ร้านค้า + คลังผ้าห่ม, จุดความคืบหน้าเควส ●●●○○ บนหน้าคืนนี้, เหรียญที่ได้บนหน้าผลเช็กอิน

### บั๊กที่เจอและแก้ไปแล้วในเซสชันนี้
- `CheckInRepository.sweepMissedNights` เคยไล่คืนที่ขาดเช็กอินย้อนหลังผิดลำดับ (ใหม่→เก่า) ซึ่งจะทำให้สตรีคพัง ถ้าแอปถูกปิดหลายวันติด — แก้เป็นเก่า→ใหม่แล้ว (ดู commit `ef5c76f`)

## ทำต่อ (เรียงตามความสำคัญ)

### 1. ทดสอบบนอุปกรณ์จริง (สำคัญที่สุด ยังไม่ได้ทำเลย)
ตั้งค่าบนเครื่องใหม่:
- ติดตั้ง Flutter SDK (`flutter doctor` ให้ผ่าน) และ Android SDK
- ถ้าจะใช้ emulator ต้องเช็ก hardware acceleration ให้พร้อมก่อน (Hyper-V/WHP หรือ AEHD driver) — ถ้าเครื่องใหม่มี VMware/VirtualBox ลงอยู่ด้วย ให้เผื่อเวลาแก้ปัญหานี้ หรือใช้มือถือจริงต่อ USB (`adb devices`) จะง่ายกว่า
- รัน `flutter pub get` แล้ว `flutter test` ให้ผ่านก่อน (ควรผ่านอยู่แล้ว)
- จากนั้นไล่ทดสอบ:
  - แจ้งเตือนตอนแอปถูกปิด (ปิดแอปแล้วรอดู 3 แจ้งเตือน: วางมือถือ, ถึงเวลานอน, เช็กอิน)
  - แจ้งเตือนรอดหลังรีสตาร์ตเครื่อง (`adb reboot` แล้วเช็กว่า alarm ยังอยู่)
  - สิทธิ์ Android 12+/13+ (exact alarm, POST_NOTIFICATIONS)
  - การ์ดเช็กอินตอนเช้า, wheel picker "แก้เวลา" (ลอง edge case ข้ามเที่ยงคืน)
  - heatmap หน้าสถิติ (ใช้ปุ่ม debug สร้างข้อมูลตัวอย่าง 60 คืนก่อน)
  - ร้านค้า/คลังผ้าห่มในหน้าห้อง, ซื้อโล่ (เช็ก cap สัปดาห์ละ 1 อัน)
  - สถานะแดงตอนตารางแน่น (section 4)

### 2. ขัดหน้าจอเดิมให้ตรง THEME.md มากขึ้น
ตอนย้ายมาใช้ธีม ปรับแค่สี/ฟอนต์/widget หลัก ๆ ยังไม่ได้ปรับ layout ให้ตรงทุกจุด:
- หน้าตั้งค่า: THEME.md ต้องการแถวแบบเส้นแบ่ง + แตะแล้วเปิด bottom sheet แก้ (ตอนนี้ยังเป็น SwitchListTile/ListTile ธรรมดาผสมกัน ไม่ใช่ bottom sheet ทุกแถว)
- หน้าตาราง: ตรวจว่าตารางรายสัปดาห์เป็นบล็อกมุมโค้งสีพื้นอ่อนของ accent ตาม THEME.md จริงไหม
- Bed character: หน้าตายังเป็นรูปทรงเรียบง่ายตามที่ CLAUDE.md บอกให้ทำไปก่อน (`lib/theme/widgets/bed_character.dart`) — รอ user ตัดสินใจหน้าตาจริงของตัวละครก่อนค่อยทำใหม่

### 3. เฟส 4 — พูดใส่ตาราง (ยังไม่เริ่ม)
ตาม PROMPTS.md: `core/thai_schedule_parser.dart` (ต้องเทสอย่างน้อย 50 ประโยคก่อนเขียน UI), หน้าพูด, หน้าตรวจ, ต่อเข้าปุ่ม "พูด" ในหน้าตาราง

### 4. จุดเล็ก ๆ ที่รู้อยู่แล้วว่ายังไม่สมบูรณ์
- `FireRepository.applyEffect`/`addCoins` ใน `WalletRepository` อ่าน-แล้ว-เขียนแบบไม่ atomic (เสี่ยง race condition เชิงทฤษฎีถ้ามีสองการกระทำพร้อมกัน) — ไม่น่าเป็นปัญหาจริงเพราะแอปผู้ใช้เดียว แต่ถ้าเจอเหรียญ/ไฟเพี้ยนให้ดูจุดนี้ก่อน
- รางวัล "ครบทุกคืนก่อนสอบ" ใช้ผ้าห่มพิเศษตัวเดียวกันทุกช่วงสอบ (ไม่ได้แยกตัวใหม่ต่อช่วงสอบ) — ถ้าต้องการให้ต่างกันต้องเพิ่ม config
- ยังไม่มีการ "ซื้อเพิ่ม" โล่จาก UI ไหนอื่นนอกจากหน้าร้านค้า (ตรงตามสเปก แต่ยังไม่ทดสอบจริง)

## คำสั่งที่ใช้บ่อย

```bash
# จากโฟลเดอร์โปรเจกต์
flutter pub get
flutter analyze
flutter test
flutter run           # ต้องมี device/emulator ต่ออยู่
dart run build_runner build --delete-conflicting-outputs   # หลังแก้ lib/data/database.dart
```

ไฟล์ `windowoption.txt` ที่ root เป็นไฟล์ debug ชั่วคราวจากตอนไล่ปัญหา emulator ลบได้เลยถ้าไม่ใช้แล้ว
