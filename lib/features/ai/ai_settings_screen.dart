import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/ai_config.dart';
import '../../core/birth_date.dart';
import '../../data/ai_settings_repository.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/ai/ai_assistant.dart';
import '../../services/ai/ai_client.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/warning_bar.dart';
import 'ai_consent_screen.dart';
import 'ai_providers.dart';

const _quotaChoices = [10, 30, 50, 100];

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final _key = TextEditingController();
  bool? _hasKey;
  bool _testing = false;
  String? _testResult;

  @override
  void initState() {
    super.initState();
    _checkKey();
  }

  @override
  void dispose() {
    _key.dispose();
    super.dispose();
  }

  Future<void> _checkKey() async {
    String? stored;
    try {
      stored = await ref.read(apiKeyStoreProvider).read();
    } catch (_) {
      stored = null;
    }
    if (mounted) setState(() => _hasKey = stored?.isNotEmpty ?? false);
  }

  /// The saved key is never shown again, only whether there is one.
  Future<void> _saveKey(String? value) async {
    final store = ref.read(apiKeyStoreProvider);
    if (value == null) {
      await store.delete();
    } else {
      if (value.trim().isEmpty) return;
      await store.write(value.trim());
    }
    _key.clear();
    ref.read(aiKeyVersionProvider.notifier).state++;
    await _checkKey();
  }

  /// True once the user has agreed to the current consent text.
  Future<bool> _ensureConsent(AiSettingsRow row) async {
    if (row.consentVersion == aiConsentVersion) return true;
    final agreed = await Navigator.of(context)
        .push<bool>(MaterialPageRoute(builder: (_) => const AiConsentScreen()));
    if (agreed != true) return false;
    await ref
        .read(aiSettingsRepositoryProvider)
        .update(
          const AiSettingsCompanion(consentVersion: Value(aiConsentVersion)),
        );
    return true;
  }

  Future<void> _test(AiSettingsRow row) async {
    if (!await _ensureConsent(row)) return;
    setState(() {
      _testing = true;
      _testResult = null;
    });
    final failure = await ref.read(aiAssistantProvider).testConnection();
    if (!mounted) return;
    setState(() {
      _testing = false;
      _testResult = switch (failure) {
        null => 'เชื่อมต่อได้',
        AiFailure.notReady => 'ใส่ API key ก่อน',
        _ => aiFailureMessage(failure),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final row = ref.watch(aiSettingsProvider).value;
    if (row == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final repo = ref.read(aiSettingsRepositoryProvider);
    final used = AiSettingsRepository.callsOn(row, DateTime.now());
    final age = ref.watch(aiAgeProvider).value;
    if (age == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Reached only if the birth date changed while this screen was open.
    if (age == AiAgeState.hidden) return Scaffold(appBar: AppBar());
    final adult = age.mayUse;
    final hint = textTheme.bodyMedium;

    return Scaffold(
      appBar: AppBar(title: const Text('ผู้ช่วย AI')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          if (!adult) ...[
            Text(aiUnderAgeMessage, style: textTheme.bodyLarge),
            const SizedBox(height: GlowSpacing.md),
          ],
          if (age == AiAgeState.adultUnconfirmed) ...[
            const WarningBar(
              message: aiAgeUnconfirmedMessage,
              severity: WarningBarSeverity.yellow,
            ),
            const SizedBox(height: GlowSpacing.md),
          ],
          SwitchListTile(
            title: Text('เปิดผู้ช่วย AI', style: textTheme.titleMedium),
            subtitle: Text(
              'ช่วยแยกงาน ประเมินเวลา แบ่งงานใหญ่ และอธิบายแผนเย็นนี้',
              style: hint,
            ),
            value: adult && row.enabled,
            onChanged: adult
                ? (on) async {
                    if (on && !await _ensureConsent(row)) return;
                    await repo.update(AiSettingsCompanion(enabled: Value(on)));
                  }
                : null,
          ),
          if (row.enabled && _hasKey == false) ...[
            const SizedBox(height: GlowSpacing.sm),
            Text('ใส่ API key ด้านล่างจึงจะใช้ได้', style: hint),
          ],
          const SizedBox(height: GlowSpacing.lg),
          _Panel(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('ผู้ให้บริการ', style: textTheme.titleMedium),
                  ),
                  Text(aiProviderName, style: textTheme.bodyLarge),
                ],
              ),
              const SizedBox(height: GlowSpacing.lg),
              Text('API key', style: textTheme.titleMedium),
              const SizedBox(height: GlowSpacing.sm),
              TextField(
                controller: _key,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                style: textTheme.bodyLarge,
                decoration: _field(
                  context,
                  _hasKey == true
                      ? 'บันทึกแล้ว ใส่ใหม่เพื่อเปลี่ยน'
                      : 'วาง API key ที่นี่',
                ),
              ),
              const SizedBox(height: GlowSpacing.md),
              Row(
                children: [
                  FilledButton(
                    onPressed: () => _saveKey(_key.text),
                    child: const Text('บันทึก key'),
                  ),
                  if (_hasKey == true) ...[
                    const SizedBox(width: GlowSpacing.sm),
                    TextButton(
                      onPressed: () => _saveKey(null),
                      child: const Text('ลบ key'),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: GlowSpacing.md),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.lock_outline, size: 18, color: hint?.color),
                  const SizedBox(width: GlowSpacing.sm),
                  Expanded(
                    child: Text(
                      ref
                              .watch(platformCapabilitiesProvider)
                              .keyInBrowserStorage
                          ? 'key เก็บในที่เก็บข้อมูลของเบราว์เซอร์ ซึ่งปลอดภัย'
                                'น้อยกว่าบน Android ใช้ key ที่จำกัดสิทธิ์และ'
                                'วงเงินไว้ ไม่อยู่ในไฟล์สำรอง'
                          : 'key เก็บในที่เก็บแบบเข้ารหัสของเครื่อง '
                                'ไม่อยู่ในไฟล์สำรอง',
                      style: hint,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: GlowSpacing.lg),
              Text('ชื่อโมเดล', style: textTheme.titleMedium),
              const SizedBox(height: GlowSpacing.sm),
              TextFormField(
                initialValue: row.model,
                autocorrect: false,
                style: textTheme.bodyLarge,
                decoration: _field(context, aiDefaultModel),
                onChanged: (v) =>
                    repo.update(AiSettingsCompanion(model: Value(v.trim()))),
              ),
            ],
          ),
          const SizedBox(height: GlowSpacing.lg),
          _Panel(
            children: [
              Text('การใช้งานต่อวัน', style: textTheme.titleMedium),
              const SizedBox(height: GlowSpacing.xs),
              Text(
                'วันนี้เรียกไปแล้ว $used จาก ${row.dailyQuota} ครั้ง',
                style: hint,
              ),
              const SizedBox(height: GlowSpacing.md),
              Wrap(
                spacing: GlowSpacing.sm,
                runSpacing: GlowSpacing.sm,
                children: [
                  for (final quota in _quotaChoices)
                    ChoiceChip(
                      label: Text('$quota ต่อวัน'),
                      selected: row.dailyQuota == quota,
                      backgroundColor: theme.scaffoldBackgroundColor,
                      onSelected: (_) => repo.update(
                        AiSettingsCompanion(dailyQuota: Value(quota)),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: GlowSpacing.xl),
          GlowPrimaryButton(
            label: _testing ? 'กำลังทดสอบ…' : 'ทดสอบการเชื่อมต่อ',
            onPressed: _testing || !adult ? null : () => _test(row),
          ),
          if (_testResult != null) ...[
            const SizedBox(height: GlowSpacing.md),
            _Panel(children: [Text(_testResult!, style: textTheme.bodyLarge)]),
          ],
          if (kDebugMode) ...[
            const SizedBox(height: GlowSpacing.xl),
            SwitchListTile(
              title: const Text('Debug: ใช้ AI จำลอง (ไม่ต้องใช้ key)'),
              value: ref.watch(aiDemoModeProvider),
              onChanged: (v) => ref.read(aiDemoModeProvider.notifier).state = v,
            ),
          ],
        ],
      ),
    );
  }
}

/// A text box that stands out on a panel: filled with the page color.
InputDecoration _field(BuildContext context, String hint) {
  final theme = Theme.of(context);
  return InputDecoration(
    hintText: hint,
    hintStyle: theme.textTheme.bodyMedium,
    fillColor: theme.scaffoldBackgroundColor,
  );
}

/// One rounded surface holding related settings.
class _Panel extends StatelessWidget {
  final List<Widget> children;

  const _Panel({required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(GlowSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
  }
}
