import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/ai_config.dart';
import '../../data/ai_settings_repository.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../services/ai/ai_assistant.dart';
import '../../services/ai/ai_client.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
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
    final textTheme = Theme.of(context).textTheme;
    final row = ref.watch(aiSettingsProvider).value;
    if (row == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final repo = ref.read(aiSettingsRepositoryProvider);
    final used = AiSettingsRepository.callsOn(row, DateTime.now());
    final adult =
        ref.watch(settingsStreamProvider).value?.ageGroup == AgeGroup.adult;

    return Scaffold(
      appBar: AppBar(title: const Text('ผู้ช่วย AI')),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          if (!adult) Text(aiUnderAgeMessage, style: textTheme.bodyLarge),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('เปิดผู้ช่วย AI'),
            subtitle: const Text(
              'ช่วยแยกงาน ประเมินเวลา แบ่งงานใหญ่ และอธิบายแผนเย็นนี้',
            ),
            value: adult && row.enabled,
            onChanged: adult
                ? (on) async {
                    if (on && !await _ensureConsent(row)) return;
                    await repo.update(AiSettingsCompanion(enabled: Value(on)));
                  }
                : null,
          ),
          if (row.enabled && _hasKey == false)
            Text(
              'ใส่ API key ด้านล่างจึงจะใช้ได้',
              style: textTheme.bodyMedium,
            ),
          const Divider(),
          const ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('ผู้ให้บริการ'),
            trailing: Text(aiProviderName),
          ),
          TextField(
            controller: _key,
            obscureText: true,
            autocorrect: false,
            enableSuggestions: false,
            decoration: InputDecoration(
              labelText: _hasKey == true
                  ? 'API key (บันทึกแล้ว ใส่ใหม่เพื่อเปลี่ยน)'
                  : 'API key',
            ),
          ),
          Row(
            children: [
              TextButton(
                onPressed: () => _saveKey(_key.text),
                child: const Text('บันทึก key'),
              ),
              if (_hasKey == true)
                TextButton(
                  onPressed: () => _saveKey(null),
                  child: const Text('ลบ key'),
                ),
            ],
          ),
          Text(
            ref.watch(platformCapabilitiesProvider).keyInBrowserStorage
                ? 'key เก็บในที่เก็บข้อมูลของเบราว์เซอร์ ซึ่งปลอดภัยน้อยกว่าบน '
                      'Android ใช้ key ที่จำกัดสิทธิ์และวงเงินไว้ ไม่อยู่ในไฟล์สำรอง'
                : 'key เก็บในที่เก็บแบบเข้ารหัสของเครื่อง ไม่อยู่ในไฟล์สำรอง',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: GlowSpacing.md),
          TextFormField(
            initialValue: row.model,
            autocorrect: false,
            decoration: const InputDecoration(
              labelText: 'ชื่อโมเดล',
              hintText: aiDefaultModel,
            ),
            onChanged: (v) =>
                repo.update(AiSettingsCompanion(model: Value(v.trim()))),
          ),
          const SizedBox(height: GlowSpacing.md),
          Text('วันนี้เรียกไปแล้ว $used จาก ${row.dailyQuota} ครั้ง'),
          Wrap(
            spacing: GlowSpacing.sm,
            children: [
              for (final quota in _quotaChoices)
                ChoiceChip(
                  label: Text('$quota ต่อวัน'),
                  selected: row.dailyQuota == quota,
                  onSelected: (_) => repo.update(
                    AiSettingsCompanion(dailyQuota: Value(quota)),
                  ),
                ),
            ],
          ),
          const SizedBox(height: GlowSpacing.lg),
          GlowPrimaryButton(
            label: _testing ? 'กำลังทดสอบ…' : 'ทดสอบการเชื่อมต่อ',
            onPressed: _testing || !adult ? null : () => _test(row),
          ),
          if (_testResult != null)
            Text(_testResult!, style: textTheme.bodyLarge),
          if (kDebugMode) ...[
            const Divider(height: GlowSpacing.xxl),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
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
