import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/card_config.dart';
import '../../core/economy_config.dart';
import '../../core/fire.dart';
import '../../data/shop_repository.dart';
import '../../data/wallet_repository.dart';
import '../../providers.dart';
import '../../services/app_clock.dart';
import '../../theme/tokens.dart';
import '../../theme/widgets/card_art.dart';
import '../../theme/widgets/glow_bottom_sheet.dart';
import '../../theme/widgets/glow_card.dart';
import '../../theme/widgets/glow_primary_button.dart';
import '../../theme/widgets/stat_tile.dart';
import '../card/card_details_sheet.dart';
import '../card/my_card.dart';
import '../guide/guide_button.dart';
import '../guide/info_button.dart';
import '../shared/settings_button.dart';
import 'blanket_color.dart';

final _ownedItemsStreamProvider = StreamProvider.autoDispose<Set<String>>((
  ref,
) {
  return ref.watch(walletRepositoryProvider).watchOwnedItemIds();
});

/// Every card color, the starting one first. These are the former blanket
/// colors, under the same ids.
List<BlanketConfig> get _allColors => [
  const BlanketConfig(defaultBlanketId, defaultBlanketColor, 0),
  ...EconomyConfig.blankets,
  ...EconomyConfig.fireLevelRewardBlankets.values,
  EconomyConfig.examPeriodRewardBlanket,
];

const _decorSections = [
  ('โลโก้', cardLogos),
  ('กรอบ', cardFrames),
  ('สติกเกอร์ (ติดได้ $maxCardStickers ชิ้น)', cardStickers),
];

/// Where the student card is dressed up: what's owned, and the shop.
class RoomScreen extends ConsumerStatefulWidget {
  const RoomScreen({super.key});

  @override
  ConsumerState<RoomScreen> createState() => _RoomScreenState();
}

class _RoomScreenState extends ConsumerState<RoomScreen> {
  bool _shop = false;

