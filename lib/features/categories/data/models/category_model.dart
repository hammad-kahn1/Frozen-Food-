import '../../domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    super.imageUrl,
    super.bannerUrl,
    super.parentCategoryId,
    super.isActive = true,
    super.sortOrder = 0,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return CategoryModel(
      id: docId,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      imageUrl: json['imageUrl'],
      bannerUrl: json['bannerUrl'],
      parentCategoryId: json['parentCategoryId'],
      isActive: json['isActive'] ?? true,
      sortOrder: json['sortOrder'] ?? 0,
      createdAt: _parseTimestamp(json['createdAt']),
      updatedAt: _parseTimestamp(json['updatedAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'slug': slug,
      'description': description,
      'imageUrl': imageUrl,
      'bannerUrl': bannerUrl,
      'parentCategoryId': parentCategoryId,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  static DateTime _parseTimestamp(dynamic value) {
    if (value == null) return DateTime.now();
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return DateTime.now();
    }
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      name: name,
      slug: slug,
      description: description,
      imageUrl: imageUrl,
      bannerUrl: bannerUrl,
      parentCategoryId: parentCategoryId,
      isActive: isActive,
      sortOrder: sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
