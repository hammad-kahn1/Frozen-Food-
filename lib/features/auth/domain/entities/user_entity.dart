import 'package:equatable/equatable.dart';

enum UserRole { customer, admin, deliveryAgent }

class UserEntity extends Equatable {
  final String id;
  final String? email;
  final String? phone;
  final String? displayName;
  final String? photoUrl;
  final UserRole role;
  final bool isEmailVerified;
  final bool isPhoneVerified;
  final String? defaultAddressId;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserEntity({
    required this.id,
    this.email,
    this.phone,
    this.displayName,
    this.photoUrl,
    this.role = UserRole.customer,
    this.isEmailVerified = false,
    this.isPhoneVerified = false,
    this.defaultAddressId,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isAdmin => role == UserRole.admin;
  bool get isDeliveryAgent => role == UserRole.deliveryAgent;

  @override
  List<Object?> get props => [
        id, email, phone, displayName, photoUrl, role,
        isEmailVerified, isPhoneVerified, defaultAddressId,
        createdAt, updatedAt,
      ];
}
