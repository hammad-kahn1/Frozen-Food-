import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../../domain/entities/cold_chain_policy_entity.dart';
import '../../domain/entities/product_variant_entity.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> getProductById(String id);
  Future<List<ProductModel>> getProductsByCategory(String categoryId, {int limit = 20, String? afterId});
  Future<List<ProductModel>> getFeaturedProducts();
  Future<List<ProductModel>> getFlashDeals();
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final FirebaseFirestore firestore;
  static const _collection = 'products';

  ProductRemoteDataSourceImpl({required this.firestore});

  @override
  Future<ProductModel> getProductById(String id) async {
    try {
      final doc = await firestore.collection(_collection).doc(id).get();
      if (doc.exists && doc.data() != null) {
        return ProductModel.fromFirestore(doc.data()!, doc.id);
      }
      
      // Fallback to mock data
      final mock = _mockProducts.firstWhere((p) => p.id == id, orElse: () => throw const ServerException(message: 'Product not found'));
      return mock;
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(message: 'Failed to fetch product: $e');
    }
  }

  @override
  Future<List<ProductModel>> getProductsByCategory(String categoryId, {int limit = 20, String? afterId}) async {
    try {
      Query query = firestore.collection(_collection)
          .where('isActive', isEqualTo: true)
          .limit(limit);
          
      if (categoryId != 'cat_all') {
        query = query.where('categoryIds', arrayContains: categoryId);
      }

      final snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
            .toList();
      }

      // Fallback
      if (categoryId == 'cat_all') return _mockProducts;
      return _mockProducts.where((p) => p.categoryIds.contains(categoryId)).toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getFeaturedProducts() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('isFeatured', isEqualTo: true)
          .limit(10)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
            .toList();
      }

      return _mockProducts.where((p) => p.isFeatured).toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch featured products: $e');
    }
  }

  @override
  Future<List<ProductModel>> getFlashDeals() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .where('isFlashDeal', isEqualTo: true)
          .limit(10)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc.data(), doc.id))
            .toList();
      }

      return _mockProducts.where((p) => p.isFlashDeal).toList();
    } catch (e) {
      throw ServerException(message: 'Failed to fetch flash deals: $e');
    }
  }

  // ── Premium Mock Data for blueprint WOW factor ─────────────────────────────
  
  static final _mockProducts = <ProductModel>[
    ProductModel(
      id: 'prod_1',
      name: 'Belgian Dark Chocolate Pint',
      slug: 'belgian-dark-chocolate-pint',
      description: 'Rich, velvety dark chocolate ice cream made with 70% premium Belgian cocoa. A decadent treat for true chocolate lovers.',
      primaryCategoryId: 'cat_ice_cream',
      categoryIds: const ['cat_ice_cream'],
      images: const ['https://images.unsplash.com/photo-1559703248-dcaaec9fab78?q=80&w=600&auto=format&fit=crop'], // Beautiful ice cream image
      brand: 'Arctic Fresh Artisanal',
      isActive: true,
      isFeatured: true,
      isFlashDeal: true,
      flashDealDiscountPercent: 20,
      flashDealEndsAt: DateTime.now().add(const Duration(hours: 12)),
      averageRating: 4.9,
      reviewCount: 128,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coldChainPolicy: const ColdChainPolicyEntity(
        storageTemperatureRange: TemperatureRange(min: -22, max: -18),
        acceptableDeliveryTemperatureRange: TemperatureRange(min: -22, max: -10),
        shelfLifeDays: 180,
        requiresDryIce: true,
      ),
      variants: const [
        ProductVariantEntity(
          id: 'var_1',
          productId: 'prod_1',
          name: '1 Pint',
          weight: 473,
          weightUnit: WeightUnit.ml,
          price: 12.99,
          compareAtPrice: 15.99,
          sku: 'ICE-CHOC-PINT',
        ),
      ],
    ),
    ProductModel(
      id: 'prod_2',
      name: 'Premium Atlantic Salmon Fillets',
      slug: 'atlantic-salmon-fillets',
      description: 'Wild-caught Atlantic salmon, flash-frozen at sea to preserve peak freshness, texture, and omega-3 richness.',
      primaryCategoryId: 'cat_seafood',
      categoryIds: const ['cat_seafood'],
      images: const ['https://images.unsplash.com/photo-1599084993091-1cb5c0721cc6?q=80&w=600&auto=format&fit=crop'], // Beautiful salmon image
      brand: 'Ocean Catch',
      isActive: true,
      isFeatured: true,
      averageRating: 4.8,
      reviewCount: 84,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coldChainPolicy: const ColdChainPolicyEntity(
        storageTemperatureRange: TemperatureRange(min: -20, max: -18),
        acceptableDeliveryTemperatureRange: TemperatureRange(min: -20, max: -5),
        shelfLifeDays: 90,
        requiresIcePack: true,
        supportedThawingMethods: [ThawingMethod.refrigerator, ThawingMethod.coldWater],
      ),
      variants: const [
        ProductVariantEntity(
          id: 'var_2',
          productId: 'prod_2',
          name: '2 Pieces (Skin-on)',
          weight: 340,
          weightUnit: WeightUnit.g,
          price: 24.50,
          sku: 'SEA-SAL-2PC',
        ),
      ],
    ),
    ProductModel(
      id: 'prod_3',
      name: 'Wagyu Beef Burgers',
      slug: 'wagyu-beef-burgers',
      description: 'Exceptional marbling meets incredible flavor. These 100% Wagyu beef patties elevate your backyard BBQ to a Michelin-star experience.',
      primaryCategoryId: 'cat_meat',
      categoryIds: const ['cat_meat'],
      images: const ['https://images.unsplash.com/photo-1550547660-d9450f859349?q=80&w=600&auto=format&fit=crop'],
      brand: 'Heritage Meats',
      isActive: true,
      isFeatured: false,
      averageRating: 5.0,
      reviewCount: 42,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coldChainPolicy: const ColdChainPolicyEntity(
        storageTemperatureRange: TemperatureRange(min: -18, max: -15),
        acceptableDeliveryTemperatureRange: TemperatureRange(min: -18, max: 0),
        shelfLifeDays: 120,
        requiresIcePack: true,
      ),
      variants: const [
        ProductVariantEntity(
          id: 'var_3',
          productId: 'prod_3',
          name: '4 Pack (1/3 lb each)',
          weight: 600,
          weightUnit: WeightUnit.g,
          price: 32.00,
          sku: 'MEA-WAG-4PK',
        ),
      ],
    ),
    ProductModel(
      id: 'prod_4',
      name: 'Madagascar Vanilla Bean',
      slug: 'madagascar-vanilla-bean',
      description: 'Classic, pure, and aromatic. Made with real Madagascar vanilla beans for a rich, speckled finish.',
      primaryCategoryId: 'cat_ice_cream',
      categoryIds: const ['cat_ice_cream'],
      images: const ['https://images.unsplash.com/photo-1570197781417-0a5237500ee3?q=80&w=600&auto=format&fit=crop'],
      brand: 'Arctic Fresh Artisanal',
      isActive: true,
      isFeatured: true,
      averageRating: 4.7,
      reviewCount: 215,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      coldChainPolicy: const ColdChainPolicyEntity(
        storageTemperatureRange: TemperatureRange(min: -22, max: -18),
        acceptableDeliveryTemperatureRange: TemperatureRange(min: -22, max: -10),
        shelfLifeDays: 180,
        requiresDryIce: true,
      ),
      variants: const [
        ProductVariantEntity(
          id: 'var_4',
          productId: 'prod_4',
          name: '1 Pint',
          weight: 473,
          weightUnit: WeightUnit.ml,
          price: 11.99,
          sku: 'ICE-VAN-PINT',
        ),
      ],
    ),
  ];
}
