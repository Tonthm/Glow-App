import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'subject_colors.dart';

/// Picks a subject's color: the type's own, a pastel, or any color.
class SubjectColorPicker extends StatelessWidget {
  final int? color;
  final ValueChanged<int?> onChanged;

  const SubjectColorPicker({
    super.key,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final isCustom =
        color != null && !GlowSubjectColors.all.values.contains(color);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('สีของวิชา', style: textTheme.bodyLarge),
        Text('ใช้กับทุกรายการที่ชื่อนี้', style: textTheme.bodyMedium),
        const SizedBox(height: GlowSpacing.xs),
        Wrap(
          spacing: GlowSpacing.xs,
          runSpacing: GlowSpacing.xs,
          children: [
            ChoiceChip(
              label: const Text('ตามประเภท'),
              showCheckmark: false,
              selected: color == null,
              onSelected: (_) => onChanged(null),
            ),
            for (final entry in GlowSubjectColors.all.entries)
              _Swatch(
                name: 'สี${entry.key}',
                color: Color(entry.value),
                selected: color == entry.value,
                onTap: () => onChanged(entry.value),
              ),
            ChoiceChip(
              label: const Text('ปรับเอง'),
              avatar: isCustom
                  ? CircleAvatar(backgroundColor: Color(color!))
                  : const Icon(Icons.palette_outlined, size: 18),
              showCheckmark: false,
              selected: isCustom,
              onSelected: (_) async {
                final picked = await showGlowBottomSheet<int>(
                  context: context,
                  builder: (_) => _CustomColor(
                    initial: color ?? GlowSubjectColors.all.values.first,
                  ),
                );
                if (picked != null) onChanged(picked);
              },
            ),
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  final String name;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _Swatch({
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: name,
      button: true,
      selected: selected,
      excludeSemantics: true,
      onTap: onTap,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? scheme.onSurface : scheme.outline,
              width: selected ? 3 : GlowStroke.outline,
            ),
          ),
          child: selected
              ? const Icon(Icons.check, color: GlowBaseColors.ink)
              : null,
        ),
      ),
    );
  }
}

class _CustomColor extends StatefulWidget {
  final int initial;

  const _CustomColor({required this.initial});

  @override
  State<_CustomColor> createState() => _CustomColorState();
}

class _CustomColorState extends State<_CustomColor> {
  late HSLColor _color = HSLColor.fromColor(Color(widget.initial));

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final value = _color.toColor().toARGB32();

    Widget slider(
      String label,
      double current,
      double max,
      HSLColor Function(double) change,
    ) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: textTheme.bodyMedium),
        Slider(
          value: current,
          max: max,
          label: label,
          onChanged: (v) => setState(() => _color = change(v)),
        ),
      ],
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('เลือกสีเอง', style: textTheme.titleLarge),
          const SizedBox(height: GlowSpacing.md),
          // How a block of this color will look.
          Container(
            padding: const EdgeInsets.all(GlowSpacing.md),
            decoration: BoxDecoration(
              color: subjectBlockColor(context, {'x': value}, 'x'),
              borderRadius: BorderRadius.circular(GlowRadius.button),
              border: Border.all(color: Theme.of(context).colorScheme.outline),
            ),
            child: Text('ตัวอย่างคาบเรียน', style: textTheme.bodyLarge),
          ),
          const SizedBox(height: GlowSpacing.md),
          slider('เฉดสี', _color.hue, 360, _color.withHue),
          slider('ความสด', _color.saturation, 1, _color.withSaturation),
          slider('ความสว่าง', _color.lightness, 1, _color.withLightness),
          GlowPrimaryButton(
            label: 'ใช้สีนี้',
            onPressed: () => Navigator.of(context).pop(value),
          ),
        ],
      ),
    );
  }
}
