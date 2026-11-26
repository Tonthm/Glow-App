import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../data/ai_settings_repository.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/ai/ai_assistant.dart';
import '../../services/ai/ai_client.dart';
import '../../services/ai/api_key_store.dart';
import '../../services/ai/fake_ai_client.dart';
import '../../services/ai/gemini_ai_client.dart';

final apiKeyStoreProvider = Provider<ApiKeyStore>((ref) {
  return SecureApiKeyStore();
});

final aiSettingsRepositoryProvider = Provider<AiSettingsRepository>((ref) {
  return AiSettingsRepository(ref.watch(databaseProvider));
});

final aiSettingsProvider = StreamProvider<AiSettingsRow>((ref) {
  return ref.watch(aiSettingsRepositoryProvider).watch();
});

/// Debug-only: a stand-in AI that needs no key, for demos.
final aiDemoModeProvider = StateProvider<bool>((ref) => false);

final aiClientProvider = Provider<AiClient>((ref) => GeminiAiClient());

final aiAssistantProvider = Provider<AiAssistant>((ref) {
  final demo = kDebugMode && ref.watch(aiDemoModeProvider);
  return AiAssistant(
    settings: ref.watch(aiSettingsRepositoryProvider),
    keys: ref.watch(apiKeyStoreProvider),
    client: demo ? FakeAiClient() : ref.watch(aiClientProvider),
    demo: demo,
  );
});

/// Bumped when the stored key changes, since secure storage can't be watched.
final aiKeyVersionProvider = StateProvider<int>((ref) => 0);

/// Whether the AI parts of the screens should show.
final aiReadyProvider = FutureProvider<bool>((ref) {
  ref.watch(aiSettingsProvider);
  // The age group lives in the app's settings.
  ref.watch(settingsStreamProvider);
  ref.watch(aiKeyVersionProvider);
  return ref.watch(aiAssistantProvider).isReady();
});
