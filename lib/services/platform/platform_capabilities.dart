import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;

import 'capabilities_io.dart'
    if (dart.library.js_interop) 'capabilities_web.dart';

/// What this platform can do (CLAUDE.md section 17). Screens ask this and
/// never check which platform they are on.
class PlatformCapabilities {
  /// Real notifications from the phone.
  final bool localNotifications;

  /// Reminders as calendar events in an .ics file.
  final bool calendarReminders;

  /// Reading the phone's calendar.
  final bool calendarImport;
  final bool homeWidget;
  final bool voiceInput;

  /// Permission requests, exact alarms, and the battery-saving guide.
  final bool deviceSetupHelp;

  /// The install guide, update bar, and backup nudge.
  final bool webApp;

  /// The API key sits in browser storage, which is less safe.
  final bool keyInBrowserStorage;

  /// Gemini accepts calls straight from a browser (preflight checked on 26
  /// Nov 2026), so this is on everywhere.
  final bool aiAssistant;

  const PlatformCapabilities._({
    required this.localNotifications,
    required this.calendarReminders,
    required this.calendarImport,
    required this.homeWidget,
    required this.voiceInput,
    required this.deviceSetupHelp,
    required this.webApp,
    required this.keyInBrowserStorage,
    required this.aiAssistant,
  });

  static const android = PlatformCapabilities._(
    localNotifications: true,
    calendarReminders: false,
    calendarImport: true,
    homeWidget: true,
    voiceInput: true,
    deviceSetupHelp: true,
    webApp: false,
    keyInBrowserStorage: false,
    aiAssistant: true,
  );

  static const web = PlatformCapabilities._(
    localNotifications: false,
    calendarReminders: true,
    calendarImport: false,
    homeWidget: false,
    // Only where the browser also has speech recognition (see
    // micAvailableProvider). Not yet checked on an iPhone.
    voiceInput: true,
    deviceSetupHelp: false,
    webApp: true,
    keyInBrowserStorage: true,
    aiAssistant: true,
  );

  /// Whether a "take a photo" button really opens a camera. A computer's
  /// browser would only open the file chooser again.
  bool get takePhoto =>
      !webApp ||
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;

  /// The platform this build is for.
  static const PlatformCapabilities current = currentCapabilities;
}
