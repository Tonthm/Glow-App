import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/card_config.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/card_art.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// Name, school, class and avatar. All optional.
Future<void> showCardDetailsSheet(BuildContext context) => showGlowBottomSheet(
  context: context,
  builder: (_) => const _CardDetailsForm(),
);

class _CardDetailsForm extends ConsumerStatefulWidget {
  const _CardDetailsForm();

  @override
  ConsumerState<_CardDetailsForm> createState() => _CardDetailsFormState();
}

class _CardDetailsFormState extends ConsumerState<_CardDetailsForm> {
  late final _profile = ref.read(cardProfileStreamProvider).value;
  late final _name = TextEditingController(text: _profile?.displayName ?? '');
  late final _school = TextEditingController(text: _profile?.school ?? '');
  late final _classYear = TextEditingController(
    text: _profile?.classYear ?? '',
  );
  late String _avatarId = _profile?.avatarId ?? defaultAvatarId;

  @override
  void dispose() {
    _name.dispose();
    _school.dispose();
    _classYear.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref
        .read(cardRepositoryProvider)
        .saveDetails(
          displayName: _name.text,
          school: _school.text,
          classYear: _classYear.text,
          avatarId: _avatarId,
        );
    if (mounted) Navigator.of(context).pop();
  }

  Widget _field(TextEditingController controller, String label, int max) =>
      Padding(
        padding: const EdgeInsets.only(bottom: GlowSpacing.md),
        child: TextField(
          controller: controller,
          maxLength: max,
          decoration: InputDecoration(labelText: label, counterText: ''),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      // Stays above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('ข้อมูลบนบัตร', style: theme.textTheme.titleLarge),
            Text(
              'ใส่หรือไม่ใส่ก็ได้ เก็บไว้ในเครื่องนี้เท่านั้น',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: GlowSpacing.md),
            _field(_name, 'ชื่อ', maxCardNameLength),
            _field(_school, 'โรงเรียนหรือมหาวิทยาลัย', maxCardSchoolLength),
            _field(_classYear, 'ชั้นปี', maxCardClassLength),
            Wrap(
              spacing: GlowSpacing.sm,
              runSpacing: GlowSpacing.sm,
              children: [
                for (final entry in cardAvatars.entries)
                  ChoiceChip(
                    avatar: CardAvatar(entry.key, size: 24),
                    showCheckmark: false,
                    label: Text(entry.value),
                    selected: _avatarId == entry.key,
                    onSelected: (_) => setState(() => _avatarId = entry.key),
                  ),
              ],
            ),
            const SizedBox(height: GlowSpacing.lg),
            GlowPrimaryButton(label: 'บันทึก', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
