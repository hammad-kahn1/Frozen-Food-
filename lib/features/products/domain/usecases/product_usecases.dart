import '../../../../core/result/result.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;
  const GetProductsByCategory(this.repository);

  FutureResult<List<ProductEntity>> call(String categoryId, {int limit = 20, String? afterId}) {
    return repository.getProductsByCategory(categoryId, limit: limit, afterId: afterId);
  }
}

class GetFeaturedProducts {
  final ProductRepository repository;
  const GetFeaturedProducts(this.repository);

  FutureResult<List<ProductEntity>> call() => repository.getFeaturedProducts();
}

class GetFlashDeals {
  final ProductRepository repository;
  const GetFlashDeals(this.repository);

  FutureResult<List<ProductEntity>> call() => repository.getFlashDeals();
}
