import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shell.dart';
import 'data/database.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'providers.dart';
import 'services/app_clock.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final clockOffset = await loadClockOffset();
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

class GlowApp extends StatelessWidget {
  const GlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow',
      // The demo runs on a debug build; keep the banner off the stage.
      debugShowCheckedModeBanner: false,
      locale: const Locale('th'),
      supportedLocales: const [Locale('th')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: GlowAppTheme.light(),
      darkTheme: GlowAppTheme.dark(),
      themeMode: ThemeMode.system,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
        child: child!,
      ),
      home: const _RootGate(),
    );
  }
}

class _RootGate extends ConsumerWidget {
  const _RootGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsStreamProvider);
    return settingsAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) =>
          Scaffold(body: Center(child: Text('เกิดข้อผิดพลาด: $e'))),
      data: (settings) => _ThemedApp(
        themeMode: settings.themeMode,
        child: settings.onboardingCompleted
            ? const AppShell()
            : const OnboardingScreen(),
      ),
    );
  }
}

/// MaterialApp's themeMode is fixed at the top (GlowApp) since it can't read
/// riverpod state before ProviderScope exists above it — this re-applies the
/// user's stored "ตามระบบ/สว่าง/มืด" choice (section 3) over that default via
/// an inherited Theme override.
class _ThemedApp extends StatelessWidget {
  final AppThemeMode themeMode;
  final Widget child;

  const _ThemedApp({required this.themeMode, required this.child});

  @override
  Widget build(BuildContext context) {
    if (themeMode == AppThemeMode.system) return child;
    final isDark = themeMode == AppThemeMode.dark;
    return Theme(
      data: isDark ? GlowAppTheme.dark() : GlowAppTheme.light(),
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          platformBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        child: child,
      ),
    );
  }
}
