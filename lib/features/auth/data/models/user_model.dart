import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';

/// Data model that maps between [UserEntity] and Firebase / Firestore.
class UserModel extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String? displayName;
  final String? photoUrl;
  final String role; // stored as string in Firestore
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? defaultAddressId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
    this.photoUrl,
    this.role = 'customer',
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.defaultAddressId,
    required this.createdAt,
    required this.updatedAt,
  });

  // ── Firestore deserialization ──────────────────────────────────────────────

  factory UserModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return UserModel(
      id: docId,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      role: (json['role'] as String?) ?? 'customer',
      isEmailVerified: (json['isEmailVerified'] as bool?) ?? false,
      isPhoneVerified: (json['isPhoneVerified'] as bool?) ?? false,
      defaultAddressId: json['defaultAddressId'] as String?,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    // Firestore Timestamp comes in as an object with .toDate()
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  // ── Firestore serialization ────────────────────────────────────────────────

  Map<String, dynamic> toFirestore() => {
        'email': email,
        'phone': phone,
        'displayName': displayName,
        'photoUrl': photoUrl,
        'role': role,
        'isEmailVerified': isEmailVerified,
        'isPhoneVerified': isPhoneVerified,
        'defaultAddressId': defaultAddressId,
        'createdAt': createdAt,
        'updatedAt': updatedAt,
      };

  // ── Firebase Auth user → model (on first sign-in) ─────────────────────────

  factory UserModel.fromFirebaseUser({
    required String uid,
    String? email,
    String? displayName,
    String? photoUrl,
    bool isEmailVerified = false,
  }) {
    final now = DateTime.now();
    return UserModel(
      id: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoUrl,
      isEmailVerified: isEmailVerified,
      createdAt: now,
      updatedAt: now,
    );
  }

  // ── Entity conversion ──────────────────────────────────────────────────────

  UserEntity toEntity() => UserEntity(
        id: id,
        email: email,
        phone: phone,
        displayName: displayName,
        photoUrl: photoUrl,
        role: _parseRole(role),
        isEmailVerified: isEmailVerified,
        isPhoneVerified: isPhoneVerified,
        defaultAddressId: defaultAddressId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );

  static UserRole _parseRole(String role) {
    switch (role) {
      case 'admin':
        return UserRole.admin;
      case 'deliveryAgent':
        return UserRole.deliveryAgent;
      default:
        return UserRole.customer;
    }
  }

  @override
  List<Object?> get props => [
        id, email, phone, displayName, photoUrl, role,
        isEmailVerified, isPhoneVerified, defaultAddressId,
        createdAt, updatedAt,
      ];
}
