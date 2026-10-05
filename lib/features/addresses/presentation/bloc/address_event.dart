import 'package:equatable/equatable.dart';
import '../../domain/entities/address_entity.dart';

abstract class AddressEvent extends Equatable {
  const AddressEvent();

  @override
  List<Object?> get props => [];
}

class FetchAddresses extends AddressEvent {
  final String userId;
  const FetchAddresses(this.userId);

  @override
  List<Object?> get props => [userId];
}

class AddNewAddress extends AddressEvent {
  final AddressEntity address;
  const AddNewAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class UpdateExistingAddress extends AddressEvent {
  final AddressEntity address;
  const UpdateExistingAddress(this.address);

  @override
  List<Object?> get props => [address];
}

class DeleteExistingAddress extends AddressEvent {
  final String addressId;
  const DeleteExistingAddress(this.addressId);

  @override
  List<Object?> get props => [addressId];
}

class SetAddressAsDefault extends AddressEvent {
  final String userId;
  final String addressId;
  const SetAddressAsDefault({required this.userId, required this.addressId});

  @override
  List<Object?> get props => [userId, addressId];
}
