import '../../../../core/result/result.dart';
import '../entities/payment_intent_entity.dart';

abstract class PaymentRepository {
  FutureResult<PaymentIntentEntity> createPaymentIntent({
    required double amount,
    required String currency,
  });
  
  FutureResult<void> confirmPayment({
    required String clientSecret,
  });
}
