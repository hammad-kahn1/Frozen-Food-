import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final String? code;
  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'No internet connection.', String? code})
      : super(message: message, code: code);
}

class ServerFailure extends Failure {
  const ServerFailure({required String message, String? code})
      : super(message: message, code: code);
}

class AuthFailure extends Failure {
  const AuthFailure({required String message, String? code})
      : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;
  const ValidationFailure({required String message, this.fieldErrors, String? code})
      : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, fieldErrors];
}

class PermissionFailure extends Failure {
  const PermissionFailure({String message = 'Permission denied.', String? code})
      : super(message: message, code: code);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({String message = 'Resource not found.', String? code})
      : super(message: message, code: code);
}

class InventoryFailure extends Failure {
  final String productId;
  final String variantId;
  final int requestedQuantity;
  final int availableQuantity;

  const InventoryFailure({
    required String message,
    required this.productId,
    required this.variantId,
    required this.requestedQuantity,
    required this.availableQuantity,
    String? code,
  }) : super(message: message, code: code);

  @override
  List<Object?> get props =>
      [message, code, productId, variantId, requestedQuantity, availableQuantity];
}

class PaymentFailure extends Failure {
  final String? declineCode;
  const PaymentFailure({required String message, this.declineCode, String? code})
      : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, declineCode];
}

class ColdChainFailure extends Failure {
  final String? slotId;
  final String? productId;
  const ColdChainFailure({required String message, this.slotId, this.productId, String? code})
      : super(message: message, code: code);

  @override
  List<Object?> get props => [message, code, slotId, productId];
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Local cache error.', String? code})
      : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure({String message = 'An unexpected error occurred.', String? code})
      : super(message: message, code: code);
}
