import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/entities/cart_item_entity.dart';
import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_local_data_source.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_item_model.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource remoteDataSource;
  final CartLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  const CartRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  FutureResult<CartEntity> getCart(String? userId) async {
    try {
      // 1. Always start from local cache for instant UI
      final localItems = await localDataSource.getCachedCartItems();
      final localCart = CartEntity(
        userId: userId,
        items: localItems.map((m) => m.toEntity()).toList(),
        lastSyncedAt: DateTime.now(),
        isDirty: false,
      );

      // If user is not logged in or offline, just return local cache
      if (userId == null || !(await networkInfo.isConnected)) {
        return Right(localCart);
      }

      // 2. If online and authenticated, fetch from server
      final serverItems = await remoteDataSource.getServerCart(userId);
      
      // Server is source of truth. If empty, local wins (first sync), otherwise server wins
      final resolvedItems = serverItems.isNotEmpty ? serverItems : localItems;
      
      final mergedCart = CartEntity(
        userId: userId,
        items: resolvedItems.map((m) => m.toEntity()).toList(),
        lastSyncedAt: DateTime.now(),
        isDirty: false,
      );

      // 3. Persist the latest state locally
      await localDataSource.cacheCartItems(resolvedItems);

      return Right(mergedCart);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    } on ServerException catch (e) {
      // Degrade gracefully to local cache on server failure
      try {
        final localItems = await localDataSource.getCachedCartItems();
        return Right(CartEntity(
          userId: userId,
          items: localItems.map((m) => m.toEntity()).toList(),
          lastSyncedAt: DateTime.now(),
          isDirty: true,
        ));
      } catch (_) {
        return Left(ServerFailure(message: e.message, code: e.code));
      }
    }
  }

  @override
  FutureResult<CartEntity> addItem(CartItemEntity item) async {
    try {
      final currentItems = await localDataSource.getCachedCartItems();
      final updatedItems = _addOrUpdateItem(currentItems, item);
      
      await localDataSource.cacheCartItems(updatedItems);

      return Right(CartEntity(
        items: updatedItems.map((m) => m.toEntity()).toList(),
        lastSyncedAt: DateTime.now(),
        isDirty: true,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  List<CartItemModel> _addOrUpdateItem(
      List<CartItemModel> currentItems, CartItemEntity newItem) {
    final existingIndex = currentItems.indexWhere(
      (m) => m.productId == newItem.productId && m.variantId == newItem.variantId,
    );

    final newModel = CartItemModel.fromEntity(newItem);

    if (existingIndex >= 0) {
      final existing = currentItems[existingIndex];
      final updated = CartItemModel(
        productId: existing.productId,
        variantId: existing.variantId,
        productName: existing.productName,
        variantName: existing.variantName,
        imageUrl: existing.imageUrl,
        quantity: existing.quantity + newItem.quantity,
        unitPrice: newItem.unitPrice,
        coldChainRequired: existing.coldChainRequired,
        requiresDryIce: existing.requiresDryIce,
      );
      return List<CartItemModel>.from(currentItems)..[existingIndex] = updated;
    }

    return [...currentItems, newModel];
  }

  @override
  FutureResult<CartEntity> removeItem(String productId, String variantId) async {
    try {
      final currentItems = await localDataSource.getCachedCartItems();
      final updatedItems = currentItems
          .where((m) => !(m.productId == productId && m.variantId == variantId))
          .toList();
          
      await localDataSource.cacheCartItems(updatedItems);
      
      return Right(CartEntity(
        items: updatedItems.map((m) => m.toEntity()).toList(),
        lastSyncedAt: DateTime.now(),
        isDirty: true,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  FutureResult<CartEntity> updateItemQuantity(
      String productId, String variantId, int quantity) async {
    try {
      if (quantity <= 0) {
        return removeItem(productId, variantId);
      }
      
      final currentItems = await localDataSource.getCachedCartItems();
      final updatedItems = currentItems.map((m) {
        if (m.productId == productId && m.variantId == variantId) {
          return CartItemModel(
            productId: m.productId,
            variantId: m.variantId,
            productName: m.productName,
            variantName: m.variantName,
            imageUrl: m.imageUrl,
            quantity: quantity,
            unitPrice: m.unitPrice,
            coldChainRequired: m.coldChainRequired,
            requiresDryIce: m.requiresDryIce,
          );
        }
        return m;
      }).toList();
      
      await localDataSource.cacheCartItems(updatedItems);
      
      return Right(CartEntity(
        items: updatedItems.map((m) => m.toEntity()).toList(),
        lastSyncedAt: DateTime.now(),
        isDirty: true,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  FutureResult<CartEntity> clearCart() async {
    try {
      await localDataSource.clearCache();
      return Right(CartEntity(
        items: const [],
        lastSyncedAt: DateTime.now(),
        isDirty: false,
      ));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  FutureResult<CartEntity> syncCartWithServer(String userId) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    
    try {
      final localItems = await localDataSource.getCachedCartItems();
      await remoteDataSource.syncCartToServer(userId, localItems);
      
      return Right(CartEntity(
        userId: userId,
        items: localItems.map((m) => m.toEntity()).toList(),
        lastSyncedAt: DateTime.now(),
        isDirty: false,
      ));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }

  @override
  FutureResult<void> saveCartLocally(CartEntity cart) async {
    try {
      final models = cart.items.map(CartItemModel.fromEntity).toList();
      await localDataSource.cacheCartItems(models);
      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message));
    }
  }
}
