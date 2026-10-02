import '../../../../core/result/result.dart';
import '../entities/cart_entity.dart';
import '../entities/cart_item_entity.dart';

abstract class CartRepository {
  FutureResult<CartEntity> getCart(String? userId);
  FutureResult<CartEntity> addItem(CartItemEntity item);
  FutureResult<CartEntity> removeItem(String productId, String variantId);
  FutureResult<CartEntity> updateItemQuantity(
      String productId, String variantId, int quantity);
  FutureResult<CartEntity> clearCart();
  FutureResult<CartEntity> syncCartWithServer(String userId);
  FutureResult<void> saveCartLocally(CartEntity cart);
}
