import 'package:equatable/equatable.dart';

enum ThawingMethod { refrigerator, coldWater, microwave, countertop }
enum TemperatureUnit { celsius, fahrenheit }

class TemperatureRange extends Equatable {
  final double min;
  final double max;
  final TemperatureUnit unit;

  const TemperatureRange({
    required this.min,
    required this.max,
    this.unit = TemperatureUnit.celsius,
  });

  bool contains(double temperature) => temperature >= min && temperature <= max;

  String get displayString => '${min.toStringAsFixed(0)}°C to ${max.toStringAsFixed(0)}°C';

  @override
  List<Object?> get props => [min, max, unit];
}

class ColdChainPolicyEntity extends Equatable {
  final TemperatureRange storageTemperatureRange;
  final TemperatureRange acceptableDeliveryTemperatureRange;
  final int shelfLifeDays;
  final bool requiresDryIce;
  final bool requiresIcePack;
  final int? maxDeliveryDurationMins;
  final List<ThawingMethod> supportedThawingMethods;
  final int? thawTimeMins;
  final String? thawingInstructions;
  final String? storageInstructions;
  final String? temperatureGuaranteeStatement;

  const ColdChainPolicyEntity({
    required this.storageTemperatureRange,
    required this.acceptableDeliveryTemperatureRange,
    required this.shelfLifeDays,
    this.requiresDryIce = false,
    this.requiresIcePack = true,
    this.maxDeliveryDurationMins,
    this.supportedThawingMethods = const [ThawingMethod.refrigerator],
    this.thawTimeMins,
    this.thawingInstructions,
    this.storageInstructions,
    this.temperatureGuaranteeStatement,
  });

  bool get requiresSpecialHandling => requiresDryIce || requiresIcePack;
  bool get hasMaxDeliveryLimit => maxDeliveryDurationMins != null;

  @override
  List<Object?> get props => [
        storageTemperatureRange,
        acceptableDeliveryTemperatureRange,
        shelfLifeDays,
        requiresDryIce,
        requiresIcePack,
        maxDeliveryDurationMins,
        supportedThawingMethods,
        thawTimeMins,
        thawingInstructions,
        storageInstructions,
        temperatureGuaranteeStatement,
      ];
}
