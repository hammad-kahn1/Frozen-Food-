import '../../../../core/result/result.dart';
import '../entities/address_entity.dart';

abstract class AddressRepository {
  FutureResult<List<AddressEntity>> getUserAddresses(String userId);
  FutureResult<AddressEntity> getAddressById(String addressId);
  FutureResult<AddressEntity> addAddress(AddressEntity address);
  FutureResult<AddressEntity> updateAddress(AddressEntity address);
  FutureResult<void> deleteAddress(String addressId);
  FutureResult<void> setDefaultAddress(String userId, String addressId);
}
