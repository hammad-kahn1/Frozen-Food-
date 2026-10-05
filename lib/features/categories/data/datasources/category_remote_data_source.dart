import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final FirebaseFirestore firestore;
  static const _collection = 'categories';

  CategoryRemoteDataSourceImpl({required this.firestore});

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final snapshot = await firestore
          .collection(_collection)
          .where('isActive', isEqualTo: true)
          .orderBy('sortOrder')
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs
            .map((doc) => CategoryModel.fromFirestore(doc.data(), doc.id))
            .toList();
      }

      // ── Fallback mock data for blueprint wow-factor if db is empty ────────
      return _mockCategories;
    } catch (e) {
      throw ServerException(message: 'Failed to fetch categories: $e');
    }
  }

  static final List<CategoryModel> _mockCategories = [
    CategoryModel(
      id: 'cat_all',
      name: 'All',
      slug: 'all',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_ice_cream',
      name: 'Ice Cream',
      slug: 'ice-cream',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_seafood',
      name: 'Seafood',
      slug: 'seafood',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_meals',
      name: 'Meals',
      slug: 'meals',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
    CategoryModel(
      id: 'cat_meat',
      name: 'Meat',
      slug: 'meat',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];
}
