import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const ProductRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  FutureResult<ProductEntity> getProductById(String id) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final model = await remoteDataSource.getProductById(id);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  FutureResult<List<ProductEntity>> getProductsByCategory(
      String categoryId, {int limit = 20, String? afterId}) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final models = await remoteDataSource.getProductsByCategory(categoryId, limit: limit, afterId: afterId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  FutureResult<List<ProductEntity>> getFeaturedProducts() async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final models = await remoteDataSource.getFeaturedProducts();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  FutureResult<List<ProductEntity>> getFlashDeals() async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final models = await remoteDataSource.getFlashDeals();
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    }
  }

  @override
  FutureResult<List<ProductEntity>> getRecentlyViewed(List<String> ids) async {
    // Usually fetches from local Hive cache first, then resolves missing from remote
    // For blueprint, we return an empty list or mock.
    return const Right([]);
  }

  @override
  Future<void> markProductAsViewed(String productId) async {
    // Usually saves to local Hive cache
  }
}
