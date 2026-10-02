import 'package:equatable/equatable.dart';

class OrderItemEntity extends Equatable {
  final String productId;
  final String variantId;
  final String productName;
  final String variantName;
  final String? imageUrl;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final bool coldChainRequired;
  final bool requiresDryIce;

  const OrderItemEntity({
    required this.productId,
    required this.variantId,
    required this.productName,
    required this.variantName,
    this.imageUrl,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.coldChainRequired = true,
    this.requiresDryIce = false,
  });

  @override
  List<Object?> get props => [
        productId, variantId, productName, variantName,
        imageUrl, quantity, unitPrice, totalPrice, 
        coldChainRequired, requiresDryIce,
      ];
}
