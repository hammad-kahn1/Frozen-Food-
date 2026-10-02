import 'package:equatable/equatable.dart';

enum TemperatureGuaranteeLevel {
  standard,
  chilled,
  frozen,
  ultraFrozen,
}

class DeliverySlotEntity extends Equatable {
  final String id;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final int totalCapacity;
  final int remainingCapacity;
  final double deliveryFee;
  final int maxDeliveryDurationMins;
  final TemperatureGuaranteeLevel temperatureGuaranteeLevel;
  final bool coldChainSupported;
  final bool dryIceSupported;
  final bool isActive;

  const DeliverySlotEntity({
    required this.id,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.totalCapacity,
    required this.remainingCapacity,
    required this.deliveryFee,
    required this.maxDeliveryDurationMins,
    required this.temperatureGuaranteeLevel,
    required this.coldChainSupported,
    required this.dryIceSupported,
    required this.isActive,
  });

  bool get isAvailable => isActive && remainingCapacity > 0;
  bool get isFull => remainingCapacity <= 0;
  bool get isAlmostFull => remainingCapacity <= 3 && remainingCapacity > 0;

  String get timeRangeDisplay {
    final start = '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final end = '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$start - $end';
  }

  @override
  List<Object?> get props => [
        id, date, startTime, endTime, totalCapacity, remainingCapacity,
        deliveryFee, maxDeliveryDurationMins, temperatureGuaranteeLevel,
        coldChainSupported, dryIceSupported, isActive,
      ];
}
