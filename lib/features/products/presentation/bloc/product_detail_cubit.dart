import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product_variant_entity.dart';
import 'product_detail_state.dart';
import 'package:dartz/dartz.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final dynamic _getProductById;

  ProductDetailCubit({required dynamic getProductById})
      : _getProductById = getProductById,
        super(const ProductDetailState());

  Future<void> loadProduct(String productId) async {
    emit(state.copyWith(status: ProductDetailStatus.loading));
    final result = await _getProductById(id: productId);
    
    // Simulate dartz fold since _getProductById is dynamically typed for this scaffold
    if (result is Left) {
      emit(state.copyWith(status: ProductDetailStatus.error, failure: result.fold((l) => l, (r) => null)));
    } else {
      final product = result.fold((l) => null, (r) => r);
      emit(state.copyWith(
        status: ProductDetailStatus.loaded,
        product: product,
        selectedVariant: product?.defaultVariant,
        quantity: 1,
      ));
    }
  }

  void selectVariant(ProductVariantEntity variant) {
    emit(state.copyWith(selectedVariant: variant, quantity: 1));
  }

  void incrementQuantity() {
    const maxQty = 20;
    if (state.quantity < maxQty) {
      emit(state.copyWith(quantity: state.quantity + 1));
    }
  }

  void decrementQuantity() {
    if (state.quantity > 1) {
      emit(state.copyWith(quantity: state.quantity - 1));
    }
  }

  void toggleWishlist() {
    emit(state.copyWith(isWishlisted: !state.isWishlisted));
  }
}
