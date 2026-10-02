import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String? imageUrl;
  final String? bannerUrl;
  final String? parentCategoryId;
  final bool isActive;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    this.imageUrl,
    this.bannerUrl,
    this.parentCategoryId,
    this.isActive = true,
    this.sortOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isTopLevel => parentCategoryId == null;

  @override
  List<Object?> get props => [
        id, name, slug, description, imageUrl, bannerUrl,
        parentCategoryId, isActive, sortOrder, createdAt, updatedAt,
      ];
}
