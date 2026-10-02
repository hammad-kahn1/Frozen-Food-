import 'package:hive/hive.dart';
import '../../../../core/constants/hive_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/cart_item_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCachedCartItems();
  Future<void> cacheCartItems(List<CartItemModel> items);
  Future<void> clearCache();
}

class CartLocalDataSourceImpl implements CartLocalDataSource {
  final Box<dynamic> cartBox;

  const CartLocalDataSourceImpl({required this.cartBox});

  @override
  Future<List<CartItemModel>> getCachedCartItems() async {
    try {
      final rawList = cartBox.get(HiveConstants.cartItemsKey) as List<dynamic>?;
      if (rawList == null) return [];
      return rawList
          .map((item) => CartItemModel.fromJson(Map<String, dynamic>.from(item as Map)))
          .toList();
    } catch (e) {
      throw const CacheException(message: 'Failed to read cart from local storage.');
    }
  }

  @override
  Future<void> cacheCartItems(List<CartItemModel> items) async {
    try {
      final jsonList = items.map((item) => item.toJson()).toList();
      await cartBox.put(HiveConstants.cartItemsKey, jsonList);
    } catch (e) {
      throw const CacheException(message: 'Failed to save cart to local storage.');
    }
  }

  @override
  Future<void> clearCache() async {
    await cartBox.delete(HiveConstants.cartItemsKey);
  }
}
