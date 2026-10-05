import '../../../../core/result/result.dart';
import '../entities/user_entity.dart';

/// Abstract contract for the Auth feature's data operations.
/// The domain layer depends on this interface; the data layer provides the impl.
abstract class AuthRepository {
  /// Returns a stream that emits the current user whenever auth state changes.
  /// Emits [null] when the user is not authenticated.
  Stream<UserEntity?> get authStateChanges;

  /// Returns the currently signed-in user, or [null] if not authenticated.
  Future<UserEntity?> getCurrentUser();

  /// Signs in with email and password.
  FutureResult<UserEntity> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Creates a new account with email and password, then stores the user
  /// profile document in Firestore.
  FutureResult<UserEntity> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String displayName,
  });

  /// Initiates the Google Sign-In flow.
  FutureResult<UserEntity> signInWithGoogle();

  /// Initiates the Apple Sign-In flow (iOS / macOS only).
  FutureResult<UserEntity> signInWithApple();

  /// Sends a password-reset email to the given address.
  FutureResult<void> sendPasswordResetEmail({required String email});

  /// Signs the current user out from Firebase and clears any cached credentials.
  FutureResult<void> signOut();

  /// Sends an email-verification link to the currently signed-in user.
  FutureResult<void> sendEmailVerification();
}
