import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/cart_item_entity.dart';

part 'cart_item_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CartItemModel {
  final String productId;
  final String variantId;
  final String productName;
  final String variantName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final bool coldChainRequired;
  final bool requiresDryIce;

  const CartItemModel({
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

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  factory CartItemModel.fromEntity(CartItemEntity entity) {
    return CartItemModel(
      productId: entity.productId,
      variantId: entity.variantId,
      productName: entity.productName,
      variantName: entity.variantName,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      unitPrice: entity.unitPrice,
      coldChainRequired: entity.coldChainRequired,
      requiresDryIce: entity.requiresDryIce,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      productId: productId,
      variantId: variantId,
      productName: productName,
      variantName: variantName,
      imageUrl: imageUrl,
      quantity: quantity,
      unitPrice: unitPrice,
      coldChainRequired: coldChainRequired,
      requiresDryIce: requiresDryIce,
    );
  }
}
