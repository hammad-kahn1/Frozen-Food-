import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

enum AuthStatus {
  /// Initial state — we don't yet know if the user is signed in.
  unknown,

  /// Actively checking / performing an auth operation.
  loading,

  /// User is authenticated.
  authenticated,

  /// User is not authenticated.
  unauthenticated,

  /// Password reset email was sent successfully.
  passwordResetSent,

  /// Email verification was sent successfully.
  emailVerificationSent,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;

  const AuthState._({
    required this.status,
    this.user,
    this.errorMessage,
    this.successMessage,
  });

  // ── Named constructors ─────────────────────────────────────────────────────

  const AuthState.unknown()
      : this._(status: AuthStatus.unknown);

  const AuthState.loading()
      : this._(status: AuthStatus.loading);

  const AuthState.authenticated(UserEntity user)
      : this._(status: AuthStatus.authenticated, user: user);

  const AuthState.unauthenticated({String? errorMessage})
      : this._(
          status: AuthStatus.unauthenticated,
          errorMessage: errorMessage,
        );

  const AuthState.passwordResetSent()
      : this._(
          status: AuthStatus.passwordResetSent,
          successMessage: 'Password reset email sent! Check your inbox.',
        );

  const AuthState.emailVerificationSent()
      : this._(
          status: AuthStatus.emailVerificationSent,
          successMessage: 'Verification email sent! Check your inbox.',
        );

  // ── Helpers ────────────────────────────────────────────────────────────────

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  bool get isUnknown => status == AuthStatus.unknown;
  bool get hasError => errorMessage != null;
  bool get hasSuccess => successMessage != null;

  AuthState clearMessages() => AuthState._(
        status: status,
        user: user,
        errorMessage: null,
        successMessage: null,
      );

  @override
  List<Object?> get props =>
      [status, user, errorMessage, successMessage];
}
