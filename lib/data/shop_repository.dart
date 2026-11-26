import '../core/card_config.dart';
import '../core/economy_config.dart';
import 'fire_repository.dart';
import 'wallet_repository.dart';

enum PurchaseResult {
  success,
  notEnoughCoins,
  alreadyOwned,
  shieldAlreadyFull,
  shieldAlreadyPurchasedThisWeek,
}

/// Buy actions for the shop (CLAUDE.md section 9), composing wallet + fire
/// since buying a shield touches both.
class ShopRepository {
  final WalletRepository walletRepo;
  final FireRepository fireRepo;

  ShopRepository(this.walletRepo, this.fireRepo);

  Future<PurchaseResult> buyBlanket(BlanketConfig blanket, DateTime now) {
    return walletRepo.db.transaction(
      () => _buyItem(blanket.id, blanket.priceCoins, now),
    );
  }

  Future<PurchaseResult> buyDecor(CardDecor decor, DateTime now) async {
    if (decor.isFree) return PurchaseResult.alreadyOwned;
    return walletRepo.db.transaction(
      () => _buyItem(decor.id, decor.priceCoins, now),
    );
  }

  Future<PurchaseResult> buyShield(DateTime now) {
    return walletRepo.db.transaction(() => _buyShield(now));
  }

  Future<PurchaseResult> _buyItem(
    String itemId,
    int priceCoins,
    DateTime now,
  ) async {
    if (await walletRepo.owns(itemId)) return PurchaseResult.alreadyOwned;
    final wallet = await walletRepo.get();
    if (wallet.coins < priceCoins) return PurchaseResult.notEnoughCoins;

    await walletRepo.addCoins(-priceCoins);
    await walletRepo.grantItem(itemId, now);
    return PurchaseResult.success;
  }

  Future<PurchaseResult> _buyShield(DateTime now) async {
    final wallet = await walletRepo.get();
    if (wallet.coins < EconomyConfig.shieldPriceCoins) {
      return PurchaseResult.notEnoughCoins;
    }

    final outcome = await fireRepo.tryPurchaseShield(now);
    switch (outcome) {
      case ShieldPurchaseOutcome.alreadyFull:
        return PurchaseResult.shieldAlreadyFull;
      case ShieldPurchaseOutcome.alreadyPurchasedThisWeek:
        return PurchaseResult.shieldAlreadyPurchasedThisWeek;
      case ShieldPurchaseOutcome.success:
        await walletRepo.addCoins(-EconomyConfig.shieldPriceCoins);
        return PurchaseResult.success;
    }
  }
}
