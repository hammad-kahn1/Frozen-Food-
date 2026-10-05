import '../../../../core/result/result.dart';
import '../entities/order_entity.dart';

abstract class OrderRepository {
  FutureResult<OrderEntity> placeOrder(OrderEntity order);
  FutureResult<List<OrderEntity>> getUserOrders(String userId);
}
