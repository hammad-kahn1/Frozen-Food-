import '../../domain/entities/address_entity.dart';

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.id,
    required super.userId,
    required super.label,
    super.type = AddressType.home,
    required super.recipientName,
    required super.recipientPhone,
    required super.street,
    super.apartment,
    required super.city,
    required super.state,
    required super.country,
    required super.postalCode,
    super.latitude,
    super.longitude,
    super.deliveryInstructions,
    super.isDefault = false,
    required super.createdAt,
    required super.updatedAt,
  });

  factory AddressModel.fromEntity(AddressEntity entity) {
    return AddressModel(
      id: entity.id,
      userId: entity.userId,
      label: entity.label,
      type: entity.type,
      recipientName: entity.recipientName,
      recipientPhone: entity.recipientPhone,
      street: entity.street,
      apartment: entity.apartment,
      city: entity.city,
      state: entity.state,
      country: entity.country,
      postalCode: entity.postalCode,
      latitude: entity.latitude,
      longitude: entity.longitude,
      deliveryInstructions: entity.deliveryInstructions,
      isDefault: entity.isDefault,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  factory AddressModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return AddressModel(
      id: docId,
      userId: json['userId'] ?? '',
      label: json['label'] ?? 'My Address',
      type: _parseType(json['type']),
      recipientName: json['recipientName'] ?? '',
      recipientPhone: json['recipientPhone'] ?? '',
      street: json['street'] ?? '',
      apartment: json['apartment'],
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      country: json['country'] ?? '',
      postalCode: json['postalCode'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      deliveryInstructions: json['deliveryInstructions'],
      isDefault: json['isDefault'] ?? false,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'label': label,
      'type': type.name,
      'recipientName': recipientName,
      'recipientPhone': recipientPhone,
      'street': street,
      'apartment': apartment,
      'city': city,
      'state': state,
      'country': country,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'deliveryInstructions': deliveryInstructions,
      'isDefault': isDefault,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static AddressType _parseType(String? typeStr) {
    switch (typeStr) {
      case 'office':
        return AddressType.office;
      case 'other':
        return AddressType.other;
      case 'home':
      default:
        return AddressType.home;
    }
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  AddressEntity toEntity() => this;
}
