import 'package:flutter_test/flutter_test.dart';
import 'package:glow/features/web/install_guide_screen.dart';
import 'package:glow/theme/app_theme.dart';
import 'package:material_ui/material_ui.dart';

import 'helpers.dart';

void main() {
  testWidgets(
    'small phone: installation steps scroll and continue stays visible',
    (tester) async {
      useSmallPhone(tester);
      var continued = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: GlowAppTheme.light(),
          home: InstallGuideScreen(onContinue: () => continued = true),
        ),
      );
      await tester.pumpAndSettle();
      final button = find.widgetWithText(ElevatedButton, 'ใช้ต่อในเบราว์เซอร์');
      expect(button.hitTestable(), findsOneWidget);
      await tester.scrollUntilVisible(
        find.text('เปิด Glow จากไอคอนบนหน้าจอโฮม'),
        160,
      );
      expect(find.text('เลือก "เพิ่มไปยังหน้าจอโฮม"'), findsOneWidget);
      await tester.tap(button);
      await tester.pumpAndSettle();
      expect(continued, isTrue);
      expect(tester.takeException(), isNull);
    },
  );
}
