import 'package:equatable/equatable.dart';

enum AddressType { home, office, other }

class AddressEntity extends Equatable {
  final String id;
  final String userId;
  final String label;
  final AddressType type;
  final String recipientName;
  final String recipientPhone;
  final String street;
  final String? apartment;
  final String city;
  final String state;
  final String country;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final String? deliveryInstructions;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AddressEntity({
    required this.id,
    required this.userId,
    required this.label,
    this.type = AddressType.home,
    required this.recipientName,
    required this.recipientPhone,
    required this.street,
    this.apartment,
    required this.city,
    required this.state,
    required this.country,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.deliveryInstructions,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullAddress {
    final parts = [street, apartment, city, state, postalCode, country];
    return parts.where((p) => p != null && p.isNotEmpty).join(', ');
  }

  @override
  List<Object?> get props => [
        id, userId, label, type, recipientName, recipientPhone,
        street, apartment, city, state, country, postalCode,
        latitude, longitude, deliveryInstructions, isDefault,
        createdAt, updatedAt,
      ];
}
