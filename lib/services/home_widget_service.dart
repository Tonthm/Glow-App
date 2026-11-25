import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';

import '../core/widget_content.dart';
import '../data/database.dart';
import '../data/widget_snapshot.dart';

const _providers = [
  'com.example.glow.GlowSmallWidget',
  'com.example.glow.GlowMediumWidget',
];

/// Pushes fresh text to the home screen widgets. A widget problem must never
/// break the app, so failures are swallowed.
Future<void> updateHomeWidgets(AppDatabase db, DateTime now) async {
  try {
    final WidgetContent content = await loadWidgetContent(db, now);
    for (final entry in content.toMap().entries) {
      await HomeWidget.saveWidgetData<String>(entry.key, entry.value);
    }
    for (final provider in _providers) {
      await HomeWidget.updateWidget(qualifiedAndroidName: provider);
    }
  } on MissingPluginException {
    // No widgets on this platform, or in tests.
  } on PlatformException {
    // The next refresh will try again.
  }
}
