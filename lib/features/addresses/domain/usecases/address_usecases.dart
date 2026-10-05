import '../../../../core/result/result.dart';
import '../entities/address_entity.dart';
import '../repositories/address_repository.dart';

class GetUserAddresses {
  final AddressRepository repository;
  const GetUserAddresses(this.repository);

  FutureResult<List<AddressEntity>> call(String userId) => repository.getUserAddresses(userId);
}

class AddAddress {
  final AddressRepository repository;
  const AddAddress(this.repository);

  FutureResult<AddressEntity> call(AddressEntity address) => repository.addAddress(address);
}

class UpdateAddress {
  final AddressRepository repository;
  const UpdateAddress(this.repository);

  FutureResult<AddressEntity> call(AddressEntity address) => repository.updateAddress(address);
}

class DeleteAddress {
  final AddressRepository repository;
  const DeleteAddress(this.repository);

  FutureResult<void> call(String addressId) => repository.deleteAddress(addressId);
}

class SetDefaultAddress {
  final AddressRepository repository;
  const SetDefaultAddress(this.repository);

  FutureResult<void> call(String userId, String addressId) => repository.setDefaultAddress(userId, addressId);
}
