import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';

/// Shown once, before the very first recording anywhere in the app (CLAUDE.md
/// section 11). False if the user backs out.
Future<bool> acceptVoiceNotice(BuildContext context, WidgetRef ref) async {
  final repo = ref.read(settingsRepositoryProvider);
  if ((await repo.get()).voiceNoticeAccepted) return true;
  if (!context.mounted) return false;
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
