import '../../../../core/result/result.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  FutureResult<List<CategoryEntity>> getCategories();
}
