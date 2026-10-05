import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/delivery_slot_entity.dart';

enum DeliveryStatus { initial, loading, loaded, error }

class DeliveryState extends Equatable {
  final DeliveryStatus status;
  final List<DeliverySlotEntity> slots;
  final DateTime selectedDate;
  final Failure? failure;

  const DeliveryState({
    this.status = DeliveryStatus.initial,
    this.slots = const [],
    required this.selectedDate,
    this.failure,
  });

  DeliveryState copyWith({
    DeliveryStatus? status,
    List<DeliverySlotEntity>? slots,
    DateTime? selectedDate,
    Failure? failure,
  }) {
    return DeliveryState(
      status: status ?? this.status,
      slots: slots ?? this.slots,
      selectedDate: selectedDate ?? this.selectedDate,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [status, slots, selectedDate, failure];
}
