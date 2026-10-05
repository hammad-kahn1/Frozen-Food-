import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Contract for remote auth operations (Firebase Auth + Firestore).
abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel?> getCurrentUser();
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String displayName);
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithApple();
  Future<void> sendPasswordResetEmail(String email);
  Future<void> signOut();
  Future<void> sendEmailVerification();
}

/// Firebase implementation of [AuthRemoteDataSource].
class FirebaseAuthRemoteDataSource implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;

  static const _usersCollection = 'users';

  FirebaseAuthRemoteDataSource({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore,
        _googleSignIn = googleSignIn;

  // ── Auth state stream ──────────────────────────────────────────────────────

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      return _fetchOrCreateUser(firebaseUser);
    });
  }

  // ── Get current user ───────────────────────────────────────────────────────

  @override
  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser == null) return null;
    return _fetchOrCreateUser(firebaseUser);
  }

  // ── Email & password sign in ───────────────────────────────────────────────

  @override
  Future<UserModel> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return _fetchOrCreateUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
      );
    }
  }

  // ── Email & password sign up ───────────────────────────────────────────────

  @override
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String displayName) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user!;
      await user.updateDisplayName(displayName);
      await user.reload();

      final model = UserModel.fromFirebaseUser(
        uid: user.uid,
        email: user.email,
        displayName: displayName,
        photoUrl: user.photoURL,
        isEmailVerified: user.emailVerified,
      );

      // Persist the new profile document to Firestore
      await _firestore
          .collection(_usersCollection)
          .doc(user.uid)
          .set(model.toFirestore());

      return model;
    } on FirebaseAuthException catch (e) {
      throw ServerException(
        message: _mapFirebaseAuthError(e.code),
        code: e.code,
      );
    }
  }

  // ── Google sign in ─────────────────────────────────────────────────────────

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        throw const ServerException(
            message: 'Google sign-in was cancelled by the user.',
            code: 'cancelled');
      }
      final googleAuth = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      return _fetchOrCreateUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: _mapFirebaseAuthError(e.code), code: e.code);
    }
  }

  // ── Apple sign in ──────────────────────────────────────────────────────────

  @override
  Future<UserModel> signInWithApple() async {
    try {
      final appleProvider = AppleAuthProvider()
        ..addScope('email')
        ..addScope('fullName');
      final userCredential =
          await _firebaseAuth.signInWithProvider(appleProvider);
      return _fetchOrCreateUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: _mapFirebaseAuthError(e.code), code: e.code);
    }
  }

  // ── Password reset ─────────────────────────────────────────────────────────

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: _mapFirebaseAuthError(e.code), code: e.code);
    }
  }

  // ── Sign out ───────────────────────────────────────────────────────────────

  @override
  Future<void> signOut() async {
    try {
      await Future.wait([
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw ServerException(message: 'Sign-out failed. Please try again.');
    }
  }

  // ── Email verification ─────────────────────────────────────────────────────

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw const ServerException(
          message: 'No authenticated user found.', code: 'no-user');
    }
    if (user.emailVerified) {
      throw const ServerException(
          message: 'Email is already verified.', code: 'already-verified');
    }
    try {
      await user.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      throw ServerException(
          message: _mapFirebaseAuthError(e.code), code: e.code);
    }
  }

  // ── Private helpers ────────────────────────────────────────────────────────

  /// Fetches the Firestore user document. If it doesn't exist yet (first OAuth
  /// sign-in), creates it and returns the new model.
  Future<UserModel> _fetchOrCreateUser(User firebaseUser) async {
    final docRef =
        _firestore.collection(_usersCollection).doc(firebaseUser.uid);
    final snapshot = await docRef.get();

    if (snapshot.exists && snapshot.data() != null) {
      return UserModel.fromFirestore(snapshot.data()!, snapshot.id);
    }

    // First-time login — scaffold the Firestore document
    final model = UserModel.fromFirebaseUser(
      uid: firebaseUser.uid,
      email: firebaseUser.email,
      displayName: firebaseUser.displayName,
      photoUrl: firebaseUser.photoURL,
      isEmailVerified: firebaseUser.emailVerified,
    );
    await docRef.set(model.toFirestore());
    return model;
  }

  /// Converts Firebase error codes into user-friendly messages.
  String _mapFirebaseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account with this email already exists.';
      case 'weak-password':
        return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      case 'cancelled':
        return 'Sign-in was cancelled.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
