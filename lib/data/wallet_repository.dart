import 'package:drift/drift.dart';

import 'database.dart';

const String defaultBlanketId = 'default';

/// Persists coins and owned/equipped items (CLAUDE.md section 12). Rewards
/// and prices themselves live in core/economy_config.dart.
class WalletRepository {
  final AppDatabase db;

  WalletRepository(this.db);

  Stream<WalletRow> watch() {
    return (db.select(
      db.wallets,
    )..where((t) => t.id.equals(0))).watchSingleOrNull().asyncMap((row) async {
      return row ?? await ensureRowExists();
    });
  }

  Future<WalletRow> get() async {
    final row = await (db.select(
      db.wallets,
    )..where((t) => t.id.equals(0))).getSingleOrNull();
    return row ?? await ensureRowExists();
  }

  Future<WalletRow> ensureRowExists() async {
    await db
        .into(db.wallets)
        .insert(
          const WalletsCompanion(id: Value(0)),
          mode: InsertMode.insertOrIgnore,
        );
    return await (db.select(
      db.wallets,
    )..where((t) => t.id.equals(0))).getSingle();
  }

  /// [delta] may be negative to spend coins — callers are responsible for
  /// checking the balance first (sections 8/9 never let a purchase or
  /// reward go negative); clamped at 0 as a last-resort guard.
  Future<void> addCoins(int delta) async {
    final current = await get();
    final next = (current.coins + delta).clamp(0, 1 << 31);
    await (db.update(db.wallets)..where((t) => t.id.equals(0))).write(
      WalletsCompanion(coins: Value(next)),
    );
  }

  Future<Set<String>> ownedItemIds() async {
    final rows = await db.select(db.ownedItems).get();
    return rows.map((r) => r.itemId).toSet();
  }

  Stream<Set<String>> watchOwnedItemIds() {
    return db
        .select(db.ownedItems)
        .watch()
        .map((rows) => rows.map((r) => r.itemId).toSet());
  }

  Future<bool> owns(String itemId) async {
    if (itemId == defaultBlanketId) return true;
    final row = await (db.select(
      db.ownedItems,
    )..where((t) => t.itemId.equals(itemId))).getSingleOrNull();
    return row != null;
  }

  Future<void> grantItem(String itemId, DateTime now) async {
    await db
        .into(db.ownedItems)
        .insert(
          OwnedItemsCompanion.insert(itemId: itemId, acquiredAt: now),
          mode: InsertMode.insertOrIgnore,
        );
  }

  /// No-ops if [itemId] isn't owned — callers should only offer equip for
  /// owned items, this is just a safety net.
  Future<bool> equipBlanket(String itemId) async {
    if (!await owns(itemId)) return false;
    await ensureRowExists();
    await (db.update(db.wallets)..where((t) => t.id.equals(0))).write(
      WalletsCompanion(equippedBlanketId: Value(itemId)),
    );
    return true;
  }
}
