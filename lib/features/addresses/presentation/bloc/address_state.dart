import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';
import '../../../../core/errors/failures.dart';

enum AddressStatus { initial, loading, loaded, error, success }

class AddressState extends Equatable {
  final AddressStatus status;
  final List<AddressEntity> addresses;
  final Failure? failure;
  final String? successMessage;

  const AddressState({
    this.status = AddressStatus.initial,
    this.addresses = const [],
    this.failure,
    this.successMessage,
  });

  AddressState copyWith({
    AddressStatus? status,
    List<AddressEntity>? addresses,
    Failure? failure,
    String? successMessage,
  }) {
    return AddressState(
      status: status ?? this.status,
      addresses: addresses ?? this.addresses,
      failure: failure,
      successMessage: successMessage,
    );
  }

  AddressEntity? get defaultAddress {
    try {
      return addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return addresses.isNotEmpty ? addresses.first : null;
    }
  }

  @override
  List<Object?> get props => [status, addresses, failure, successMessage];
}
