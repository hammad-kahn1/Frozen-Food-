import 'package:equatable/equatable.dart';

enum ColdChainValidationFailureReason {
  slotCapacityExceeded,
  slotDoesNotSupportColdChain,
  slotDoesNotSupportDryIce,
  deliveryDurationExceedsMax,
  temperatureGuaranteeLevelInsufficient,
  slotUnavailable,
}

class ColdChainValidationResult extends Equatable {
  final bool isValid;
  final List<ColdChainValidationFailureReason> failureReasons;
  final String? userFacingMessage;

  const ColdChainValidationResult._({
    required this.isValid,
    required this.failureReasons,
    this.userFacingMessage,
  });

  factory ColdChainValidationResult.valid() {
    return const ColdChainValidationResult._(
      isValid: true,
      failureReasons: [],
    );
  }

  factory ColdChainValidationResult.invalid({
    required List<ColdChainValidationFailureReason> reasons,
    required String userFacingMessage,
  }) {
    return ColdChainValidationResult._(
      isValid: false,
      failureReasons: reasons,
      userFacingMessage: userFacingMessage,
    );
  }

  @override
  List<Object?> get props => [isValid, failureReasons, userFacingMessage];
}
