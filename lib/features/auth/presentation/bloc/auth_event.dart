import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Fired once on app start — checks if the user is already signed in.
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// Fired when the Firebase auth state stream emits a new value.
class AuthUserChanged extends AuthEvent {
  // ignore: unused_field — kept for future use (e.g. checking verification)
  const AuthUserChanged();
}

class AuthSignInWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInWithEmailRequested({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}

class AuthSignUpWithEmailRequested extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  const AuthSignUpWithEmailRequested({
    required this.email,
    required this.password,
    required this.displayName,
  });

  @override
  List<Object?> get props => [email, password, displayName];
}

class AuthSignInWithGoogleRequested extends AuthEvent {
  const AuthSignInWithGoogleRequested();
}

class AuthSignInWithAppleRequested extends AuthEvent {
  const AuthSignInWithAppleRequested();
}

class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

class AuthEmailVerificationRequested extends AuthEvent {
  const AuthEmailVerificationRequested();
}

/// Clears any transient error or success message from state.
class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}
