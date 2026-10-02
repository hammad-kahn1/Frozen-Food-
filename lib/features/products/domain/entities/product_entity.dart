import 'package:equatable/equatable.dart';
import 'cold_chain_policy_entity.dart';
import 'product_variant_entity.dart';

class NutritionInfo extends Equatable {
  final double calories;
  final double? protein;
  final double? carbohydrates;
  final double? fat;
  final double? fiber;
  final double? sodium;
  final String servingSize;

  const NutritionInfo({
    required this.calories,
    this.protein,
    this.carbohydrates,
    this.fat,
    this.fiber,
    this.sodium,
    required this.servingSize,
  });

  @override
  List<Object?> get props => [calories, protein, carbohydrates, fat, fiber, sodium, servingSize];
}

class ProductEntity extends Equatable {
  final String id;
  final String name;
  final String slug;
  final String? description;
  final String primaryCategoryId;
  final List<String> categoryIds;
  final List<String> images;
  final String? thumbnailUrl;
  final String? brand;
  final List<String> ingredients;
  final List<String> allergens;
  final NutritionInfo? nutrition;
  final List<ProductVariantEntity> variants;
  final ColdChainPolicyEntity coldChainPolicy;
  final String? cookingInstructions;
  final bool isActive;
  final bool isFeatured;
  final bool isFlashDeal;
  final double? flashDealDiscountPercent;
  final DateTime? flashDealEndsAt;
  final double? averageRating;
  final int reviewCount;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.slug,
    this.description,
    required this.primaryCategoryId,
    this.categoryIds = const [],
    this.images = const [],
    this.thumbnailUrl,
    this.brand,
    this.ingredients = const [],
    this.allergens = const [],
    this.nutrition,
    this.variants = const [],
    required this.coldChainPolicy,
    this.cookingInstructions,
    this.isActive = true,
    this.isFeatured = false,
    this.isFlashDeal = false,
    this.flashDealDiscountPercent,
    this.flashDealEndsAt,
    this.averageRating,
    this.reviewCount = 0,
    this.tags = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  bool get hasVariants => variants.length > 1;

  bool get isFlashDealActive =>
      isFlashDeal &&
      flashDealEndsAt != null &&
      flashDealEndsAt!.isAfter(DateTime.now());

  ProductVariantEntity? get defaultVariant =>
      variants.isNotEmpty ? variants.first : null;

  bool get requiresColdChainHandling =>
      coldChainPolicy.requiresSpecialHandling;

  @override
  List<Object?> get props => [
        id, name, slug, description, primaryCategoryId, categoryIds,
        images, thumbnailUrl, brand, ingredients, allergens, nutrition,
        variants, coldChainPolicy, cookingInstructions, isActive,
        isFeatured, isFlashDeal, flashDealDiscountPercent, flashDealEndsAt,
        averageRating, reviewCount, tags, createdAt, updatedAt,
      ];
}
