import 'dart:typed_data';

import 'package:material_ui/material_ui.dart';

import '../../theme/tokens.dart';
import '../../theme/widgets/glow_logo.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../card/photo_field.dart';
import '../card/profile_fields.dart';

/// The very first screen: what makes Glow different, and who the card is
/// for. All of it can be skipped; going on without skipping needs a name.
class WelcomePage extends StatelessWidget {
  final ProfileInput input;
  final String? nameError;
  final String? birthDateError;
  final Uint8List? photo;
  final Future<void> Function(Uint8List? jpeg) onPhotoChanged;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  const WelcomePage({
    super.key,
    required this.input,
    required this.photo,
    required this.onPhotoChanged,
    required this.onNext,
    required this.onSkip,
    this.nameError,
    this.birthDateError,
  });

  static const headline = 'ใส่ตารางเรียน 2 นาที แล้วรู้เวลานอนทั้งสัปดาห์';

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              // Not a lazy list: every field must keep what was typed.
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(GlowSpacing.xl),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const GlowLogo(size: 88),
                    const SizedBox(height: GlowSpacing.md),
                    Text(
                      headline,
                      textAlign: TextAlign.center,
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: GlowSpacing.lg),
                    Text(
                      'ทำบัตรของคุณ ใส่แค่ชื่อก็พอ ที่เหลือใส่ทีหลังได้ '
                      'ข้อมูลเก็บในเครื่องนี้เท่านั้น',
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: GlowSpacing.md),
                    ProfileFields(
                      input: input,
                      nameError: nameError,
                      birthDateError: birthDateError,
                    ),
                    PhotoField(photo: photo, onChanged: onPhotoChanged),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                GlowSpacing.xl,
                GlowSpacing.sm,
                GlowSpacing.xl,
                GlowSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  GlowPrimaryButton(label: 'ต่อไป', onPressed: onNext),
                  TextButton(onPressed: onSkip, child: const Text('ข้าม')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
