import '../../domain/entities/product_entity.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../../domain/entities/cold_chain_policy_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    super.description,
    required super.primaryCategoryId,
    super.categoryIds = const [],
    super.images = const [],
    super.thumbnailUrl,
    super.brand,
    super.ingredients = const [],
    super.allergens = const [],
    super.nutrition,
    super.variants = const [],
    required super.coldChainPolicy,
    super.cookingInstructions,
    super.isActive = true,
    super.isFeatured = false,
    super.isFlashDeal = false,
    super.flashDealDiscountPercent,
    super.flashDealEndsAt,
    super.averageRating,
    super.reviewCount = 0,
    super.tags = const [],
    required super.createdAt,
    required super.updatedAt,
  });

  factory ProductModel.fromFirestore(Map<String, dynamic> json, String docId) {
    return ProductModel(
      id: docId,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      description: json['description'],
      primaryCategoryId: json['primaryCategoryId'] ?? '',
      categoryIds: List<String>.from(json['categoryIds'] ?? []),
      images: List<String>.from(json['images'] ?? []),
      thumbnailUrl: json['thumbnailUrl'],
      brand: json['brand'],
      ingredients: List<String>.from(json['ingredients'] ?? []),
      allergens: List<String>.from(json['allergens'] ?? []),
      nutrition: _parseNutrition(json['nutrition']),
      variants: _parseVariants(json['variants']),
      coldChainPolicy: _parseColdChainPolicy(json['coldChainPolicy']),
      cookingInstructions: json['cookingInstructions'],
      isActive: json['isActive'] ?? true,
      isFeatured: json['isFeatured'] ?? false,
      isFlashDeal: json['isFlashDeal'] ?? false,
      flashDealDiscountPercent: (json['flashDealDiscountPercent'] as num?)?.toDouble(),
      flashDealEndsAt: _parseTimestamp(json['flashDealEndsAt']),
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      createdAt: _parseTimestamp(json['createdAt']) ?? DateTime.now(),
      updatedAt: _parseTimestamp(json['updatedAt']) ?? DateTime.now(),
    );
  }

  static NutritionInfo? _parseNutrition(Map<String, dynamic>? json) {
    if (json == null) return null;
    return NutritionInfo(
      calories: (json['calories'] as num?)?.toDouble() ?? 0,
      protein: (json['protein'] as num?)?.toDouble(),
      carbohydrates: (json['carbohydrates'] as num?)?.toDouble(),
      fat: (json['fat'] as num?)?.toDouble(),
      fiber: (json['fiber'] as num?)?.toDouble(),
      sodium: (json['sodium'] as num?)?.toDouble(),
      servingSize: json['servingSize'] ?? '1 serving',
    );
  }

  static List<ProductVariantEntity> _parseVariants(List<dynamic>? jsonList) {
    if (jsonList == null) return [];
    return jsonList.map((json) {
      final map = json as Map<String, dynamic>;
      return ProductVariantEntity(
        id: map['id'] ?? '',
        productId: map['productId'] ?? '',
        name: map['name'] ?? '',
        weight: (map['weight'] as num?)?.toDouble() ?? 0.0,
        weightUnit: _parseWeightUnit(map['weightUnit']),
        price: (map['price'] as num?)?.toDouble() ?? 0.0,
        compareAtPrice: (map['compareAtPrice'] as num?)?.toDouble(),
        sku: map['sku'] ?? '',
        barcode: map['barcode'],
        isAvailable: map['isAvailable'] ?? true,
        sortOrder: map['sortOrder'] ?? 0,
      );
    }).toList();
  }

  static WeightUnit _parseWeightUnit(String? unit) {
    switch (unit) {
      case 'kg': return WeightUnit.kg;
      case 'ml': return WeightUnit.ml;
      case 'l': return WeightUnit.l;
      case 'oz': return WeightUnit.oz;
      case 'lb': return WeightUnit.lb;
      case 'piece': return WeightUnit.piece;
      case 'g':
      default:
        return WeightUnit.g;
    }
  }

  static ColdChainPolicyEntity _parseColdChainPolicy(Map<String, dynamic>? json) {
    if (json == null) {
      // Return a default if missing
      return const ColdChainPolicyEntity(
        storageTemperatureRange: TemperatureRange(min: -18, max: -15),
        acceptableDeliveryTemperatureRange: TemperatureRange(min: -18, max: 0),
        shelfLifeDays: 90,
      );
    }
    
    return ColdChainPolicyEntity(
      storageTemperatureRange: _parseTempRange(json['storageTemperatureRange']) ?? const TemperatureRange(min: -18, max: -15),
      acceptableDeliveryTemperatureRange: _parseTempRange(json['acceptableDeliveryTemperatureRange']) ?? const TemperatureRange(min: -18, max: 0),
      shelfLifeDays: json['shelfLifeDays'] ?? 90,
      requiresDryIce: json['requiresDryIce'] ?? false,
      requiresIcePack: json['requiresIcePack'] ?? true,
      maxDeliveryDurationMins: json['maxDeliveryDurationMins'],
      supportedThawingMethods: _parseThawingMethods(json['supportedThawingMethods']),
      thawTimeMins: json['thawTimeMins'],
      thawingInstructions: json['thawingInstructions'],
      storageInstructions: json['storageInstructions'],
      temperatureGuaranteeStatement: json['temperatureGuaranteeStatement'],
    );
  }

  static TemperatureRange? _parseTempRange(Map<String, dynamic>? json) {
    if (json == null) return null;
    return TemperatureRange(
      min: (json['min'] as num?)?.toDouble() ?? -18,
      max: (json['max'] as num?)?.toDouble() ?? -15,
      unit: json['unit'] == 'fahrenheit' ? TemperatureUnit.fahrenheit : TemperatureUnit.celsius,
    );
  }
  
  static List<ThawingMethod> _parseThawingMethods(List<dynamic>? list) {
    if (list == null) return [ThawingMethod.refrigerator];
    return list.map((item) {
      switch (item) {
        case 'coldWater': return ThawingMethod.coldWater;
        case 'microwave': return ThawingMethod.microwave;
        case 'countertop': return ThawingMethod.countertop;
        case 'refrigerator':
        default: return ThawingMethod.refrigerator;
      }
    }).toList();
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;
    try {
      return (value as dynamic).toDate() as DateTime;
    } catch (_) {
      return null;
    }
  }
  
  ProductEntity toEntity() => this;
}
