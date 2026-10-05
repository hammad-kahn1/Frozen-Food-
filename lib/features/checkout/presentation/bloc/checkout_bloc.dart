import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../orders/domain/usecases/order_usecases.dart';
import 'checkout_event.dart';
import 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final PlaceOrder _placeOrder;

  CheckoutBloc({
    required PlaceOrder placeOrder,
  })  : _placeOrder = placeOrder,
        super(const CheckoutState()) {
    on<PlaceCheckoutOrder>(_onPlaceCheckoutOrder);
  }

  Future<void> _onPlaceCheckoutOrder(
    PlaceCheckoutOrder event,
    Emitter<CheckoutState> emit,
  ) async {
    emit(state.copyWith(status: CheckoutStatus.loading));
    final result = await _placeOrder(event.order);

    result.fold(
      (failure) => emit(state.copyWith(status: CheckoutStatus.error, failure: failure)),
      (order) => emit(state.copyWith(status: CheckoutStatus.success, placedOrder: order)),
    );
  }
}
