import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repositories/address_repository.dart';
import '../datasources/address_remote_data_source.dart';
import '../models/address_model.dart';

class AddressRepositoryImpl implements AddressRepository {
  final AddressRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const AddressRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  FutureResult<List<AddressEntity>> getUserAddresses(String userId) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final models = await remoteDataSource.getUserAddresses(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<AddressEntity> getAddressById(String addressId) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final model = await remoteDataSource.getAddressById(addressId);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<AddressEntity> addAddress(AddressEntity address) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final model = await remoteDataSource.addAddress(AddressModel.fromEntity(address));
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<AddressEntity> updateAddress(AddressEntity address) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final model = await remoteDataSource.updateAddress(AddressModel.fromEntity(address));
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<void> deleteAddress(String addressId) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      await remoteDataSource.deleteAddress(addressId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<void> setDefaultAddress(String userId, String addressId) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      await remoteDataSource.setDefaultAddress(userId, addressId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
