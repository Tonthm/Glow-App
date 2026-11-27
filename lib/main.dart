import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shell.dart';
import 'data/database.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/onboarding/splash_screen.dart';
import 'features/web/web_app_gate.dart';
import 'providers.dart';
import 'services/app_clock.dart';
import 'services/background_refresh.dart';
import 'services/web_app.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final clockOffset = await loadClockOffset();
  unawaited(registerBackgroundRefresh());
  // Only does anything in a browser.
  unawaited(requestPersistentStorage());
  // Riverpod's automatic retry keeps a failed provider in "loading", which
  // hides errors (e.g. a database that can't open) behind an endless spinner.
  runApp(
    ProviderScope(
      retry: (_, _) => null,
      overrides: [initialClockOffsetProvider.overrideWithValue(clockOffset)],
      child: const GlowApp(),
    ),
  );
}

class GlowApp extends ConsumerWidget {
  const GlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(settingsStreamProvider).value?.themeMode;
    return MaterialApp(
      title: 'Glow',
      // The demo runs on a debug build; keep the banner off the stage.
      debugShowCheckedModeBanner: false,
      locale: const Locale('th'),
      supportedLocales: const [Locale('th')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: GlowAppTheme.light(),
      darkTheme: GlowAppTheme.dark(),
      themeMode: switch (themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        _ => ThemeMode.system,
      },
      builder: (context, child) => LayoutBuilder(
        builder: (context, constraints) {
          final media = MediaQuery.of(context);
          final width = constraints.maxWidth.clamp(0.0, 520.0);
          return ColoredBox(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Center(
              child: SizedBox(
                width: width,
                child: ClipRect(
                  child: MediaQuery(
                    data: media.copyWith(
                      size: Size(width, media.size.height),
                      alwaysUse24HourFormat: true,
                    ),
                    child: child!,
                  ),
                ),
              ),
            ),
          );
        },
      ),
      home: const WebAppGate(child: _RootGate()),
    );
  }
}

class _RootGate extends ConsumerWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsStreamProvider);
    return settingsAsync.when(
      loading: () => const SplashScreen(),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('เกิดข้อผิดพลาด: $e'))),
      data: (settings) => settings.onboardingCompleted
          ? const AppShell()
          : const OnboardingScreen(),
    );
  }
}
