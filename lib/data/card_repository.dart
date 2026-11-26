import 'package:drift/drift.dart';

import '../core/birth_date.dart';
import '../core/card_config.dart';
import '../core/card_photo.dart';
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

  /// Saves the birth date, or clears it. A date also sets the age group, and
  /// moves the sleep target to the new age only if the user never changed it
  /// themselves. Clearing leaves the age group as it was.
  Future<void> setBirthDate(DateTime? birthDate, {required DateTime now}) {
    return db.transaction(() async {
      final before = (await get()).birthDate;
      await _write(CardProfilesCompanion(birthDate: Value(birthDate)));
      // Saving the same date again changes nothing, so a birthday passing
      // never moves the target by itself.
      if (birthDate == null || birthDate == before) return;

      await db
          .into(db.settings)
          .insert(
            const SettingsCompanion(id: Value(0)),
            mode: InsertMode.insertOrIgnore,
          );
      final settings = await (db.select(
        db.settings,
      )..where((t) => t.id.equals(0))).getSingle();
      final isAdult = isAdultOn(birthDate, now);
      final target = targetAfterAgeChange(
        current: (
          min: settings.targetMinMinutes,
          max: settings.targetMaxMinutes,
        ),
        wasAdult: settings.ageGroup == AgeGroup.adult,
        isAdult: isAdult,
      );
      await (db.update(db.settings)..where((t) => t.id.equals(0))).write(
        SettingsCompanion(
          ageGroup: Value(isAdult ? AgeGroup.adult : AgeGroup.under18),
          targetMinMinutes: Value(target.min),
          targetMaxMinutes: Value(target.max),
        ),
      );
    });
  }

  Stream<Uint8List?> watchPhoto() =>
      (db.select(db.cardPhotos)..where((t) => t.id.equals(0)))
          .watchSingleOrNull()
          .map((row) => row?.jpeg);

  Future<Uint8List?> photo() async => (await (db.select(
    db.cardPhotos,
  )..where((t) => t.id.equals(0))).getSingleOrNull())?.jpeg;

  /// [jpeg] must already be cut and compressed (services/photo_processor).
  Future<void> savePhoto(Uint8List jpeg) async {
    if (jpeg.isEmpty || jpeg.length > maxCardPhotoBytes) {
      throw ArgumentError.value(jpeg.length, 'jpeg', 'wrong size');
    }
    await db
        .into(db.cardPhotos)
        .insertOnConflictUpdate(
          CardPhotosCompanion(id: const Value(0), jpeg: Value(jpeg)),
        );
  }

  Future<void> removePhoto() => db.delete(db.cardPhotos).go();

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
