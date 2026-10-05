import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_available_delivery_slots.dart';
import 'delivery_state.dart';

class DeliveryCubit extends Cubit<DeliveryState> {
  final GetAvailableDeliverySlots _getAvailableDeliverySlots;

  DeliveryCubit({
    required GetAvailableDeliverySlots getAvailableDeliverySlots,
  })  : _getAvailableDeliverySlots = getAvailableDeliverySlots,
        super(DeliveryState(selectedDate: DateTime.now()));

  Future<void> fetchSlotsForDate(DateTime date, {bool requiresColdChain = false, bool requiresDryIce = false}) async {
    emit(state.copyWith(status: DeliveryStatus.loading, selectedDate: date));
    
    final result = await _getAvailableDeliverySlots(
      date,
      requiresColdChain: requiresColdChain,
      requiresDryIce: requiresDryIce,
    );

    result.fold(
      (failure) => emit(state.copyWith(status: DeliveryStatus.error, failure: failure)),
      (slots) => emit(state.copyWith(status: DeliveryStatus.loaded, slots: slots)),
    );
  }

  void changeDate(DateTime newDate, {bool requiresColdChain = false, bool requiresDryIce = false}) {
    fetchSlotsForDate(newDate, requiresColdChain: requiresColdChain, requiresDryIce: requiresDryIce);
  }
}
