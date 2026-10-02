import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frozen_food/core/errors/failures.dart';
import 'package:frozen_food/features/cart/domain/entities/cart_entity.dart';
import 'package:frozen_food/features/cart/domain/entities/cart_item_entity.dart';
import 'package:frozen_food/features/cart/domain/usecases/add_to_cart.dart';
import 'package:frozen_food/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:frozen_food/features/cart/presentation/bloc/cart_event.dart';
import 'package:frozen_food/features/cart/presentation/bloc/cart_state.dart';

// Mocks
class MockAddToCart extends Mock implements AddToCart {}
class MockRemoveFromCart extends Mock {}
class MockUpdateQuantity extends Mock {}
class MockClearCart extends Mock {}
class MockGetCart extends Mock {}
class MockSyncCart extends Mock {}
class MockCrashlytics extends Mock {}

void main() {
  late CartBloc cartBloc;
  late MockAddToCart mockAddToCart;
  late MockGetCart mockGetCart;

  final testCartItem = CartItemEntity(
    productId: 'prod_001',
    variantId: 'var_001_500g',
    productName: 'Test Kebab',
    variantName: '500g',
    imageUrl: 'https://example.com/image.jpg',
    quantity: 1,
    unitPrice: 850.0,
    coldChainRequired: true,
    requiresDryIce: false,
  );

  final emptyCart = CartEntity(
    items: const [],
    lastSyncedAt: DateTime(2024, 1, 1),
  );

  final cartWithItem = CartEntity(
    items: [testCartItem],
    lastSyncedAt: DateTime(2024, 1, 1),
  );

  setUp(() {
    mockAddToCart = MockAddToCart();
    mockGetCart = MockGetCart();
    
    // Using dynamic for missing implementations in this scaffold
    cartBloc = CartBloc(
      addToCart: mockAddToCart,
      removeFromCart: MockRemoveFromCart(),
      updateQuantity: MockUpdateQuantity(),
      clearCart: MockClearCart(),
      getCart: mockGetCart,
      syncCart: MockSyncCart(),
      crashlytics: MockCrashlytics(),
    );
  });

  tearDown(() => cartBloc.close());

  group('CartStarted', () {
    // Note: because we're using 'dynamic' in the scaffold for getCart,
    // this test acts as a structural reference.
    blocTest<CartBloc, CartState>(
      'emits [loading, error] on network failure',
      build: () {
        when(() => mockGetCart.call(userId: any(named: 'userId'))).thenAnswer(
          (_) async => const Left(NetworkFailure()),
        );
        return cartBloc;
      },
      act: (bloc) => bloc.add(const CartStarted()),
      expect: () => [
        CartState.loading(),
        CartState.error(null, const NetworkFailure()),
      ],
    );
  });

  group('CartItemAdded', () {
    blocTest<CartBloc, CartState>(
      'emits error when quantity exceeds max',
      build: () => cartBloc,
      seed: () {
        final maxQtyItem = testCartItem.copyWith(quantity: 20);
        final cartAtMax = CartEntity(
          items: [maxQtyItem],
          lastSyncedAt: DateTime(2024, 1, 1),
        );
        return CartState.loaded(cartAtMax);
      },
      act: (bloc) => bloc.add(CartItemAdded(item: testCartItem)),
      expect: () => [
        isA<CartState>().having((s) => s.status, 'status', CartStatus.error),
      ],
    );
  });
}
