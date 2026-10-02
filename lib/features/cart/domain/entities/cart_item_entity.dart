import 'package:equatable/equatable.dart';

class CartItemEntity extends Equatable {
  final String productId;
  final String variantId;
  final String productName;
  final String variantName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final bool coldChainRequired;
  final bool requiresDryIce;

  const CartItemEntity({
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.variantName,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    this.coldChainRequired = true,
    this.requiresDryIce = false,
  });

  double get totalPrice => unitPrice * quantity;

  CartItemEntity copyWith({
    String? productId,
    String? variantId,
    String? productName,
    String? variantName,
    String? imageUrl,
    int? quantity,
    double? unitPrice,
    bool? coldChainRequired,
    bool? requiresDryIce,
  }) {
    return CartItemEntity(
      productId: productId ?? this.productId,
      variantId: variantId ?? this.variantId,
      productName: productName ?? this.productName,
      variantName: variantName ?? this.variantName,
      imageUrl: imageUrl ?? this.imageUrl,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      coldChainRequired: coldChainRequired ?? this.coldChainRequired,
      requiresDryIce: requiresDryIce ?? this.requiresDryIce,
    );
  }

  @override
  List<Object?> get props => [
        productId, variantId, productName, variantName,
        imageUrl, quantity, unitPrice, coldChainRequired, requiresDryIce,
      ];
}
