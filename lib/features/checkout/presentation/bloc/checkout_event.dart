import 'package:equatable/equatable.dart';
import '../../../orders/domain/entities/order_entity.dart';

abstract class CheckoutEvent extends Equatable {
  const CheckoutEvent();
  @override
  List<Object?> get props => [];
}

class PlaceCheckoutOrder extends CheckoutEvent {
  final OrderEntity order;

  const PlaceCheckoutOrder(this.order);

  @override
  List<Object?> get props => [order];
}
