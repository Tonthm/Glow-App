/// Shared steps for tests that show real screens over a real database.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:glow/data/database.dart';
import 'package:material_ui/material_ui.dart';

/// A fixed number of frames, so a spinner that never stops shows up as a
/// failed check instead of a test that never ends.
Future<void> settle(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

/// The smallest phone the app is tested on. Anything that doesn't fit fails
/// the test.
void useSmallPhone(WidgetTester tester) {
  tester.view.physicalSize = const Size(320, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

/// Taps [finder], scrolling to it first. A list only builds what is near the
/// screen, so it may have to be scrolled into being.
Future<void> tapOn(WidgetTester tester, Finder finder) async {
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await settle(tester);
  await tester.tap(finder);
  await settle(tester);
}

/// Closing waits on timers, which only run when the test clock moves.
Future<void> closeDatabase(WidgetTester tester, AppDatabase db) async {
  await tester.pumpWidget(const SizedBox());
  var closed = false;
  db.close().then((_) => closed = true);
  for (var i = 0; i < 50 && !closed; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
  expect(closed, isTrue, reason: 'the database did not close');
}
