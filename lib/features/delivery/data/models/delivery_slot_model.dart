import '../../domain/entities/delivery_slot_entity.dart';

class DeliverySlotModel extends DeliverySlotEntity {
  const DeliverySlotModel({
    required super.id,
    required super.date,
    required super.startTime,
    required super.endTime,
    required super.totalCapacity,
    required super.remainingCapacity,
    required super.deliveryFee,
    required super.maxDeliveryDurationMins,
    required super.temperatureGuaranteeLevel,
    required super.coldChainSupported,
    required super.dryIceSupported,
    required super.isActive,
  });

  factory DeliverySlotModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return DeliverySlotModel(
      id: docId,
      date: _parseTimestamp(json['date']),
      startTime: _parseTimestamp(json['startTime']),
      endTime: _parseTimestamp(json['endTime']),
      totalCapacity: json['totalCapacity'] ?? 0,
      remainingCapacity: json['remainingCapacity'] ?? 0,
      deliveryFee: (json['deliveryFee'] as num?)?.toDouble() ?? 0.0,
      maxDeliveryDurationMins: json['maxDeliveryDurationMins'] ?? 120,
      temperatureGuaranteeLevel: _parseTempGuarantee(json['temperatureGuaranteeLevel']),
      coldChainSupported: json['coldChainSupported'] ?? true,
      dryIceSupported: json['dryIceSupported'] ?? false,
      isActive: json['isActive'] ?? true,
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  static TemperatureGuaranteeLevel _parseTempGuarantee(String? val) {
    switch (val) {
      case 'chilled': return TemperatureGuaranteeLevel.chilled;
      case 'frozen': return TemperatureGuaranteeLevel.frozen;
      case 'ultraFrozen': return TemperatureGuaranteeLevel.ultraFrozen;
      case 'standard':
      default: return TemperatureGuaranteeLevel.standard;
    }
  }

  DeliverySlotEntity toEntity() => this;
}
