import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/delivery_slot_entity.dart';
import '../models/delivery_slot_model.dart';

abstract class DeliveryRemoteDataSource {
  Future<List<DeliverySlotModel>> getAvailableDeliverySlots(DateTime date, {bool requiresColdChain = false, bool requiresDryIce = false});
}

class DeliveryRemoteDataSourceImpl implements DeliveryRemoteDataSource {
  final FirebaseFirestore firestore;

  DeliveryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<DeliverySlotModel>> getAvailableDeliverySlots(DateTime date, {bool requiresColdChain = false, bool requiresDryIce = false}) async {
    try {
      // In a real app, query firestore by date.
      // For this blueprint, we'll return premium mock slots for the requested date.
      
      final today = DateTime(date.year, date.month, date.day);
      
      return [
        DeliverySlotModel(
          id: 'slot_1',
          date: today,
          startTime: today.add(const Duration(hours: 9)), // 09:00 AM
          endTime: today.add(const Duration(hours: 11)), // 11:00 AM
          totalCapacity: 10,
          remainingCapacity: 4,
          deliveryFee: 15.0,
          maxDeliveryDurationMins: 120,
          temperatureGuaranteeLevel: TemperatureGuaranteeLevel.frozen,
          coldChainSupported: true,
          dryIceSupported: true,
          isActive: true,
        ),
        DeliverySlotModel(
          id: 'slot_2',
          date: today,
          startTime: today.add(const Duration(hours: 12)), // 12:00 PM
          endTime: today.add(const Duration(hours: 14)), // 02:00 PM
          totalCapacity: 15,
          remainingCapacity: 1, // Almost full
          deliveryFee: 12.0,
          maxDeliveryDurationMins: 120,
          temperatureGuaranteeLevel: TemperatureGuaranteeLevel.frozen,
          coldChainSupported: true,
          dryIceSupported: true,
          isActive: true,
        ),
        DeliverySlotModel(
          id: 'slot_3',
          date: today,
          startTime: today.add(const Duration(hours: 15)), // 03:00 PM
          endTime: today.add(const Duration(hours: 17)), // 05:00 PM
          totalCapacity: 10,
          remainingCapacity: 8,
          deliveryFee: 12.0,
          maxDeliveryDurationMins: 120,
          temperatureGuaranteeLevel: TemperatureGuaranteeLevel.frozen,
          coldChainSupported: true,
          dryIceSupported: false,
          isActive: true,
        ),
        DeliverySlotModel(
          id: 'slot_4',
          date: today,
          startTime: today.add(const Duration(hours: 18)), // 06:00 PM
          endTime: today.add(const Duration(hours: 20)), // 08:00 PM
          totalCapacity: 8,
          remainingCapacity: 0, // Full
          deliveryFee: 20.0,
          maxDeliveryDurationMins: 90,
          temperatureGuaranteeLevel: TemperatureGuaranteeLevel.ultraFrozen,
          coldChainSupported: true,
          dryIceSupported: true,
          isActive: true,
        ),
      ].where((slot) {
        if (requiresColdChain && !slot.coldChainSupported) return false;
        if (requiresDryIce && !slot.dryIceSupported) return false;
        return true;
      }).toList();

    } catch (e) {
      throw ServerException(message: 'Failed to fetch delivery slots: $e');
    }
  }
}
