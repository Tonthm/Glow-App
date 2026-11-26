import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../core/card_config.dart';
import '../../core/check_in.dart';
import '../../data/database.dart';
import '../../providers.dart';
import '../../theme/widgets/student_card.dart';
import '../room/blanket_color.dart';

final latestCheckInProvider = FutureProvider.autoDispose<CheckInRow?>((ref) {
  ref.watch(nightHistoryChangesProvider);
  return ref.watch(checkInRepositoryProvider).latestCheckIn();
});

AvatarMood moodOfCheckIn(CheckInRow? checkIn) => avatarMoodFor(
  checkIn == null ? null : CheckInResult.values.byName(checkIn.result.name),
);

/// Builds the card from saved data. With [showDetails] off, the name, school
/// and class stay off the card, which is what a shared picture does unless
/// the user asks otherwise (CLAUDE.md section 15: no personal details).
StudentCard studentCardFrom({
  required CardProfileRow? profile,
  required String? equippedColorId,
  required int fireLevel,
  required int firePoints,
  required AvatarMood mood,
  bool showDetails = true,
  VoidCallback? onTap,
}) {
  return StudentCard(
    color: blanketColorOf(equippedColorId),
    name: showDetails ? profile?.displayName ?? '' : '',
    school: showDetails ? profile?.school ?? '' : '',
    classYear: showDetails ? profile?.classYear ?? '' : '',
    avatarId: profile?.avatarId ?? defaultAvatarId,
    logoId: profile?.logoId ?? defaultLogoId,
    frameId: profile?.frameId ?? defaultFrameId,
    stickerIds: parseStickerIds(profile?.stickerIds ?? ''),
    mood: mood,
    fireLevel: fireLevel,
    firePoints: firePoints,
    onTap: onTap,
  );
}

/// The user's own card, kept up to date.
class MyStudentCard extends ConsumerWidget {
  final VoidCallback? onTap;

  const MyStudentCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fire = ref.watch(fireStateStreamProvider).value;
    return studentCardFrom(
      profile: ref.watch(cardProfileStreamProvider).value,
      equippedColorId: ref.watch(walletStreamProvider).value?.equippedBlanketId,
      fireLevel: fire?.level ?? 0,
      firePoints: fire?.points ?? 0,
      mood: moodOfCheckIn(ref.watch(latestCheckInProvider).value),
      onTap: onTap,
    );
  }
}
