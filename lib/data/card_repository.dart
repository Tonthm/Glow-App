import 'package:drift/drift.dart';

import '../core/card_config.dart';
import 'database.dart';
import 'wallet_repository.dart';

/// What is written and shown on the student card. The card's color is the
/// wallet's equipped blanket, kept where it always was.
class CardRepository {
  final AppDatabase db;
  final WalletRepository walletRepo;

  CardRepository(this.db, this.walletRepo);

  Stream<CardProfileRow> watch() {
    return (db.select(db.cardProfiles)..where((t) => t.id.equals(0)))
        .watchSingleOrNull()
        .asyncMap((row) async => row ?? await get());
  }

  Future<CardProfileRow> get() async {
    await db
        .into(db.cardProfiles)
        .insert(
          const CardProfilesCompanion(id: Value(0)),
          mode: InsertMode.insertOrIgnore,
        );
    return (db.select(
      db.cardProfiles,
    )..where((t) => t.id.equals(0))).getSingle();
  }

  Future<void> _write(CardProfilesCompanion changes) async {
    await get();
    await (db.update(
      db.cardProfiles,
    )..where((t) => t.id.equals(0))).write(changes);
  }

  Future<void> saveDetails({
    required String displayName,
    required String school,
    required String classYear,
    required String avatarId,
  }) {
    String fit(String text, int max) {
      final clean = text.trim();
      return clean.length > max ? clean.substring(0, max) : clean;
    }

    return _write(
      CardProfilesCompanion(
        displayName: Value(fit(displayName, maxCardNameLength)),
        school: Value(fit(school, maxCardSchoolLength)),
        classYear: Value(fit(classYear, maxCardClassLength)),
        avatarId: Value(
          cardAvatars.containsKey(avatarId) ? avatarId : defaultAvatarId,
        ),
      ),
    );
  }

  Future<bool> _has(CardDecor decor) async =>
      decor.isFree || await walletRepo.owns(decor.id);

  /// Puts an owned decoration on the card; a sticker that is already there
  /// comes off. Returns false for one that isn't owned.
  Future<bool> use(CardDecor decor) async {
    if (!await _has(decor)) return false;
    switch (decor.kind) {
      case CardDecorKind.logo:
        await _write(CardProfilesCompanion(logoId: Value(decor.id)));
      case CardDecorKind.frame:
        await _write(CardProfilesCompanion(frameId: Value(decor.id)));
      case CardDecorKind.sticker:
        final current = parseStickerIds((await get()).stickerIds);
        await _write(
          CardProfilesCompanion(
            stickerIds: Value(
              encodeStickerIds(toggleSticker(current, decor.id)),
            ),
          ),
        );
    }
    return true;
  }
}
