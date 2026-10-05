import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<AddressModel>> getUserAddresses(String userId);
  Future<AddressModel> getAddressById(String addressId);
  Future<AddressModel> addAddress(AddressModel address);
  Future<AddressModel> updateAddress(AddressModel address);
  Future<void> deleteAddress(String addressId);
  Future<void> setDefaultAddress(String userId, String addressId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final FirebaseFirestore firestore;

  AddressRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _addresses => firestore.collection('addresses');

  @override
  Future<List<AddressModel>> getUserAddresses(String userId) async {
    try {
      final snapshot = await _addresses
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => AddressModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch addresses: $e');
    }
  }

  @override
  Future<AddressModel> getAddressById(String addressId) async {
    try {
      final doc = await _addresses.doc(addressId).get();
      if (!doc.exists) {
        throw const ServerException(message: 'Address not found');
      }
      return AddressModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Failed to fetch address: $e');
    }
  }

  @override
  Future<AddressModel> addAddress(AddressModel address) async {
    try {
      // If this is the user's first address, or they marked it as default
      if (address.isDefault) {
        await _clearOtherDefaults(address.userId);
      }

      final docRef = await _addresses.add(address.toFirestore());
      return AddressModel.fromEntity(address).copyWithId(docRef.id);
    } catch (e) {
      throw ServerException(message: 'Failed to add address: $e');
    }
  }

  @override
  Future<AddressModel> updateAddress(AddressModel address) async {
    try {
      if (address.isDefault) {
        await _clearOtherDefaults(address.userId, excludeId: address.id);
      }

      await _addresses.doc(address.id).update(address.toFirestore());
      return address;
    } catch (e) {
      throw ServerException(message: 'Failed to update address: $e');
    }
  }

  @override
  Future<void> deleteAddress(String addressId) async {
    try {
      await _addresses.doc(addressId).delete();
    } catch (e) {
      throw ServerException(message: 'Failed to delete address: $e');
    }
  }

  @override
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      final batch = firestore.batch();
      
      // Clear all
      final querySnapshot = await _addresses.where('userId', isEqualTo: userId).where('isDefault', isEqualTo: true).get();
      for (var doc in querySnapshot.docs) {
        batch.update(doc.reference, {'isDefault': false});
      }

      // Set new
      batch.update(_addresses.doc(addressId), {'isDefault': true});
      await batch.commit();
    } catch (e) {
      throw ServerException(message: 'Failed to set default address: $e');
    }
  }

  Future<void> _clearOtherDefaults(String userId, {String? excludeId}) async {
    final querySnapshot = await _addresses
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true)
        .get();

    for (var doc in querySnapshot.docs) {
      if (excludeId == null || doc.id != excludeId) {
        await doc.reference.update({'isDefault': false});
      }
    }
  }
}

extension on AddressModel {
  AddressModel copyWithId(String newId) {
    return AddressModel(
      id: newId,
      userId: userId,
      label: label,
      type: type,
      recipientName: recipientName,
      recipientPhone: recipientPhone,
      street: street,
      apartment: apartment,
      city: city,
      state: state,
      country: country,
      postalCode: postalCode,
      latitude: latitude,
      longitude: longitude,
      deliveryInstructions: deliveryInstructions,
      isDefault: isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
