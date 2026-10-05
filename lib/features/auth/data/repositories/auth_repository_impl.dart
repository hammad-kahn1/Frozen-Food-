import 'package:dartz/dartz.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  // ── Auth state stream ──────────────────────────────────────────────────────

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map((model) => model?.toEntity());
  }

  // ── Get current user ───────────────────────────────────────────────────────

  @override
  Future<UserEntity?> getCurrentUser() async {
    try {
      final model = await remoteDataSource.getCurrentUser();
      return model?.toEntity();
    } catch (_) {
      return null;
    }
  }

  // ── Sign in with email & password ──────────────────────────────────────────

  @override
  FutureResult<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.signInWithEmailAndPassword(
          email, password);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  // ── Sign up with email & password ──────────────────────────────────────────

  @override
  FutureResult<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  }) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.signUpWithEmailAndPassword(
          email, password, displayName);
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  // ── Sign in with Google ────────────────────────────────────────────────────

  @override
  FutureResult<UserEntity> signInWithGoogle() async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.signInWithGoogle();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  // ── Sign in with Apple ─────────────────────────────────────────────────────

  @override
  FutureResult<UserEntity> signInWithApple() async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    try {
      final model = await remoteDataSource.signInWithApple();
      return Right(model.toEntity());
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  // ── Send password reset email ──────────────────────────────────────────────

  @override
  FutureResult<void> sendPasswordResetEmail({required String email}) async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    try {
      await remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  @override
  FutureResult<void> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }

  // ── Send email verification ────────────────────────────────────────────────

  @override
  FutureResult<void> sendEmailVerification() async {
    if (!(await networkInfo.isConnected)) {
      return const Left(NetworkFailure());
    }
    try {
      await remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on ServerException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    }
  }
}
