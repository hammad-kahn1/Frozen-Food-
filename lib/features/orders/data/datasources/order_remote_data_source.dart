import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Future<OrderModel> placeOrder(OrderModel order);
  Future<List<OrderModel>> getUserOrders(String userId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  CollectionReference get _orders => firestore.collection('orders');

  @override
  Future<OrderModel> placeOrder(OrderModel order) async {
    try {
      final docRef = await _orders.add(order.toFirestore());
      return order.copyWithId(docRef.id);
    } catch (e) {
      throw ServerException(message: 'Failed to place order: $e');
    }
  }

  @override
  Future<List<OrderModel>> getUserOrders(String userId) async {
    // Fetching requires reconstructing embedded Address/Slot from IDs
    // which would require additional lookups. Returning empty list for now
    // until a full Orders feature is built.
    return [];
  }
}

