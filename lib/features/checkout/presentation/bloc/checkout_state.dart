import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../orders/domain/entities/order_entity.dart';

enum CheckoutStatus { initial, loading, success, error }

class CheckoutState extends Equatable {
  final CheckoutStatus status;
  final OrderEntity? placedOrder;
  final Failure? failure;

  const CheckoutState({
    this.status = CheckoutStatus.initial,
    this.placedOrder,
    this.failure,
  });

  CheckoutState copyWith({
    CheckoutStatus? status,
    OrderEntity? placedOrder,
    Failure? failure,
  }) {
    return CheckoutState(
      status: status ?? this.status,
      placedOrder: placedOrder ?? this.placedOrder,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, placedOrder, failure];
}
