import 'package:equatable/equatable.dart';

class PaymentIntentEntity extends Equatable {
  final String id;
  final String clientSecret;
  final double amount;
  final String currency;

  const PaymentIntentEntity({
    required this.id,
    required this.clientSecret,
    required this.amount,
    required this.currency,
  });

  @override
  List<Object?> get props => [id, clientSecret, amount, currency];
}
