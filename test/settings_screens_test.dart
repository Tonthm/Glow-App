import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/settings_repository.dart';
import 'package:glow/features/settings/setting_row.dart';
import 'package:glow/features/settings/settings_screen.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

void main() {
  late AppDatabase db;

  Future<void> show(WidgetTester tester) async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    await SettingsRepository(db).applyAgeGroupDefaults(AgeGroup.adult);
    // A narrow viewport also exercises wrapped setting descriptions.
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          platformCapabilitiesProvider.overrideWithValue(
            PlatformCapabilities.web,
          ),
        ],
        child: MaterialApp(
          theme: GlowAppTheme.light(),
          home: const SettingsScreen(),
        ),
      ),
    );
    await settle(tester);
  }

  /// Every label on a page, scrolling to the end.
  Future<Set<String>> allText(WidgetTester tester) async {
    final seen = <String>{};
    for (var i = 0; i < 20; i++) {
      seen.addAll([
        for (final w in tester.widgetList<Text>(find.byType(Text))) ?w.data,
      ]);
      await tester.drag(find.byType(Scrollable).last, const Offset(0, -300));
      await settle(tester);
    }
    return seen;
  }

  testWidgets('the first page has no more than five settings', (tester) async {
    await show(tester);
    // The advanced link is a way further, not a setting.
    expect(find.byType(SettingRow), findsNWidgets(5));
    expect(find.byType(SwitchListTile), findsNothing);
    final seen = await allText(tester);
    for (final title in [
      'โปรไฟล์และบัตร',
      'เวลาเดินทาง',
      'เวลาเตรียมตัว',
      'เตือนในปฏิทิน',
      'โหมดสี',
      'ตั้งค่าขั้นสูง',
    ]) {
      expect(seen, contains(title), reason: title);
    }
    expect(
      seen.any((text) => text.contains('ไม่ใช่คำแนะนำทางการแพทย์')),
      isTrue,
    );
    await closeDatabase(tester, db);
  });

  testWidgets('nothing was removed: it all sits one page further', (
    tester,
  ) async {
    await show(tester);
    await tapOn(tester, find.text('ตั้งค่าขั้นสูง'));
    final advanced = await allText(tester);
    expect(
      advanced,
      containsAll([
        'ช่วงอายุ',
        'เป้าต่ำสุด',
        'เป้าสูงสุด',
        'เรียนเช้าสุด (ตอนยังไม่มีตาราง)',
        'เวลาเดินทางแยกรายวัน',
        'เวลาตื่นวันว่าง',
        'ท่าก่อนนอน',
        'ท่าที่ซ่อนไว้',
        'ตารางเย็น',
        'ผู้ช่วย AI',
        'ปฏิทินเริ่มสัปดาห์วัน',
        'สำรองข้อมูลเป็นไฟล์',
        'นำเข้าข้อมูลจากไฟล์สำรอง',
        'ลบข้อมูลทั้งหมด',
      ]),
    );
    await tester.pageBack();
    await settle(tester);
    await tapOn(tester, find.text('เตือนในปฏิทิน'));
    expect(
      await allText(tester),
      containsAll([
        'เตือนวางมือถือ',
        'เตือนถึงเวลานอน',
        'เตือนคืนแดงข้างหน้า',
        'เตือนเช็กอิน',
        'เตือนเดดไลน์',
        'เตือนก่อนคาบเรียน',
        'เพิ่มเตือนลงปฏิทิน (7 วัน)',
      ]),
    );
    // What the web can't do isn't offered.
    expect(find.text('ทดสอบแจ้งเตือน'), findsNothing);
    expect(find.text('ปิดการประหยัดแบตให้ Glow'), findsNothing);
    await closeDatabase(tester, db);
  });
}
