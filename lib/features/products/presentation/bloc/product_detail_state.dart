import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../../../../core/errors/failures.dart';

enum ProductDetailStatus { initial, loading, loaded, error }

class ProductDetailState extends Equatable {
  final ProductDetailStatus status;
  final ProductEntity? product;
  final ProductVariantEntity? selectedVariant;
  final int quantity;
  final bool isWishlisted;
  final Failure? failure;

  const ProductDetailState({
    this.status = ProductDetailStatus.initial,
    this.product,
    this.selectedVariant,
    this.quantity = 1,
    this.isWishlisted = false,
    this.failure,
  });

  ProductDetailState copyWith({
    ProductDetailStatus? status,
    ProductEntity? product,
    ProductVariantEntity? selectedVariant,
    int? quantity,
    bool? isWishlisted,
    Failure? failure,
  }) {
    return ProductDetailState(
      status: status ?? this.status,
      product: product ?? this.product,
      selectedVariant: selectedVariant ?? this.selectedVariant,
      quantity: quantity ?? this.quantity,
      isWishlisted: isWishlisted ?? this.isWishlisted,
      failure: failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, product, selectedVariant, quantity, isWishlisted, failure];
}
