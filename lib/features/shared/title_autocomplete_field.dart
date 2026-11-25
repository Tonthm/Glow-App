import 'package:material_ui/material_ui.dart';

/// Title field that suggests titles typed before ("ชื่อวิชาที่เคยพิมพ์ขึ้น
/// ให้เลือก" — CLAUDE.md section 2).
class TitleAutocompleteField extends StatelessWidget {
  final String initialValue;
  final List<String> suggestions;
  final ValueChanged<String> onChanged;

  const TitleAutocompleteField({
    super.key,
    required this.initialValue,
    required this.suggestions,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
      initialValue: TextEditingValue(text: initialValue),
      optionsBuilder: (textEditingValue) {
        if (textEditingValue.text.isEmpty) return suggestions;
        return suggestions.where((s) => s.contains(textEditingValue.text));
      },
      onSelected: onChanged,
      fieldViewBuilder: (context, controller, focusNode, onSubmit) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          decoration: const InputDecoration(
            labelText: 'ชื่อวิชา/กิจกรรม',
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
