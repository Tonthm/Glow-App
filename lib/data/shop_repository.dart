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

  Future<PurchaseResult> buyBlanket(BlanketConfig blanket, DateTime now) async {
    if (await walletRepo.owns(blanket.id)) return PurchaseResult.alreadyOwned;
    final wallet = await walletRepo.get();
    if (wallet.coins < blanket.priceCoins) return PurchaseResult.notEnoughCoins;

    await walletRepo.addCoins(-blanket.priceCoins);
    await walletRepo.grantItem(blanket.id, now);
    return PurchaseResult.success;
  }

  Future<PurchaseResult> buyShield(DateTime now) async {
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
