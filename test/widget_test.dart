import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:glow/data/database.dart';
import 'package:glow/features/onboarding/welcome_page.dart';
import 'package:glow/main.dart';
import 'package:glow/providers.dart';

void main() {
  testWidgets('app starts into onboarding on a fresh install', (tester) async {
    // The real databaseProvider opens a file via path_provider, which has no
    // platform-channel implementation under plain `flutter test` — use an
    // in-memory database instead, as in db_open_smoke_test.dart. Held here
    // (via overrideWithValue, so the provider's own ref.onDispose never
    // runs) and closed explicitly below, so drift's internal cleanup timer
    // fires inside the test instead of during ProviderScope's own teardown,
    // which the test invariant check can't tolerate.
    final db = AppDatabase.forTesting(NativeDatabase.memory());
    await tester.pumpWidget(
      ProviderScope(
        overrides: [databaseProvider.overrideWithValue(db)],
        child: const GlowApp(),
      ),
    );
    await tester.pumpAndSettle();

    // The card first, then the two questions about sleep.
    expect(find.text(WelcomePage.headline), findsOneWidget);
    await tester.tap(find.text('ข้าม'));
    await tester.pumpAndSettle();
    expect(find.text('เรียนเช้าสุดกี่โมง'), findsOneWidget);
    expect(find.text('เวลาเดินทางไปเรียน'), findsOneWidget);

    await db.close();
    await tester.pump(const Duration(seconds: 1));
  });
}
