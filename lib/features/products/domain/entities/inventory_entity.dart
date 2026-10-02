import 'package:equatable/equatable.dart';

enum StockStatus { inStock, lowStock, outOfStock }

class InventoryEntity extends Equatable {
  final String variantId;
  final int quantity;
  final int lowStockThreshold;

  const InventoryEntity({
    required this.variantId,
    required this.quantity,
    this.lowStockThreshold = 5,
  });

  StockStatus get status {
    if (quantity <= 0) return StockStatus.outOfStock;
    if (quantity <= lowStockThreshold) return StockStatus.lowStock;
    return StockStatus.inStock;
  }

  bool get isAvailable => quantity > 0;
  bool get isLowStock => status == StockStatus.lowStock;

  @override
  List<Object?> get props => [variantId, quantity, lowStockThreshold];
}
