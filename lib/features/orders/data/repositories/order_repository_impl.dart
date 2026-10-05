import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const OrderRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  FutureResult<OrderEntity> placeOrder(OrderEntity order) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final model = await remoteDataSource.placeOrder(OrderModel.fromEntity(order));
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<List<OrderEntity>> getUserOrders(String userId) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final models = await remoteDataSource.getUserOrders(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
