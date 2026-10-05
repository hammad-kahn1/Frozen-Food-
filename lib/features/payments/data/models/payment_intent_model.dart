import '../../domain/entities/payment_intent_entity.dart';

class PaymentIntentModel extends PaymentIntentEntity {
  const PaymentIntentModel({
    required super.id,
    required super.clientSecret,
    required super.amount,
    required super.currency,
  });

  factory PaymentIntentModel.fromJson(Map<String, dynamic> json) {
    return PaymentIntentModel(
      id: json['id'],
      clientSecret: json['client_secret'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
    );
  }

  PaymentIntentEntity toEntity() => this;
}
