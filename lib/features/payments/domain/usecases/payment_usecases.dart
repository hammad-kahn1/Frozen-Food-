import '../../../../core/result/result.dart';
import '../entities/payment_intent_entity.dart';
import '../repositories/payment_repository.dart';

class CreatePaymentIntent {
  final PaymentRepository repository;
  const CreatePaymentIntent(this.repository);

  FutureResult<PaymentIntentEntity> call({required double amount, required String currency}) {
    return repository.createPaymentIntent(amount: amount, currency: currency);
  }
}

class ConfirmPayment {
  final PaymentRepository repository;
  const ConfirmPayment(this.repository);

  FutureResult<void> call({required String clientSecret}) {
    return repository.confirmPayment(clientSecret: clientSecret);
  }
}
