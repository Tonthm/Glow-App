import 'package:flutter/services.dart' show HapticFeedback;
import 'package:material_ui/material_ui.dart';

/// Full-width primary button per THEME.md: accent fill, onAccent text,
/// 48dp tall, light haptic + short animation on press.
class GlowPrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  const GlowPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  @override
  State<GlowPrimaryButton> createState() => _GlowPrimaryButtonState();
}

class _GlowPrimaryButtonState extends State<GlowPrimaryButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 120),
    reverseDuration: const Duration(milliseconds: 120),
    lowerBound: 0.96,
    upperBound: 1.0,
    value: 1.0,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onPressed == null) return;
    HapticFeedback.lightImpact();
    await _controller.reverse();
    await _controller.forward();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: ElevatedButton(
        onPressed: widget.onPressed == null ? null : _handleTap,
        child: widget.icon == null
            ? Text(widget.label)
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: 20),
                  const SizedBox(width: 8),
                  Text(widget.label),
                ],
              ),
      ),
    );
  }
}
