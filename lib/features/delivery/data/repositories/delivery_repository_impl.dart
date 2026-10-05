import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/delivery_slot_entity.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../datasources/delivery_remote_data_source.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  final DeliveryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const DeliveryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  FutureResult<List<DeliverySlotEntity>> getAvailableDeliverySlots(DateTime date, {bool requiresColdChain = false, bool requiresDryIce = false}) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final models = await remoteDataSource.getAvailableDeliverySlots(
        date,
        requiresColdChain: requiresColdChain,
        requiresDryIce: requiresDryIce,
      );
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
