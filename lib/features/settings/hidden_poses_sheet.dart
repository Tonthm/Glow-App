import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/routine_config.dart';
import '../../data/settings_repository.dart';
import '../../providers.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';

Future<void> showHiddenPosesSheet(BuildContext context) {
  return showGlowBottomSheet(
    context: context,
    builder: (_) => const _HiddenPoses(),
  );
}

class _HiddenPoses extends ConsumerWidget {
  const _HiddenPoses();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsStreamProvider).value;
    final hidden = settings == null ? <String>{} : hiddenPoseSet(settings);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('ท่าที่ซ่อนไว้', style: Theme.of(context).textTheme.titleLarge),
        if (hidden.isEmpty)
          Text(
            'ยังไม่มีท่าที่ซ่อน ซ่อนได้จากหน้าท่าก่อนนอน',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        Flexible(
          child: ListView(
            shrinkWrap: true,
            children: [
              for (final pose in poseLibrary)
                if (hidden.contains(pose.id))
                  ListTile(
                    title: Text(pose.name),
                    trailing: TextButton(
                      onPressed: () => ref
                          .read(settingsRepositoryProvider)
                          .setPoseHidden(pose.id, false),
                      child: const Text('เลิกซ่อน'),
                    ),
                  ),
            ],
          ),
        ),
      ],
    );
  }
}
