import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_shell.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'providers.dart';

void main() {
  runApp(const ProviderScope(child: GlowApp()));
}

class GlowApp extends StatelessWidget {
  const GlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Glow',
      locale: const Locale('th'),
      supportedLocales: const [Locale('th')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
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
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('เกิดข้อผิดพลาด: $e'))),
      data: (settings) =>
          settings.onboardingCompleted ? const AppShell() : const OnboardingScreen(),
    );
  }
}
