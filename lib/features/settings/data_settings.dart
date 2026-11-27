import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../providers.dart';
import '../../theme/tokens.dart';
import '../ai/ai_providers.dart';

/// "สำรองข้อมูล" on its own page, for the guide. The same rows are in the
/// advanced settings.
class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('สำรองข้อมูล')),
    body: ListView(
      padding: const EdgeInsets.all(GlowSpacing.pageMargin),
      children: const [DataSettingsRows()],
    ),
  );
}

/// Backup, restore, and delete everything (CLAUDE.md section 12).
class DataSettingsRows extends ConsumerWidget {
  const DataSettingsRows({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          title: const Text('สำรองข้อมูลเป็นไฟล์'),
          trailing: const Icon(Icons.upload_file_outlined),
          onTap: () async {
            final backups = ref.read(backupServiceProvider);
            var includePhoto = false;
            if (await ref.read(cardRepositoryProvider).photo() != null) {
              if (!context.mounted) return;
              final answer = await _askAboutPhoto(context);
              if (answer == null) return;
              includePhoto = answer;
            }
            final ok = await backups.exportToFile(includePhoto: includePhoto);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    ok ? 'สำรองข้อมูลแล้ว' : 'ยกเลิกการสำรองข้อมูล',
                  ),
                ),
              );
            }
          },
        ),
        const SizedBox(height: GlowSpacing.sm),
        ListTile(
          title: const Text('นำเข้าข้อมูลจากไฟล์สำรอง'),
          trailing: const Icon(Icons.download_outlined),
          onTap: () async {
            final confirmed = await _confirm(
              context,
              title: 'นำเข้าข้อมูล',
              message: 'ข้อมูลปัจจุบันทั้งหมดจะถูกแทนที่ด้วยไฟล์ที่เลือก ต้องการดำเนินการต่อไหม',
            );
            if (!confirmed || !context.mounted) return;
            String message;
            try {
              final ok = await ref.read(backupServiceProvider).importFromFile();
              message = ok ? 'นำเข้าข้อมูลแล้ว' : 'ยกเลิกการนำเข้า';
            } catch (_) {
              message = 'อ่านไฟล์นี้ไม่ได้ ข้อมูลเดิมยังอยู่ครบ';
            }
            if (context.mounted) {
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text(message)));
            }
          },
        ),
        const SizedBox(height: GlowSpacing.sm),
        ListTile(
          title: Text(
            'ลบข้อมูลทั้งหมด',
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
          trailing: Icon(
            Icons.delete_forever_outlined,
            color: Theme.of(context).colorScheme.error,
          ),
          onTap: () async {
            final confirmed = await _confirm(
              context,
              title: 'ลบข้อมูลทั้งหมด',
              message: 'ข้อมูลทุกอย่างในแอปจะถูกลบและไม่สามารถกู้คืนได้ ต้องการดำเนินการต่อไหม',
            );
            if (!confirmed || !context.mounted) return;
            final notifications = ref.read(notificationServiceProvider);
            final backup = ref.read(backupServiceProvider);
            final apiKeys = ref.read(apiKeyStoreProvider);
            // Back to the first screen, which becomes onboarding again.
            Navigator.of(context).popUntil((route) => route.isFirst);
            await backup.deleteEverything(apiKeys);
            await notifications.cancelAll();
          },
        ),
      ],
    );
  }
}

Future<bool> _confirm(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('ยกเลิก'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('ยืนยัน'),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// Whether the card photo goes into the backup file; null cancels. Leaving it
/// out is the main choice.
Future<bool?> _askAboutPhoto(BuildContext context) => showDialog<bool>(
  context: context,
  builder: (context) => AlertDialog(
    title: const Text('รวมรูปถ่ายบนบัตรไหม'),
    content: const Text(
      'ถ้ารวม ใครได้ไฟล์สำรองไปจะเห็นรูปด้วย '
      'ถ้าไม่รวม ตอนนำเข้ารูปที่มีอยู่ในเครื่องจะไม่ถูกลบ',
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(true),
        child: const Text('รวมรูป'),
      ),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(false),
        child: const Text('ไม่รวม'),
      ),
    ],
  ),
);
