import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/usecases/add_to_cart.dart';
// Note: We use dynamic for missing usecases in this scaffold to allow it to compile without all files present
import 'cart_event.dart';
import 'cart_state.dart';

const int _maxItemQuantity = 20;

class CartBloc extends Bloc<CartEvent, CartState> {
  final AddToCart _addToCart;
  final dynamic _removeFromCart;
  final dynamic _updateQuantity;
  final dynamic _clearCart;
  final dynamic _getCart;
  final dynamic _syncCart;
  final dynamic _crashlytics;

  CartBloc({
    required AddToCart addToCart,
    required dynamic removeFromCart,
    required dynamic updateQuantity,
    required dynamic clearCart,
    required dynamic getCart,
    required dynamic syncCart,
    required dynamic crashlytics,
  })  : _addToCart = addToCart,
        _removeFromCart = removeFromCart,
        _updateQuantity = updateQuantity,
        _clearCart = clearCart,
        _getCart = getCart,
        _syncCart = syncCart,
        _crashlytics = crashlytics,
        super(CartState.initial()) {
    on<CartStarted>(_onCartStarted);
    on<CartItemAdded>(_onCartItemAdded);
    on<CartItemRemoved>(_onCartItemRemoved);
    on<CartItemQuantityIncreased>(_onQuantityIncreased);
    on<CartItemQuantityDecreased>(_onQuantityDecreased);
    on<CartItemQuantityChanged>(_onQuantityChanged);
    on<CartCleared>(_onCartCleared);
    on<CartSynced>(_onCartSynced);
    on<CartRefreshed>(_onCartRefreshed);
  }

  Future<void> _onCartStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(CartState.loading());
    final result = await _getCart(userId: event.userId);
    result.fold(
      (failure) => emit(CartState.error(null, failure)),
      (cart) => emit(CartState.loaded(cart)),
    );
  }

  Future<void> _onCartItemAdded(CartItemAdded event, Emitter<CartState> emit) async {
    final currentCart = state.cart;

    // Optimistic update
    if (currentCart != null) {
      final existingItem = currentCart.findItem(event.item.productId, event.item.variantId);
      final newQuantity = (existingItem?.quantity ?? 0) + event.item.quantity;
      if (newQuantity > _maxItemQuantity) {
        emit(CartState.error(
          currentCart,
          const ValidationFailure(message: 'Maximum quantity of 20 per item allowed.'),
        ));
        return;
      }
      emit(CartState.updating(currentCart, variantId: event.item.variantId));
    }

    final result = await _addToCart(AddToCartParams(item: event.item));
    result.fold(
      (failure) {
        // _crashlytics.recordError(failure);
        emit(CartState.error(currentCart, failure));
      },
      (cart) => emit(CartState.loaded(cart)),
    );
  }

  Future<void> _onCartItemRemoved(CartItemRemoved event, Emitter<CartState> emit) async {
    final currentCart = state.cart;
    if (currentCart != null) emit(CartState.updating(currentCart, variantId: event.variantId));
    final result = await _removeFromCart(productId: event.productId, variantId: event.variantId);
    result.fold(
      (failure) => emit(CartState.error(currentCart, failure)),
      (cart) => emit(CartState.loaded(cart)),
    );
  }

  Future<void> _onQuantityIncreased(CartItemQuantityIncreased event, Emitter<CartState> emit) async {
    final currentCart = state.cart;
    if (currentCart == null) return;
    final item = currentCart.findItem(event.productId, event.variantId);
    if (item == null) return;
    if (item.quantity >= _maxItemQuantity) {
      emit(CartState.error(currentCart, const ValidationFailure(message: 'Maximum quantity reached.')));
      return;
    }
    add(CartItemQuantityChanged(productId: event.productId, variantId: event.variantId, quantity: item.quantity + 1));
  }

  Future<void> _onQuantityDecreased(CartItemQuantityDecreased event, Emitter<CartState> emit) async {
    final currentCart = state.cart;
    if (currentCart == null) return;
    final item = currentCart.findItem(event.productId, event.variantId);
    if (item == null) return;
    if (item.quantity <= 1) {
      add(CartItemRemoved(productId: event.productId, variantId: event.variantId));
      return;
    }
    add(CartItemQuantityChanged(productId: event.productId, variantId: event.variantId, quantity: item.quantity - 1));
  }

  Future<void> _onQuantityChanged(CartItemQuantityChanged event, Emitter<CartState> emit) async {
    final currentCart = state.cart;
    if (currentCart != null) emit(CartState.updating(currentCart, variantId: event.variantId));
    final result = await _updateQuantity(productId: event.productId, variantId: event.variantId, quantity: event.quantity);
    result.fold(
      (failure) => emit(CartState.error(currentCart, failure)),
      (cart) => emit(CartState.loaded(cart)),
    );
  }

  Future<void> _onCartCleared(CartCleared event, Emitter<CartState> emit) async {
    final result = await _clearCart();
    result.fold(
      (failure) => emit(CartState.error(state.cart, failure)),
      (cart) => emit(CartState.loaded(cart)),
    );
  }

  Future<void> _onCartSynced(CartSynced event, Emitter<CartState> emit) async {
    emit(state.copyWith(isSyncing: true));
    final result = await _syncCart(userId: event.userId);
    result.fold(
      (failure) => emit(state.copyWith(isSyncing: false)),
      (cart) => emit(CartState.loaded(cart).copyWith(isSyncing: false)),
    );
  }

  Future<void> _onCartRefreshed(CartRefreshed event, Emitter<CartState> emit) async {
    final result = await _getCart(userId: null);
    result.fold(
      (failure) => emit(CartState.error(state.cart, failure)),
      (cart) => emit(CartState.loaded(cart)),
    );
  }
}
