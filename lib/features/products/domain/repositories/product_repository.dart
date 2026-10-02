import '../../../../core/result/result.dart';
import '../entities/product_entity.dart';

abstract class ProductRepository {
  FutureResult<ProductEntity> getProductById(String id);
  FutureResult<List<ProductEntity>> getProductsByCategory(
      String categoryId, {int limit = 20, String? afterId});
  FutureResult<List<ProductEntity>> getFeaturedProducts();
  FutureResult<List<ProductEntity>> getFlashDeals();
  FutureResult<List<ProductEntity>> getRecentlyViewed(List<String> ids);
  Future<void> markProductAsViewed(String productId);
}
