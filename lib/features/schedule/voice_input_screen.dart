import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/speech_problem.dart';
import '../../core/thai_schedule_parser.dart';
import '../../providers.dart';
import '../../services/speech_service.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'add_item_sheet.dart';
import 'voice_notice.dart';
import 'voice_review_screen.dart';
import '../../services/app_clock.dart';

/// A working recogniser reports something, if only silence, well within this.
const Duration micSilenceLimit = Duration(seconds: 15);

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

  /// Fires if the mic never answers, as some browsers do.
  Timer? _silence;

  /// What was already in the box when listening started; new speech is added
  /// after it so a second try doesn't erase the first.
  String _before = '';

  @override
  void dispose() {
    _silence?.cancel();
    _speech.cancel();
    _text.dispose();
    super.dispose();
  }

  void _fail(SpeechProblem problem) {
    _silence?.cancel();
    if (!mounted) return;
    if (micCannotWork(problem)) {
      ref.read(micBrokenProvider.notifier).state = true;
    }
    setState(() {
      _listening = false;
      _message = speechProblemMessage(problem);
    });
  }

  Future<void> _toggleMic() async {
    HapticFeedback.lightImpact();
    if (_listening) {
      _silence?.cancel();
      await _speech.stop();
      return;
    }
    if (!await acceptVoiceNotice(context, ref)) return;
    final bool ready;
    try {
      ready = await _speech.prepare();
    } catch (_) {
      _fail(SpeechProblem.unavailable);
      return;
    }
    if (!mounted) return;
    if (!ready) {
      _fail(SpeechProblem.unavailable);
      return;
    }
    _before = _text.text.trim();
    setState(() => _message = null);
    _silence?.cancel();
    _silence = Timer(micSilenceLimit, () {
      _speech.cancel();
      _fail(SpeechProblem.unavailable);
    });
    try {
      await _speech.listen(
        onText: (words) {
          _silence?.cancel();
          if (!mounted) return;
          _text.text = _before.isEmpty ? words : '$_before $words';
          setState(() {});
        },
        onListeningChanged: (listening) {
          // A session that ended by itself did answer.
          if (!listening && _listening) _silence?.cancel();
          if (mounted) setState(() => _listening = listening);
        },
        onError: (code) => _fail(speechProblem(code)),
      );
    } catch (_) {
      _fail(SpeechProblem.unavailable);
    }
  }

  Future<void> _split() async {
    _silence?.cancel();
    if (_listening) await _speech.stop();
    if (!mounted) return;
    FocusScope.of(context).unfocus();
    final result = parseThaiSchedule(
      _text.text,
      now: ref.read(clockProvider)(),
    );
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
    final mic = ref.watch(micAvailableProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(mic ? 'พูดใส่ตาราง' : 'ใส่ตารางเป็นประโยค'),
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard_outlined),
            tooltip: 'เพิ่มด้วยการพิมพ์',
            onPressed: () async {
              if (_listening) await _speech.stop();
              if (context.mounted) await showTypedEntryChooser(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          if (mic) ...[
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
          ] else
            Text('เช่น "$_example"', style: theme.textTheme.bodyMedium),
          if (_message != null) ...[
            const SizedBox(height: GlowSpacing.md),
            Text(_message!, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: GlowSpacing.xl),
          TextField(
            controller: _text,
            minLines: 5,
            maxLines: 10,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              labelText: 'พิมพ์หรือพูดตารางตรงนี้ (แก้ได้)',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: GlowSpacing.xs),
          Text(
            'บนมือถือ กดไมค์บนคีย์บอร์ดเพื่อพิมพ์ด้วยเสียงได้',
            style: theme.textTheme.bodyMedium,
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

