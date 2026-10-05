import '../../../../core/result/result.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

class GetCategories {
  final CategoryRepository repository;

  const GetCategories(this.repository);

  FutureResult<List<CategoryEntity>> call() => repository.getCategories();
}
