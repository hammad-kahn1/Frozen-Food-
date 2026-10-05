import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/auth_usecases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmail _signInWithEmail;
  final SignUpWithEmail _signUpWithEmail;
  final SignInWithGoogle _signInWithGoogle;
  final SignInWithApple _signInWithApple;
  final SignOut _signOut;
  final GetCurrentUser _getCurrentUser;
  final SendPasswordResetEmail _sendPasswordResetEmail;
  final SendEmailVerification _sendEmailVerification;

  StreamSubscription<dynamic>? _authStateSubscription;

  AuthBloc({
    required SignInWithEmail signInWithEmail,
    required SignUpWithEmail signUpWithEmail,
    required SignInWithGoogle signInWithGoogle,
    required SignInWithApple signInWithApple,
    required SignOut signOut,
    required GetCurrentUser getCurrentUser,
    required SendPasswordResetEmail sendPasswordResetEmail,
    required SendEmailVerification sendEmailVerification,
  })  : _signInWithEmail = signInWithEmail,
        _signUpWithEmail = signUpWithEmail,
        _signInWithGoogle = signInWithGoogle,
        _signInWithApple = signInWithApple,
        _signOut = signOut,
        _getCurrentUser = getCurrentUser,
        _sendPasswordResetEmail = sendPasswordResetEmail,
        _sendEmailVerification = sendEmailVerification,
        super(const AuthState.unknown()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthSignInWithEmailRequested>(_onSignInWithEmail);
    on<AuthSignUpWithEmailRequested>(_onSignUpWithEmail);
    on<AuthSignInWithGoogleRequested>(_onSignInWithGoogle);
    on<AuthSignInWithAppleRequested>(_onSignInWithApple);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthPasswordResetRequested>(_onPasswordReset);
    on<AuthEmailVerificationRequested>(_onEmailVerification);
    on<AuthErrorCleared>(_onErrorCleared);
  }

  // ── Auth started (app launch) ──────────────────────────────────────────────

  Future<void> _onAuthStarted(
      AuthStarted event, Emitter<AuthState> emit) async {
    final currentUser = await _getCurrentUser();
    if (currentUser != null) {
      emit(AuthState.authenticated(currentUser));
    } else {
      emit(const AuthState.unauthenticated());
    }
  }

  // ── Email sign-in ──────────────────────────────────────────────────────────

  Future<void> _onSignInWithEmail(
      AuthSignInWithEmailRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signInWithEmail(SignInWithEmailParams(
      email: event.email,
      password: event.password,
    ));
    result.fold(
      (failure) => emit(AuthState.unauthenticated(errorMessage: failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  // ── Email sign-up ──────────────────────────────────────────────────────────

  Future<void> _onSignUpWithEmail(
      AuthSignUpWithEmailRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signUpWithEmail(SignUpWithEmailParams(
      email: event.email,
      password: event.password,
      displayName: event.displayName,
    ));
    result.fold(
      (failure) => emit(AuthState.unauthenticated(errorMessage: failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  // ── Google sign-in ─────────────────────────────────────────────────────────

  Future<void> _onSignInWithGoogle(
      AuthSignInWithGoogleRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signInWithGoogle();
    result.fold(
      (failure) => emit(AuthState.unauthenticated(errorMessage: failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  // ── Apple sign-in ──────────────────────────────────────────────────────────

  Future<void> _onSignInWithApple(
      AuthSignInWithAppleRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _signInWithApple();
    result.fold(
      (failure) => emit(AuthState.unauthenticated(errorMessage: failure.message)),
      (user) => emit(AuthState.authenticated(user)),
    );
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  Future<void> _onSignOut(
      AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    await _signOut();
    emit(const AuthState.unauthenticated());
  }

  // ── Password reset ─────────────────────────────────────────────────────────

  Future<void> _onPasswordReset(
      AuthPasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(const AuthState.loading());
    final result = await _sendPasswordResetEmail(email: event.email);
    result.fold(
      (failure) => emit(AuthState.unauthenticated(errorMessage: failure.message)),
      (_) => emit(const AuthState.passwordResetSent()),
    );
  }

  // ── Email verification ─────────────────────────────────────────────────────

  Future<void> _onEmailVerification(
      AuthEmailVerificationRequested event, Emitter<AuthState> emit) async {
    final result = await _sendEmailVerification();
    result.fold(
      (failure) =>
          emit(state.clearMessages()..errorMessage == failure.message),
      (_) => emit(const AuthState.emailVerificationSent()),
    );
  }

  // ── Clear error ────────────────────────────────────────────────────────────

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    emit(state.clearMessages());
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    return super.close();
  }
}
