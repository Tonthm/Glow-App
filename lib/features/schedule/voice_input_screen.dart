import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/thai_schedule_parser.dart';
import '../../providers.dart';
import '../../services/speech_service.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'add_item_sheet.dart';
import 'voice_review_screen.dart';

const _example =
    'วันจันทร์ แปดโมงครึ่งถึงสิบโมง คณิต บ่ายโมงถึงบ่ายสาม ฟิสิกส์';

/// Step 1-2 of "พูดใส่ตาราง": record, then let the user fix the text before
/// it is split into items.
class VoiceInputScreen extends ConsumerStatefulWidget {
  const VoiceInputScreen({super.key});

  @override
  ConsumerState<VoiceInputScreen> createState() => _VoiceInputScreenState();
}

class _VoiceInputScreenState extends ConsumerState<VoiceInputScreen> {
  final _text = TextEditingController();
  late final SpeechService _speech = ref.read(speechServiceProvider);
  bool _listening = false;
  String? _message;

  /// What was already in the box when listening started; new speech is added
  /// after it so a second try doesn't erase the first.
  String _before = '';

  @override
  void dispose() {
    _speech.cancel();
    _text.dispose();
    super.dispose();
  }

  Future<void> _toggleMic() async {
    HapticFeedback.lightImpact();
    if (_listening) {
      await _speech.stop();
      return;
    }
    if (!await _acceptNotice()) return;
    final ready = await _speech.prepare();
    if (!mounted) return;
    if (!ready) {
      setState(
        () => _message =
            'ใช้ไมค์ไม่ได้ ตรวจสิทธิ์ไมโครโฟนในตั้งค่าเครื่อง '
            'หรือพิมพ์ในช่องด้านล่างแทนได้',
      );
      return;
    }
    _before = _text.text.trim();
    setState(() => _message = null);
    await _speech.listen(
      onText: (words) {
        if (!mounted) return;
        _text.text = _before.isEmpty ? words : '$_before $words';
        setState(() {});
      },
      onListeningChanged: (listening) {
        if (mounted) setState(() => _listening = listening);
      },
      onError: (code) {
        if (!mounted) return;
        setState(() {
          _listening = false;
          _message = _errorMessage(code);
        });
      },
    );
  }

  /// Shown once, before the very first recording (section 11).
  Future<bool> _acceptNotice() async {
    final repo = ref.read(settingsRepositoryProvider);
    if ((await repo.get()).voiceNoticeAccepted) return true;
    if (!mounted) return false;
    final accepted = await showGlowBottomSheet<bool>(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('ก่อนใช้ไมค์', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: GlowSpacing.sm),
          Text(
            'Glow ใช้ระบบแปลงเสียงของเครื่อง ถ้าเครื่องไม่มีภาษาไทยแบบ'
            'ออฟไลน์ เสียงของคุณจะถูกส่งไปที่ Google เพื่อแปลงเป็นข้อความ '
            'Glow ไม่ได้บันทึกเสียงไว้ ถ้าไม่สะดวก พิมพ์แทนได้',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: GlowSpacing.lg),
          GlowPrimaryButton(
            label: 'เข้าใจแล้ว',
            onPressed: () => Navigator.of(context).pop(true),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('ยกเลิก'),
          ),
        ],
      ),
    );
    if (accepted != true) return false;
    await repo.markVoiceNoticeAccepted();
    return true;
  }

  Future<void> _split() async {
    await _speech.stop();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final result = parseThaiSchedule(_text.text, now: DateTime.now());
    if (result.items.isEmpty) {
      setState(
        () => _message =
            'ยังแยกรายการไม่ได้ ลองบอกวันและเวลา เช่นประโยคตัวอย่าง '
            'หรือแก้ข้อความแล้วกดอีกครั้ง',
      );
      return;
    }
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => VoiceReviewScreen(result: result)),
    );
    if (saved == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canSplit = _text.text.trim().isNotEmpty && !_listening;
    return Scaffold(
      appBar: AppBar(
        title: const Text('พูดใส่ตาราง'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_outlined),
            tooltip: 'เพิ่มด้วยการพิมพ์',
            onPressed: () async {
              await _speech.stop();
              if (context.mounted) await showTypedEntryChooser(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          Center(
            child: IconButton.outlined(
              iconSize: 48,
              padding: const EdgeInsets.all(GlowSpacing.xl),
              isSelected: _listening,
              icon: const Icon(Icons.mic_none_outlined),
              selectedIcon: const Icon(Icons.stop),
              tooltip: _listening ? 'หยุดฟัง' : 'กดแล้วพูด',
              onPressed: _toggleMic,
            ),
          ),
          const SizedBox(height: GlowSpacing.sm),
          Text(
            _listening ? 'กำลังฟัง…' : 'กดไมค์แล้วพูด เช่น\n"$_example"',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          if (_message != null) ...[
            const SizedBox(height: GlowSpacing.md),
            Text(_message!, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: GlowSpacing.xl),
          TextField(
            controller: _text,
            minLines: 3,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'ข้อความที่ฟังได้ (แก้ได้)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: GlowSpacing.lg),
          GlowPrimaryButton(
            label: 'แยกเป็นรายการ',
            onPressed: canSplit ? _split : null,
          ),
        ],
      ),
    );
  }
}

String _errorMessage(String code) => switch (code) {
  'error_no_match' || 'error_speech_timeout' => 'ไม่ได้ยินเสียงพูด ลองอีกครั้ง',
  'error_language_not_supported' || 'error_language_unavailable' =>
    'เครื่องนี้ยังไม่มีภาษาไทยสำหรับแปลงเสียง พิมพ์ในช่องด้านล่างแทนได้',
  'error_network' ||
  'error_network_timeout' ||
  'error_server' => 'ต่ออินเทอร์เน็ตไม่ได้ ลองอีกครั้ง หรือพิมพ์แทน',
  'error_permission' ||
  'error_audio_error' => 'ใช้ไมค์ไม่ได้ ตรวจสิทธิ์ไมโครโฟนในตั้งค่าเครื่อง',
  _ => 'แปลงเสียงไม่สำเร็จ ลองอีกครั้ง หรือพิมพ์แทน',
};
