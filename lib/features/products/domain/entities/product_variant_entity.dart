import 'package:equatable/equatable.dart';

enum WeightUnit { g, kg, ml, l, oz, lb, piece }

class ProductVariantEntity extends Equatable {
  final String id;
  final String productId;
  final String name;
  final double weight;
  final WeightUnit weightUnit;
  final double price;
  final double? compareAtPrice;
  final String sku;
  final String? barcode;
  final bool isAvailable;
  final int sortOrder;

  const ProductVariantEntity({
    required this.id,
    required this.productId,
    required this.name,
    required this.weight,
    required this.weightUnit,
    required this.price,
    this.compareAtPrice,
    required this.sku,
    this.barcode,
    this.isAvailable = true,
    this.sortOrder = 0,
  });

  bool get hasDiscount =>
      compareAtPrice != null && compareAtPrice! > price;

  double get discountPercent {
    if (!hasDiscount) return 0;
    return ((compareAtPrice! - price) / compareAtPrice! * 100);
  }

  String get weightDisplay {
    final suffix = weightUnit.name;
    final value = weight == weight.truncateToDouble()
        ? weight.toInt().toString()
        : weight.toString();
    return '$value$suffix';
  }

  @override
  List<Object?> get props => [
        id, productId, name, weight, weightUnit, price,
        compareAtPrice, sku, barcode, isAvailable, sortOrder,
      ];
}
