import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();
  @override
  List<Object?> get props => [];
}

class InitializePayment extends PaymentEvent {
  final double amount;
  final String currency;

  const InitializePayment({required this.amount, required this.currency});

  @override
  List<Object?> get props => [amount, currency];
}

class ConfirmPaymentEvent extends PaymentEvent {
  final String clientSecret;

  const ConfirmPaymentEvent({required this.clientSecret});

  @override
  List<Object?> get props => [clientSecret];
}
