import '../../../../core/result/result.dart';
import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class PlaceOrder {
  final OrderRepository repository;
  const PlaceOrder(this.repository);

  FutureResult<OrderEntity> call(OrderEntity order) => repository.placeOrder(order);
}

class GetUserOrders {
  final OrderRepository repository;
  const GetUserOrders(this.repository);

  FutureResult<List<OrderEntity>> call(String userId) => repository.getUserOrders(userId);
}
