import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/evening_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';

/// Tonight's plan; reloads when tasks, the timetable, or settings change.
final eveningViewProvider = FutureProvider.autoDispose<EveningView>((ref) {
  ref.watch(eveningChangesProvider);
  final now = ref.watch(clockProvider)();
  return ref.watch(eveningRepositoryProvider).load(now);
});
