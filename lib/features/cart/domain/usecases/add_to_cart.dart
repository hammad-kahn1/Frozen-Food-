import 'package:equatable/equatable.dart';
import '../../../../core/result/result.dart';
import '../../../../core/errors/failures.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';
import '../repositories/cart_repository.dart';
import 'package:dartz/dartz.dart';

class AddToCartParams extends Equatable {
  final CartItemEntity item;
  const AddToCartParams({required this.item});
  @override
  List<Object?> get props => [item];
}

class AddToCart {
  final CartRepository repository;
  const AddToCart(this.repository);

  FutureResult<CartEntity> call(AddToCartParams params) async {
    if (params.item.quantity <= 0) {
      return const Left(
        ValidationFailure(message: 'Quantity must be at least 1.'),
      );
    }
    if (params.item.unitPrice < 0) {
      return const Left(
        ValidationFailure(message: 'Invalid item price.'),
      );
    }
    return repository.addItem(params.item);
  }
}
