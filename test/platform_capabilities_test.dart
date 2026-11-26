import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/features/schedule/add_item_sheet.dart';
import 'package:glow/providers.dart';
import 'package:glow/services/platform/platform_capabilities.dart';
import 'package:material_ui/material_ui.dart';

void main() {
  Future<void> openAddSheet(
    WidgetTester tester,
    PlatformCapabilities platform,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [platformCapabilitiesProvider.overrideWithValue(platform)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => showAddMethodSheet(context),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('the web hides voice and calendar import', (tester) async {
    await openAddSheet(tester, PlatformCapabilities.web);
    expect(find.text('พิมพ์'), findsOneWidget);
    expect(find.text('พูด'), findsNothing);
    expect(find.text('นำเข้าจากปฏิทิน'), findsNothing);
  });

  testWidgets('Android shows every way of adding', (tester) async {
    await openAddSheet(tester, PlatformCapabilities.android);
    expect(find.text('พิมพ์'), findsOneWidget);
    expect(find.text('พูด'), findsOneWidget);
    expect(find.text('นำเข้าจากปฏิทิน'), findsOneWidget);
  });

  test('the web uses calendar reminders, not notifications or widgets', () {
    const web = PlatformCapabilities.web;
    expect(web.calendarReminders, isTrue);
    expect(web.localNotifications, isFalse);
    expect(web.homeWidget, isFalse);
    expect(web.deviceSetupHelp, isFalse);
    expect(PlatformCapabilities.android.calendarReminders, isFalse);
  });
}
