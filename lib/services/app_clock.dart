import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

/// The one source of "now" for screens and services, so demo mode can move
/// time. Outside debug builds the offset is always zero.
class ClockOffset extends Notifier<Duration> {
  @override
  Duration build() => ref.watch(initialClockOffsetProvider);

  /// Makes the clock read [target] right now; it keeps ticking from there.
  Future<void> travelTo(DateTime target) =>
      _set(target.difference(DateTime.now()));

  Future<void> reset() => _set(Duration.zero);

  Future<void> _set(Duration offset) async {
    if (!kDebugMode) return;
    state = offset;
    await saveClockOffset(offset);
  }
}

/// Overridden in main() with the saved offset.
final initialClockOffsetProvider = Provider<Duration>((ref) => Duration.zero);

final clockOffsetProvider = NotifierProvider<ClockOffset, Duration>(
  ClockOffset.new,
);

/// Call the returned function each time the current time is needed. Watching
/// this provider rebuilds when demo mode jumps to another time.
final clockProvider = Provider<DateTime Function()>((ref) {
  final offset = ref.watch(clockOffsetProvider);
  return () => DateTime.now().add(offset);
});

Future<File> _offsetFile() async {
  final dir = await getApplicationSupportDirectory();
  return File('${dir.path}/demo_clock_offset');
}

/// Kept across restarts so closing the app mid-demo doesn't jump back.
Future<Duration> loadClockOffset() async {
  if (!kDebugMode) return Duration.zero;
  try {
    final file = await _offsetFile();
    if (!await file.exists()) return Duration.zero;
    return Duration(seconds: int.parse(await file.readAsString()));
  } catch (_) {
    return Duration.zero;
  }
}

Future<void> saveClockOffset(Duration offset) async {
  try {
    final file = await _offsetFile();
    await file.writeAsString('${offset.inSeconds}');
  } catch (_) {
    // Losing the demo offset is harmless.
  }
}
