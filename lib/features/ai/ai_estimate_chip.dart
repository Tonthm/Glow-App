import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/ai_validators.dart';
import '../../services/ai/ai_assistant.dart';
import '../../services/app_clock.dart';
import 'ai_badge.dart';
import 'ai_providers.dart';

/// Asks for a time estimate only when the user taps, to save calls. The
/// estimate changes nothing until the user taps it. Give it a key that changes
/// with the title, so an old estimate doesn't stay on a different task.
class AiEstimateChip extends ConsumerStatefulWidget {
  final String title;
  final DateTime? due;

  /// Called when an estimate arrives, accepted or not.
  final ValueChanged<AiEstimate> onEstimated;
  final ValueChanged<int> onAccept;

  const AiEstimateChip({
    super.key,
    required this.title,
    required this.onEstimated,
    required this.onAccept,
    this.due,
  });

  @override
  ConsumerState<AiEstimateChip> createState() => _AiEstimateChipState();
}

class _AiEstimateChipState extends ConsumerState<AiEstimateChip> {
  AiEstimate? _estimate;
  String? _message;
  bool _busy = false;

  Future<void> _ask() async {
    setState(() {
      _busy = true;
      _message = null;
    });
    final result = await ref
        .read(aiAssistantProvider)
        .estimate(
          title: widget.title,
          today: ref.read(clockProvider)(),
          due: widget.due,
        );
    if (!mounted) return;
    setState(() {
      _busy = false;
      _estimate = result.value;
      if (result.failure != null) {
        _message = '${aiFailureMessage(result.failure!)} ใส่เวลาเองได้เลย';
      }
    });
    if (result.value != null) widget.onEstimated(result.value!);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final estimate = _estimate;
    if (estimate != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ActionChip(
            label: Text(
              'AI ประเมิน ${estimate.minutes} นาที '
              '(${estimate.low}–${estimate.high})',
            ),
            onPressed: () => widget.onAccept(estimate.minutes),
          ),
          Text(estimate.reason, style: textTheme.bodyMedium),
          const AiBadge(),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton.icon(
          icon: const Icon(Icons.auto_awesome_outlined, size: 16),
          label: Text(_busy ? 'กำลังประเมิน…' : 'ให้ AI ประเมินเวลา'),
          onPressed: _busy || widget.title.trim().isEmpty ? null : _ask,
        ),
        if (_message != null) Text(_message!, style: textTheme.bodyMedium),
      ],
    );
  }
}
