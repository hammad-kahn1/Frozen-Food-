import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/payment_intent_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const PaymentRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  FutureResult<PaymentIntentEntity> createPaymentIntent({required double amount, required String currency}) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      final model = await remoteDataSource.createPaymentIntent(amount: amount, currency: currency);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }

  @override
  FutureResult<void> confirmPayment({required String clientSecret}) async {
    if (!(await networkInfo.isConnected)) return const Left(NetworkFailure());
    try {
      await remoteDataSource.confirmPayment(clientSecret: clientSecret);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    }
  }
}
