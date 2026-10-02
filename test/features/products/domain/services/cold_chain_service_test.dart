import 'package:flutter_test/flutter_test.dart';
import 'package:frozen_food/features/products/domain/entities/cold_chain_policy_entity.dart';
import 'package:frozen_food/features/delivery/domain/entities/delivery_slot_entity.dart';
import 'package:frozen_food/features/products/domain/services/cold_chain_validation_result.dart';
import 'package:frozen_food/features/products/domain/services/cold_chain_service.dart';

// Concrete implementation for testing
class ColdChainServiceImpl implements ColdChainService {
  @override
  ColdChainValidationResult validateSlotForPolicy({
    required ColdChainPolicyEntity policy,
    required DeliverySlotEntity slot,
  }) {
    List<ColdChainValidationFailureReason> reasons = [];

    if (policy.requiresSpecialHandling && !slot.coldChainSupported) {
      reasons.add(ColdChainValidationFailureReason.slotDoesNotSupportColdChain);
    }

    if (policy.requiresDryIce && !slot.dryIceSupported) {
      reasons.add(ColdChainValidationFailureReason.slotDoesNotSupportDryIce);
    }

    if (policy.hasMaxDeliveryLimit && 
        slot.maxDeliveryDurationMins > policy.maxDeliveryDurationMins!) {
      reasons.add(ColdChainValidationFailureReason.deliveryDurationExceedsMax);
    }

    if (reasons.isEmpty) {
      return ColdChainValidationResult.valid();
    }

    return ColdChainValidationResult.invalid(
      reasons: reasons,
      userFacingMessage: 'This delivery slot cannot safely transport this item.',
    );
  }

  @override
  ColdChainValidationResult validateCartColdChain({
    required List<ColdChainPolicyEntity> policies,
    required DeliverySlotEntity slot,
  }) {
    throw UnimplementedError();
  }

  @override
  bool isTemperatureAcceptable({
    required double currentTemperature,
    required ColdChainPolicyEntity policy,
  }) {
    return policy.acceptableDeliveryTemperatureRange.contains(currentTemperature);
  }
}

void main() {
  late ColdChainService service;

  final frozenPolicy = ColdChainPolicyEntity(
    storageTemperatureRange: const TemperatureRange(min: -25, max: -18),
    acceptableDeliveryTemperatureRange: const TemperatureRange(min: -20, max: -12),
    shelfLifeDays: 180,
    requiresDryIce: false,
    requiresIcePack: true,
    maxDeliveryDurationMins: 120,
  );

  final dryIcePolicy = ColdChainPolicyEntity(
    storageTemperatureRange: const TemperatureRange(min: -30, max: -25),
    acceptableDeliveryTemperatureRange: const TemperatureRange(min: -25, max: -20),
    shelfLifeDays: 365,
    requiresDryIce: true,
    requiresIcePack: false,
    maxDeliveryDurationMins: 240,
  );

  final coldChainSlot = DeliverySlotEntity(
    id: 'slot_001',
    date: DateTime.now().add(const Duration(days: 1)),
    startTime: DateTime.now().add(const Duration(hours: 10)),
    endTime: DateTime.now().add(const Duration(hours: 12)),
    totalCapacity: 20,
    remainingCapacity: 10,
    deliveryFee: 150,
    maxDeliveryDurationMins: 150,
    temperatureGuaranteeLevel: TemperatureGuaranteeLevel.frozen,
    coldChainSupported: true,
    dryIceSupported: true,
    isActive: true,
  );

  setUp(() {
    service = ColdChainServiceImpl();
  });

  group('validateSlotForPolicy', () {
    test('returns valid when slot supports cold chain and meets requirements', () {
      final result = service.validateSlotForPolicy(
        policy: frozenPolicy,
        slot: coldChainSlot,
      );
      expect(result.isValid, isTrue);
    });

    test('returns invalid when dry ice required but slot does not support it', () {
      final noDryIceSlot = DeliverySlotEntity(
        id: 'slot_003',
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: DateTime.now().add(const Duration(hours: 10)),
        endTime: DateTime.now().add(const Duration(hours: 12)),
        totalCapacity: 20,
        remainingCapacity: 10,
        deliveryFee: 150,
        maxDeliveryDurationMins: 150,
        temperatureGuaranteeLevel: TemperatureGuaranteeLevel.frozen,
        coldChainSupported: true,
        dryIceSupported: false, // No dry ice
        isActive: true,
      );

      final result = service.validateSlotForPolicy(
        policy: dryIcePolicy,
        slot: noDryIceSlot,
      );

      expect(result.isValid, isFalse);
      expect(
        result.failureReasons,
        contains(ColdChainValidationFailureReason.slotDoesNotSupportDryIce),
      );
    });

    test('returns invalid when delivery duration exceeds max allowed', () {
      final longDurationSlot = DeliverySlotEntity(
        id: 'slot_004',
        date: DateTime.now().add(const Duration(days: 1)),
        startTime: DateTime.now().add(const Duration(hours: 10)),
        endTime: DateTime.now().add(const Duration(hours: 14)),
        totalCapacity: 20,
        remainingCapacity: 10,
        deliveryFee: 150,
        maxDeliveryDurationMins: 240, // 4 hours — exceeds frozenPolicy max of 120 mins
        temperatureGuaranteeLevel: TemperatureGuaranteeLevel.frozen,
        coldChainSupported: true,
        dryIceSupported: false,
        isActive: true,
      );

      final result = service.validateSlotForPolicy(
        policy: frozenPolicy,
        slot: longDurationSlot,
      );

      expect(result.isValid, isFalse);
      expect(
        result.failureReasons,
        contains(ColdChainValidationFailureReason.deliveryDurationExceedsMax),
      );
    });
  });
}
