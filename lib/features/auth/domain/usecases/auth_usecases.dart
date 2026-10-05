import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/result/result.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Sign In With Email & Password
// ─────────────────────────────────────────────────────────────────────────────

class SignInWithEmailParams {
  final String email;
  final String password;
  const SignInWithEmailParams({required this.email, required this.password});
}

class SignInWithEmail {
  final AuthRepository _repository;
  const SignInWithEmail(this._repository);

  FutureResult<UserEntity> call(SignInWithEmailParams params) =>
      _repository.signInWithEmailAndPassword(
        email: params.email,
        password: params.password,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign Up With Email & Password
// ─────────────────────────────────────────────────────────────────────────────

class SignUpWithEmailParams {
  final String email;
  final String password;
  final String displayName;
  const SignUpWithEmailParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class SignUpWithEmail {
  final AuthRepository _repository;
  const SignUpWithEmail(this._repository);

  FutureResult<UserEntity> call(SignUpWithEmailParams params) =>
      _repository.signUpWithEmailAndPassword(
        email: params.email,
        password: params.password,
        displayName: params.displayName,
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign In With Google
// ─────────────────────────────────────────────────────────────────────────────

class SignInWithGoogle {
  final AuthRepository _repository;
  const SignInWithGoogle(this._repository);

  FutureResult<UserEntity> call() => _repository.signInWithGoogle();
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign In With Apple
// ─────────────────────────────────────────────────────────────────────────────

class SignInWithApple {
  final AuthRepository _repository;
  const SignInWithApple(this._repository);

  FutureResult<UserEntity> call() => _repository.signInWithApple();
}

// ─────────────────────────────────────────────────────────────────────────────
// Sign Out
// ─────────────────────────────────────────────────────────────────────────────

class SignOut {
  final AuthRepository _repository;
  const SignOut(this._repository);

  FutureResult<void> call() => _repository.signOut();
}

// ─────────────────────────────────────────────────────────────────────────────
// Send Password Reset Email
// ─────────────────────────────────────────────────────────────────────────────

class SendPasswordResetEmail {
  final AuthRepository _repository;
  const SendPasswordResetEmail(this._repository);

  FutureResult<void> call({required String email}) =>
      _repository.sendPasswordResetEmail(email: email);
}

// ─────────────────────────────────────────────────────────────────────────────
// Send Email Verification
// ─────────────────────────────────────────────────────────────────────────────

class SendEmailVerification {
  final AuthRepository _repository;
  const SendEmailVerification(this._repository);

  FutureResult<void> call() => _repository.sendEmailVerification();
}

// ─────────────────────────────────────────────────────────────────────────────
// Get Current User
// ─────────────────────────────────────────────────────────────────────────────

class GetCurrentUser {
  final AuthRepository _repository;
  const GetCurrentUser(this._repository);

  Future<UserEntity?> call() => _repository.getCurrentUser();
}
