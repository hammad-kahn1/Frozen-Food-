import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';
import '../../../../core/errors/failures.dart';

enum CartStatus { initial, loading, loaded, empty, updating, error, offline }

class CartState extends Equatable {
  final CartStatus status;
  final CartEntity? cart;
  final Failure? failure;
  final bool isSyncing;
  final String? updatingItemVariantId;

  const CartState({
    this.status = CartStatus.initial,
    this.cart,
    this.failure,
    this.isSyncing = false,
    this.updatingItemVariantId,
  });

  factory CartState.initial() => const CartState(status: CartStatus.initial);
  factory CartState.loading() => const CartState(status: CartStatus.loading);
  factory CartState.loaded(CartEntity cart) => CartState(
        status: cart.isEmpty ? CartStatus.empty : CartStatus.loaded,
        cart: cart,
      );
  factory CartState.updating(CartEntity cart, {String? variantId}) => CartState(
        status: CartStatus.updating,
        cart: cart,
        updatingItemVariantId: variantId,
      );
  factory CartState.error(CartEntity? cart, Failure failure) => CartState(
        status: CartStatus.error,
        cart: cart,
        failure: failure,
      );
  factory CartState.offline(CartEntity cart) => CartState(
        status: CartStatus.offline,
        cart: cart,
      );

  CartState copyWith({
    CartStatus? status,
    CartEntity? cart,
    Failure? failure,
    bool? isSyncing,
    String? updatingItemVariantId,
  }) {
    return CartState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      failure: failure ?? this.failure,
      isSyncing: isSyncing ?? this.isSyncing,
      updatingItemVariantId: updatingItemVariantId ?? this.updatingItemVariantId,
    );
  }

  @override
  List<Object?> get props => [status, cart, failure, isSyncing, updatingItemVariantId];
}
