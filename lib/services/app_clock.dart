import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'clock_offset_store.dart';

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

/// Kept across restarts so closing the app mid-demo doesn't jump back.
Future<Duration> loadClockOffset() async {
  if (!kDebugMode) return Duration.zero;
  try {
    final stored = await readStoredClockOffset();
    if (stored == null) return Duration.zero;
    return Duration(seconds: int.parse(stored));
  } catch (_) {
    return Duration.zero;
  }
}

Future<void> saveClockOffset(Duration offset) async {
  try {
    await writeStoredClockOffset('${offset.inSeconds}');
  } catch (_) {
    // Losing the demo offset is harmless.
  }
}
