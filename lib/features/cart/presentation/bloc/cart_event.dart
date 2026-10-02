import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_item_entity.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();
  @override
  List<Object?> get props => [];
}

class CartStarted extends CartEvent {
  final String? userId;
  const CartStarted({this.userId});
  @override
  List<Object?> get props => [userId];
}

class CartItemAdded extends CartEvent {
  final CartItemEntity item;
  const CartItemAdded({required this.item});
  @override
  List<Object?> get props => [item];
}

class CartItemRemoved extends CartEvent {
  final String productId;
  final String variantId;
  const CartItemRemoved({required this.productId, required this.variantId});
  @override
  List<Object?> get props => [productId, variantId];
}

class CartItemQuantityIncreased extends CartEvent {
  final String productId;
  final String variantId;
  const CartItemQuantityIncreased({required this.productId, required this.variantId});
  @override
  List<Object?> get props => [productId, variantId];
}

class CartItemQuantityDecreased extends CartEvent {
  final String productId;
  final String variantId;
  const CartItemQuantityDecreased({required this.productId, required this.variantId});
  @override
  List<Object?> get props => [productId, variantId];
}

class CartItemQuantityChanged extends CartEvent {
  final String productId;
  final String variantId;
  final int quantity;
  const CartItemQuantityChanged({
    required this.productId,
    required this.variantId,
    required this.quantity,
  });
  @override
  List<Object?> get props => [productId, variantId, quantity];
}

class CartCleared extends CartEvent {
  const CartCleared();
}

class CartSynced extends CartEvent {
  final String userId;
  const CartSynced({required this.userId});
  @override
  List<Object?> get props => [userId];
}

class CartRefreshed extends CartEvent {
  const CartRefreshed();
}
