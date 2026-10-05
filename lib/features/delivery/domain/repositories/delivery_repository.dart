import '../../../../core/result/result.dart';
import '../entities/delivery_slot_entity.dart';

abstract class DeliveryRepository {
  FutureResult<List<DeliverySlotEntity>> getAvailableDeliverySlots(DateTime date, {bool requiresColdChain = false, bool requiresDryIce = false});
}
