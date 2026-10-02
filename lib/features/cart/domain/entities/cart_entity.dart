import 'package:equatable/equatable.dart';
import 'cart_item_entity.dart';

class CartEntity extends Equatable {
  final String? userId;
  final List<CartItemEntity> items;
  final DateTime lastSyncedAt;
  final bool isDirty;

  const CartEntity({
    this.userId,
    this.items = const [],
    required this.lastSyncedAt,
    this.isDirty = false,
  });

  bool get isEmpty => items.isEmpty;
  bool get isNotEmpty => items.isNotEmpty;
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  bool get requiresAnyDryIce => items.any((item) => item.requiresDryIce);
  bool get requiresColdChain => items.any((item) => item.coldChainRequired);

  CartItemEntity? findItem(String productId, String variantId) {
    try {
      return items.firstWhere(
        (item) => item.productId == productId && item.variantId == variantId,
      );
    } catch (_) {
      return null;
    }
  }

  bool containsItem(String productId, String variantId) =>
      findItem(productId, variantId) != null;

  CartEntity copyWith({
    String? userId,
    List<CartItemEntity>? items,
    DateTime? lastSyncedAt,
    bool? isDirty,
  }) {
    return CartEntity(
      userId: userId ?? this.userId,
      items: items ?? this.items,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  List<Object?> get props => [userId, items, lastSyncedAt, isDirty];
}
