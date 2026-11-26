import 'dart:convert';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:glow/core/card_config.dart';
import 'package:glow/data/card_repository.dart';
import 'package:glow/data/database.dart';
import 'package:glow/data/fire_repository.dart';
import 'package:glow/data/shop_repository.dart';
import 'package:glow/data/wallet_repository.dart';
import 'package:glow/services/backup_service.dart';

void main() {
  late AppDatabase db;
  late WalletRepository wallet;
  late CardRepository card;
  late ShopRepository shop;
  final now = DateTime(2026, 11, 26, 21);

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    wallet = WalletRepository(db);
    card = CardRepository(db, wallet);
    shop = ShopRepository(wallet, FireRepository(db));
  });

  tearDown(() => db.close());

  CardDecor decor(String id) => cardDecorById(id)!;

  test('a new card is plain and empty', () async {
    final profile = await card.get();
    expect(profile.displayName, '');
    expect(profile.logoId, defaultLogoId);
    expect(profile.frameId, defaultFrameId);
    expect(profile.avatarId, defaultAvatarId);
    expect(profile.stickerIds, '');
  });

  test('details are trimmed, shortened, and the avatar checked', () async {
    await card.saveDetails(
      displayName: '  ${'ก' * 40} ',
      school: ' สาธิต ',
      classYear: 'ม.5',
      avatarId: 'nope',
    );
    final profile = await card.get();
    expect(profile.displayName, 'ก' * maxCardNameLength);
    expect(profile.school, 'สาธิต');
    expect(profile.avatarId, defaultAvatarId);
  });

  test('buying a decoration costs coins once', () async {
    await wallet.addCoins(100);
    final sticker = decor('sticker_moon');

    expect(await shop.buyDecor(sticker, now), PurchaseResult.success);
    expect((await wallet.get()).coins, 100 - sticker.priceCoins);
    expect(await shop.buyDecor(sticker, now), PurchaseResult.alreadyOwned);
    expect((await wallet.get()).coins, 100 - sticker.priceCoins);
  });

  test('without enough coins nothing changes', () async {
    await wallet.addCoins(10);
    expect(
      await shop.buyDecor(decor('frame_stars'), now),
      PurchaseResult.notEnoughCoins,
    );
    expect((await wallet.get()).coins, 10);
    expect(await wallet.ownedItemIds(), isEmpty);
  });

  test('only owned or free decorations can be put on', () async {
    expect(await card.use(decor('logo_planet')), isFalse);
    expect(await card.use(decor('logo_star')), isTrue);
    expect((await card.get()).logoId, 'logo_star');

    await wallet.grantItem('sticker_heart', now);
    await card.use(decor('sticker_heart'));
    expect((await card.get()).stickerIds, 'sticker_heart');
    await card.use(decor('sticker_heart'));
    expect((await card.get()).stickerIds, '');
  });

  test('the card goes into a backup and comes back', () async {
    await card.saveDetails(
      displayName: 'มายด์',
      school: 'สาธิต',
      classYear: 'ม.5',
      avatarId: 'avatar_star',
    );
    await card.use(decor('logo_cloud'));
    final backup = BackupService(db);
    final saved = jsonDecode(jsonEncode(await backup.buildSnapshot()));

    await backup.deleteAllData();
    expect(await db.select(db.cardProfiles).get(), isEmpty);
    await backup.restoreSnapshot(saved as Map<String, dynamic>);

    final profile = await card.get();
    expect(profile.displayName, 'มายด์');
    expect(profile.avatarId, 'avatar_star');
    expect(profile.logoId, 'logo_cloud');
  });

  test('an older backup keeps what was bought and gets a plain card', () async {
    await wallet.addCoins(42);
    await wallet.grantItem('blanket_navy', now);
    await wallet.equipBlanket('blanket_navy');
    final backup = BackupService(db);
    final old =
        jsonDecode(jsonEncode(await backup.buildSnapshot()))
              as Map<String, dynamic>
          ..['version'] = 6
          ..remove('cardProfiles');

    await backup.deleteAllData();
    await backup.restoreSnapshot(old);

    expect((await wallet.get()).coins, 42);
    expect((await wallet.get()).equippedBlanketId, 'blanket_navy');
    expect(await wallet.ownedItemIds(), {'blanket_navy'});
    expect((await card.get()).logoId, defaultLogoId);
  });
}
