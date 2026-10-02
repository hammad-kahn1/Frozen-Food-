import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/firestore_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartRemoteDataSource {
  Future<List<CartItemModel>> getServerCart(String userId);
  Future<void> syncCartToServer(String userId, List<CartItemModel> items);
  Future<void> clearServerCart(String userId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;

  const CartRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CartItemModel>> getServerCart(String userId) async {
    try {
      final doc = await firestore
          .collection(FirestoreConstants.carts)
          .doc(userId)
          .get();
      if (!doc.exists || doc.data() == null) return [];
      
      final data = doc.data()!;
      final rawItems = data['items'] as List<dynamic>? ?? [];
      return rawItems
          .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to fetch cart.', code: e.code);
    }
  }

  @override
  Future<void> syncCartToServer(String userId, List<CartItemModel> items) async {
    try {
      await firestore
          .collection(FirestoreConstants.carts)
          .doc(userId)
          .set({
        'userId': userId,
        'items': items.map((i) => i.toJson()).toList(),
        'lastUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to sync cart.', code: e.code);
    }
  }

  @override
  Future<void> clearServerCart(String userId) async {
    try {
      await firestore
          .collection(FirestoreConstants.carts)
          .doc(userId)
          .set({'items': [], 'lastUpdatedAt': FieldValue.serverTimestamp()});
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to clear cart.', code: e.code);
    }
  }
}
