import '../../../../core/result/result.dart';
import '../entities/delivery_slot_entity.dart';
import '../repositories/delivery_repository.dart';

class GetAvailableDeliverySlots {
  final DeliveryRepository repository;
  const GetAvailableDeliverySlots(this.repository);

  FutureResult<List<DeliverySlotEntity>> call(DateTime date, {bool requiresColdChain = false, bool requiresDryIce = false}) {
    return repository.getAvailableDeliverySlots(date, requiresColdChain: requiresColdChain, requiresDryIce: requiresDryIce);
  }
}
