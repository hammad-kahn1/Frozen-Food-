import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/payment_intent_entity.dart';

enum PaymentStatus { initial, loading, intentCreated, processing, success, error }

class PaymentState extends Equatable {
  final PaymentStatus status;
  final PaymentIntentEntity? paymentIntent;
  final Failure? failure;

  const PaymentState({
    this.status = PaymentStatus.initial,
    this.paymentIntent,
    this.failure,
  });

  PaymentState copyWith({
    PaymentStatus? status,
    PaymentIntentEntity? paymentIntent,
    Failure? failure,
  }) {
    return PaymentState(
      status: status ?? this.status,
      paymentIntent: paymentIntent ?? this.paymentIntent,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, paymentIntent, failure];
}
