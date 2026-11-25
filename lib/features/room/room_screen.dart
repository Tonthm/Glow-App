import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/economy_config.dart';
import '../../core/fire.dart';
import '../../data/database.dart';
import '../../data/shop_repository.dart';
import '../../data/wallet_repository.dart';
import '../../providers.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/bed_character.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/stat_tile.dart';
import '../shared/settings_button.dart';
import 'blanket_color.dart';
import '../../services/app_clock.dart';

final _ownedItemsStreamProvider = StreamProvider.autoDispose<Set<String>>((
  ref,
) {
  return ref.watch(walletRepositoryProvider).watchOwnedItemIds();
});

final _latestCheckInProvider = FutureProvider.autoDispose<CheckInRow?>((ref) {
  ref.watch(nightHistoryChangesProvider);
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
                            blanketColor: blanketColorOf(
                              wallet?.equippedBlanketId,
                            ),
                            isFluffy: isFluffy,
                            lampOpacity:
                                0.3 + 0.7 * (fire.level / maxFireLevel),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: GlowSpacing.lg),
                    Expanded(
                      // Scaled as one block so the three stay the same size.
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            for (final (value, label) in [
                              (fireLevelNames[fire.level], 'ระดับไฟ'),
                              ('${wallet?.coins ?? 0}', 'เหรียญ'),
                              ('${fire.longestStreak}', 'สตรีคยาวสุด'),
                            ])
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: GlowSpacing.sm,
                                ),
                                child: StatTile(value: value, label: label),
                              ),
                          ],
                        ),
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
                          Tab(
                            icon: Icon(
                              Icons.checkroom_outlined,
                              semanticLabel: 'สีผ้าห่มของฉัน',
                            ),
                          ),
                          Tab(
                            icon: Icon(
                              Icons.storefront_outlined,
                              semanticLabel: 'ร้านค้า',
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: TabBarView(
                          children: [
                            _MyBlanketsGrid(
                              equippedId: wallet?.equippedBlanketId,
                            ),
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
        // The starting blanket is always available, so there's a way back.
        final ownedBlankets = [
          const BlanketConfig(defaultBlanketId, defaultBlanketColor, 0),
          ...allBlankets.where((b) => owned.contains(b.id)),
        ];
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
              onTap: () =>
                  ref.read(walletRepositoryProvider).equipBlanket(blanket.id),
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
                final shop = ref.read(shopRepositoryProvider);
                if (!await _confirmPurchase(
                  context,
                  'ผ้าห่มสีนี้',
                  blanket.priceCoins,
                )) {
                  return;
                }
                final result = await shop.buyBlanket(
                  blanket,
                  ref.read(clockProvider)(),
                );
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
        final shop = ref.read(shopRepositoryProvider);
        if (!await _confirmPurchase(
          context,
          'โล่ 1 อัน',
          EconomyConfig.shieldPriceCoins,
        )) {
          return;
        }
        final result = await shop.buyShield(ref.read(clockProvider)());
        if (context.mounted) _showPurchaseSnackBar(context, result);
      },
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.shield_outlined, size: 32),
                  Text(
                    'โล่ มี ${ref.watch(fireStateStreamProvider).value?.shields ?? 0}/$maxShields',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
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
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: GlowSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(GlowRadius.pill),
                  ),
                  child: Text(
                    '$priceCoins เหรียญ',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Future<bool> _confirmPurchase(
  BuildContext context,
  String name,
  int price,
) async {
  final confirmed = await showGlowBottomSheet<bool>(
    context: context,
    builder: (context) => Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'ซื้อ$name ราคา $price เหรียญ',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: GlowSpacing.lg),
        GlowPrimaryButton(
          label: 'ซื้อ',
          onPressed: () => Navigator.of(context).pop(true),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('ยกเลิก'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

void _showPurchaseSnackBar(BuildContext context, PurchaseResult result) {
  final message = switch (result) {
    PurchaseResult.success => 'ซื้อสำเร็จ',
    PurchaseResult.notEnoughCoins => 'เหรียญไม่พอ',
    PurchaseResult.alreadyOwned => 'มีอยู่แล้ว',
    PurchaseResult.shieldAlreadyFull => 'มีโล่ครบแล้ว',
    PurchaseResult.shieldAlreadyPurchasedThisWeek =>
      'ซื้อโล่ได้สัปดาห์ละ 1 อัน',
  };
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
