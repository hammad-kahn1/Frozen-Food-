import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/payment_usecases.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentIntent _createPaymentIntent;
  final ConfirmPayment _confirmPayment;

  PaymentBloc({
    required CreatePaymentIntent createPaymentIntent,
    required ConfirmPayment confirmPayment,
  })  : _createPaymentIntent = createPaymentIntent,
        _confirmPayment = confirmPayment,
        super(const PaymentState()) {
    on<InitializePayment>(_onInitializePayment);
    on<ConfirmPaymentEvent>(_onConfirmPayment);
  }

  Future<void> _onInitializePayment(
    InitializePayment event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));
    final result = await _createPaymentIntent(
      amount: event.amount,
      currency: event.currency,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: PaymentStatus.error, failure: failure)),
      (intent) => emit(state.copyWith(status: PaymentStatus.intentCreated, paymentIntent: intent)),
    );
  }

  Future<void> _onConfirmPayment(
    ConfirmPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.processing));
    final result = await _confirmPayment(clientSecret: event.clientSecret);

    result.fold(
      (failure) => emit(state.copyWith(status: PaymentStatus.error, failure: failure)),
      (_) => emit(state.copyWith(status: PaymentStatus.success)),
    );
  }
}
