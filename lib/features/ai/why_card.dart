import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/evening_facts.dart';
import '../../services/ai/ai_assistant.dart';
import '../../theme/tokens.dart';
import 'ai_badge.dart';
import 'ai_providers.dart';

/// "ทำไม?" under tonight's plan. It only explains when asked, to save calls.
/// With AI off, or an answer that fails the check, the ready-made sentences
/// are shown. Give it a key that changes with the facts.
class WhyCard extends ConsumerStatefulWidget {
  final List<EveningFact> facts;

  const WhyCard({super.key, required this.facts});

  @override
  ConsumerState<WhyCard> createState() => _WhyCardState();
}

class _WhyCardState extends ConsumerState<WhyCard> {
  String? _text;
  String? _note;
  bool _fromAi = false;
  bool _busy = false;

  Future<void> _explain() async {
    setState(() => _busy = true);
    final assistant = ref.read(aiAssistantProvider);
    AiResult<String>? result;
    if (await assistant.isReady()) {
      result = await assistant.explain([
        for (final fact in widget.facts) fact.sentence,
      ]);
    }
    if (!mounted) return;
    setState(() {
      _busy = false;
      _fromAi = result?.value != null;
      _text = result?.value ?? templateExplanation(widget.facts);
      final failure = result?.failure;
      _note = failure == null ? null : aiFailureMessage(failure);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    if (_text == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: TextButton(
          onPressed: _busy ? null : _explain,
          child: Text(_busy ? 'กำลังสรุป…' : 'ทำไม?'),
        ),
      );
    }
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(GlowSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_text!, style: textTheme.bodyLarge),
            if (_fromAi) const AiBadge(),
            if (_note != null) Text(_note!, style: textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
