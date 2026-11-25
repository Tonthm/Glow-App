import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/economy_config.dart';
import '../../core/fire.dart';
import '../../data/database.dart';
import '../../data/shop_repository.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/bed_character.dart';
import '../../theme/widgets/stat_tile.dart';
import '../shared/settings_button.dart';

final _ownedItemsStreamProvider = StreamProvider.autoDispose<Set<String>>((ref) {
  return ref.watch(walletRepositoryProvider).watchOwnedItemIds();
});

final _latestCheckInProvider = FutureProvider.autoDispose<CheckInRow?>((ref) {
  ref.watch(_ownedItemsStreamProvider);
  return ref.watch(checkInRepositoryProvider).latestCheckIn();
});

/// Bed character + stats + shop, per CLAUDE.md section 9 ("จัดคล้ายหน้า
/// โปรไฟล์").
class RoomScreen extends ConsumerWidget {
  const RoomScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fireAsync = ref.watch(fireStateStreamProvider);
    final walletAsync = ref.watch(walletStreamProvider);
    final latestCheckInAsync = ref.watch(_latestCheckInProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('ห้อง'),
        actions: const [SettingsButton()],
      ),
      body: fireAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
        data: (fire) {
          final wallet = walletAsync.value;
          final latestCheckIn = latestCheckInAsync.value;
          final isFluffy =
              latestCheckIn == null ||
              latestCheckIn.result == CheckInResultDb.enough ||
              latestCheckIn.result == CheckInResultDb.over;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(GlowSpacing.pageMargin),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: ClipOval(
                        child: ColoredBox(
                          color: Theme.of(context).colorScheme.surface,
                          child: BedCharacter(
                            blanketColor: _blanketColor(wallet?.equippedBlanketId),
                            isFluffy: isFluffy,
                            lampOpacity: 0.3 + 0.7 * (fire.level / maxFireLevel),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: GlowSpacing.lg),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StatTile(
                            value: fireLevelNames[fire.level],
                            label: 'ระดับไฟ',
                          ),
                          StatTile(
                            value: '${wallet?.coins ?? 0}',
                            label: 'เหรียญ',
                          ),
                          StatTile(
                            value: '${fire.longestStreak}',
                            label: 'สตรีคยาวสุด',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      const TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.checkroom_outlined), text: 'สีผ้าห่มของฉัน'),
                          Tab(icon: Icon(Icons.storefront_outlined), text: 'ร้านค้า'),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _MyBlanketsGrid(equippedId: wallet?.equippedBlanketId),
                            const _ShopGrid(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

Color _blanketColor(String? itemId) {
  if (itemId == null) return const Color(0xFFBFC7D1);
  final match = EconomyConfig.blankets.where((b) => b.id == itemId);
  if (match.isNotEmpty) return Color(match.first.colorValue);
  for (final blanket in EconomyConfig.fireLevelRewardBlankets.values) {
    if (blanket.id == itemId) return Color(blanket.colorValue);
  }
  if (itemId == EconomyConfig.examPeriodRewardBlanket.id) {
    return Color(EconomyConfig.examPeriodRewardBlanket.colorValue);
  }
  return const Color(0xFFBFC7D1);
}

class _MyBlanketsGrid extends ConsumerWidget {
  final String? equippedId;
  const _MyBlanketsGrid({required this.equippedId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownedAsync = ref.watch(_ownedItemsStreamProvider);
    return ownedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      data: (owned) {
        final allBlankets = [
          ...EconomyConfig.blankets,
          ...EconomyConfig.fireLevelRewardBlankets.values,
          EconomyConfig.examPeriodRewardBlanket,
        ];
        final ownedBlankets = allBlankets.where((b) => owned.contains(b.id)).toList();
        return GridView.builder(
          padding: const EdgeInsets.all(1),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: ownedBlankets.length,
          itemBuilder: (context, i) {
            final blanket = ownedBlankets[i];
            return _BlanketCell(
              color: Color(blanket.colorValue),
              isEquipped: blanket.id == equippedId,
              onTap: () => ref.read(walletRepositoryProvider).equipBlanket(blanket.id),
            );
          },
        );
      },
    );
  }
}

class _ShopGrid extends ConsumerWidget {
  const _ShopGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ownedAsync = ref.watch(_ownedItemsStreamProvider);
    return ownedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('เกิดข้อผิดพลาด: $e')),
      data: (owned) {
        final purchasable = EconomyConfig.blankets
            .where((b) => !owned.contains(b.id))
            .toList();
        return GridView.builder(
          padding: const EdgeInsets.all(1),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1,
          ),
          itemCount: purchasable.length + 1,
          itemBuilder: (context, i) {
            if (i == 0) return const _ShieldShopCell();
            final blanket = purchasable[i - 1];
            return _BlanketCell(
              color: Color(blanket.colorValue),
              priceCoins: blanket.priceCoins,
              onTap: () async {
                final result = await ref
                    .read(shopRepositoryProvider)
                    .buyBlanket(blanket, DateTime.now());
                if (context.mounted) _showPurchaseSnackBar(context, result);
              },
            );
          },
        );
      },
    );
  }
}

class _ShieldShopCell extends ConsumerWidget {
  const _ShieldShopCell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () async {
        final result = await ref.read(shopRepositoryProvider).buyShield(DateTime.now());
        if (context.mounted) _showPurchaseSnackBar(context, result);
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            const Center(child: Icon(Icons.shield_outlined, size: 32)),
            Positioned(
              right: 4,
              bottom: 4,
              child: Text(
                '${EconomyConfig.shieldPriceCoins}',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BlanketCell extends StatelessWidget {
  final Color color;
  final bool isEquipped;
  final int? priceCoins;
  final VoidCallback onTap;

  const _BlanketCell({
    required this.color,
    this.isEquipped = false,
    this.priceCoins,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: color,
        child: Stack(
          children: [
            if (isEquipped)
              const Positioned(
                top: 4,
                left: 4,
                child: Icon(Icons.check_circle, color: Colors.white, size: 18),
              ),
            if (priceCoins != null)
              Positioned(
                right: 4,
                bottom: 4,
                child: Text(
                  '$priceCoins',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

void _showPurchaseSnackBar(BuildContext context, PurchaseResult result) {
  final message = switch (result) {
    PurchaseResult.success => 'ซื้อสำเร็จ',
    PurchaseResult.notEnoughCoins => 'เหรียญไม่พอ',
    PurchaseResult.alreadyOwned => 'มีอยู่แล้ว',
    PurchaseResult.shieldAlreadyFull => 'มีโล่ครบแล้ว',
    PurchaseResult.shieldAlreadyPurchasedThisWeek => 'ซื้อโล่ได้สัปดาห์ละ 1 อัน',
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
