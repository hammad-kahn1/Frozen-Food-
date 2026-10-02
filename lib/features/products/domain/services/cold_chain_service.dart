import '../entities/cold_chain_policy_entity.dart';
import '../../../delivery/domain/entities/delivery_slot_entity.dart';
import 'cold_chain_validation_result.dart';

abstract class ColdChainService {
  ColdChainValidationResult validateSlotForPolicy({
    required ColdChainPolicyEntity policy,
    required DeliverySlotEntity slot,
  });

  ColdChainValidationResult validateCartColdChain({
    required List<ColdChainPolicyEntity> policies,
    required DeliverySlotEntity slot,
  });

  bool isTemperatureAcceptable({
    required double currentTemperature,
    required ColdChainPolicyEntity policy,
  });
}
