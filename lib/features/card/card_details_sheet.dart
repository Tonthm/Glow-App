import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/birth_date.dart';
import '../../core/card_config.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/card_art.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import 'photo_field.dart';
import 'profile_fields.dart';

/// The profile and what the card shows. All optional.
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
  ProfileInput? _input;
  String _avatarId = defaultAvatarId;
  String? _birthDateError;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /// Read straight from the database: the screen that opened this sheet may
  /// not have been watching the profile.
  Future<void> _load() async {
    final saved = await ref.read(cardRepositoryProvider).get();
    if (!mounted) return;
    setState(() {
      _input = ProfileInput(saved);
      _avatarId = saved.avatarId;
    });
  }

  @override
  void dispose() {
    _input?.dispose();
    super.dispose();
  }

  Future<void> _save(ProfileInput input) async {
    final now = ref.read(clockProvider)();
    final birth = parseBirthDate(input.birthDate.text, now: now);
    if (birth.problem != null) {
      setState(
        () => _birthDateError = birthDateProblemMessage(birth.problem!),
      );
      return;
    }
    final cards = ref.read(cardRepositoryProvider);
    await cards.saveDetails(
      displayName: input.name.text,
      school: input.school.text,
      classYear: input.classYear.text,
      avatarId: _avatarId,
    );
    await cards.setBirthDate(birth.date, now: now);
    if (mounted) Navigator.of(context).pop();
  }

  /// The photo is saved or removed straight away, without the button below.
  Future<void> _setPhoto(Uint8List? jpeg) {
    final cards = ref.read(cardRepositoryProvider);
    return jpeg == null ? cards.removePhoto() : cards.savePhoto(jpeg);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final input = _input;
    if (input == null) {
      return const SizedBox(
        height: 120,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    return Padding(
      // Stays above the keyboard.
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('โปรไฟล์และบัตร', style: theme.textTheme.titleLarge),
              Text(
                'ใส่หรือไม่ใส่ก็ได้ เก็บไว้ในเครื่องนี้เท่านั้น',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: GlowSpacing.md),
              PhotoField(
                photo: ref.watch(cardPhotoProvider).value,
                onChanged: _setPhoto,
              ),
              const SizedBox(height: GlowSpacing.md),
              ProfileFields(input: input, birthDateError: _birthDateError),
              Text(
                'อวตาร (แสดงเมื่อไม่มีรูปถ่าย)',
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: GlowSpacing.sm),
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
              GlowPrimaryButton(label: 'บันทึก', onPressed: () => _save(input)),
            ],
          ),
        ),
    );
  }
}