  @override
  Widget build(BuildContext context) {
    final fire = ref.watch(fireStateStreamProvider).value;
    final wallet = ref.watch(walletStreamProvider).value;
    final profile = ref.watch(cardProfileStreamProvider).value;
    final owned = ref.watch(_ownedItemsStreamProvider).value ?? const {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('บัตร'),
        actions: const [SettingsButton(), GuideButton()],
      ),
      body: ListView(
        padding: const EdgeInsets.all(GlowSpacing.pageMargin),
        children: [
          MyStudentCard(onTap: () => showCardDetailsSheet(context)),
          TextButton.icon(
            onPressed: () => showCardDetailsSheet(context),
            icon: const Icon(Icons.edit_outlined, size: 20),
            label: const Text('แก้โปรไฟล์ รูป และอวตาร'),
          ),
          const SizedBox(height: GlowSpacing.sm),
          Row(
            children: [
              Text('ไฟและโล่', style: Theme.of(context).textTheme.titleMedium),
              const InfoButton(GuideTip.fireAndShields),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              StatTile(value: '${wallet?.coins ?? 0}', label: 'เหรียญ'),
              StatTile(
                value: '${fire?.shields ?? 0}/$maxShields',
                label: 'โล่',
              ),
              StatTile(
                value: '${fire?.longestStreak ?? 0}',
                label: 'สตรีคยาวสุด',
              ),
            ],
          ),
          const SizedBox(height: GlowSpacing.xl),
          SegmentedButton<bool>(
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(value: false, label: Text('ของฉัน')),
              ButtonSegment(value: true, label: Text('ร้านค้า')),
            ],
            selected: {_shop},
            onSelectionChanged: (v) => setState(() => _shop = v.single),
          ),
          if (_shop) ...[
            const SizedBox(height: GlowSpacing.lg),
            _ShieldRow(onBuy: _buyShield),
          ],
          ..._colorSection(wallet?.equippedBlanketId, owned),
          for (final (title, items) in _decorSections)
            ..._decorSection(
              title,
              items,
              owned,
              inUse: {
                profile?.logoId ?? defaultLogoId,
                profile?.frameId ?? defaultFrameId,
                ...parseStickerIds(profile?.stickerIds ?? ''),
              },
              cardColor: blanketColorOf(wallet?.equippedBlanketId),
            ),
        ],
      ),
    );
  }

  List<Widget> _section(String title, List<Widget> tiles) => [
    const SizedBox(height: GlowSpacing.xl),
    Text(title, style: Theme.of(context).textTheme.titleMedium),
    const SizedBox(height: GlowSpacing.sm),
    if (tiles.isEmpty)
      Text('มีครบแล้ว', style: Theme.of(context).textTheme.bodyMedium)
    else
      GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        mainAxisSpacing: GlowSpacing.sm,
        crossAxisSpacing: GlowSpacing.sm,
        children: tiles,
      ),
  ];

  List<Widget> _colorSection(String? equippedId, Set<String> owned) {
    bool has(BlanketConfig c) =>
        c.id == defaultBlanketId || owned.contains(c.id);
    // Reward colors have no price and never appear in the shop.
    final colors = _shop
        ? EconomyConfig.blankets.where((c) => !has(c)).toList()
        : _allColors.where(has).toList();
    return _section('สีบัตร', [
      for (final (i, color) in colors.indexed)
        _ItemTile(
          label: 'สีบัตรแบบที่ ${i + 1}',
          fill: Color(color.colorValue),
          inUse: !_shop && color.id == (equippedId ?? defaultBlanketId),
          price: _shop ? color.priceCoins : null,
          onTap: () => _shop
              ? _buy(
                  'สีบัตรนี้',
                  color.priceCoins,
                  (shop, now) => shop.buyBlanket(color, now),
                )
              : ref.read(walletRepositoryProvider).equipBlanket(color.id),
        ),
    ]);
  }

  List<Widget> _decorSection(
    String title,
    List<CardDecor> items,
    Set<String> owned, {
    required Set<String> inUse,
    required Color cardColor,
  }) {
    bool has(CardDecor d) => d.isFree || owned.contains(d.id);
    return _section(title, [
      for (final decor in items.where((d) => _shop ? !has(d) : has(d)))
        _ItemTile(
          label: decor.name,
          inUse: !_shop && inUse.contains(decor.id),
          price: _shop ? decor.priceCoins : null,
          onTap: () => _shop
              ? _buy(
                  decor.name,
                  decor.priceCoins,
                  (shop, now) => shop.buyDecor(decor, now),
                )
              : ref.read(cardRepositoryProvider).use(decor),
          child: switch (decor.kind) {
            CardDecorKind.logo => CardLogo(decor.id, size: 40),
            CardDecorKind.sticker => CardSticker(decor.id, size: 44),
            CardDecorKind.frame => SizedBox(
              width: 72,
              height: 46,
              child: ColoredBox(
                color: cardColor,
                child: CustomPaint(
                  painter: CardFramePainter(decor.id, GlowBaseColors.ink),
                ),
              ),
            ),
          },
        ),
    ]);
  }

  Future<void> _buy(
    String name,
    int price,
    Future<PurchaseResult> Function(ShopRepository, DateTime) purchase,
  ) async {
    final shop = ref.read(shopRepositoryProvider);
    final now = ref.read(clockProvider)();
    if (!await _confirmPurchase(context, name, price)) return;
    final result = await purchase(shop, now);
    if (mounted) _showPurchaseSnackBar(context, result);
  }

  Future<void> _buyShield() => _buy(
    'โล่ 1 อัน',
    EconomyConfig.shieldPriceCoins,
    (shop, now) => shop.buyShield(now),
  );
}

class _ShieldRow extends StatelessWidget {
  final VoidCallback onBuy;

  const _ShieldRow({required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      onTap: onBuy,
      child: Row(
        children: [
          const Icon(Icons.shield_outlined),
          const SizedBox(width: GlowSpacing.md),
          Expanded(
            child: Text(
              'โล่ กันไฟลด 1 คืน',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            '${EconomyConfig.shieldPriceCoins} เหรียญ',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  /// Read out by screen readers.
  final String label;
  final Color? fill;
  final Widget? child;
  final bool inUse;
  final int? price;
  final VoidCallback onTap;

  const _ItemTile({
    required this.label,
    this.fill,
    this.child,
    required this.inUse,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Semantics(
      label: [
        label,
        if (price != null) '$price เหรียญ',
        if (inUse) 'ใช้อยู่',
      ].join(' '),
      button: true,
      selected: inUse,
      excludeSemantics: true,
      child: Material(
        color: fill ?? theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(GlowRadius.button),
          side: BorderSide(
            color: theme.colorScheme.outline,
            width: inUse ? GlowStroke.focus * 1.5 : GlowStroke.outline,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Stack(
            children: [
              if (child != null) Center(child: child),
              if (inUse)
                Positioned(
                  top: GlowSpacing.xs,
                  right: GlowSpacing.xs,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: theme.colorScheme.onSurface,
                    child: Icon(
                      Icons.check,
                      color: theme.colorScheme.surface,
                      size: 14,
                    ),
                  ),
                ),
              if (price != null)
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: GlowSpacing.xs),
                    padding: const EdgeInsets.symmetric(
                      horizontal: GlowSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(GlowRadius.pill),
                    ),
                    child: Text(
                      '$price เหรียญ',
                      style: theme.textTheme.labelSmall,
                    ),
                  ),
                ),
            ],
          ),
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
