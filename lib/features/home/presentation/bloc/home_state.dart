import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../categories/domain/entities/category_entity.dart';
import '../../../products/domain/entities/product_entity.dart';

enum HomeStatus { initial, loading, loaded, error }

class HomeState extends Equatable {
  final HomeStatus status;
  final List<CategoryEntity> categories;
  final String selectedCategoryId;
  final List<ProductEntity> products; // Products for the selected category
  final List<ProductEntity> featuredProducts; // Always loaded (for banner, etc if needed)
  final List<ProductEntity> flashDeals;
  final Failure? failure;

  const HomeState({
    this.status = HomeStatus.initial,
    this.categories = const [],
    this.selectedCategoryId = 'cat_all',
    this.products = const [],
    this.featuredProducts = const [],
    this.flashDeals = const [],
    this.failure,
  });

  HomeState copyWith({
    HomeStatus? status,
    List<CategoryEntity>? categories,
    String? selectedCategoryId,
    List<ProductEntity>? products,
    List<ProductEntity>? featuredProducts,
    List<ProductEntity>? flashDeals,
    Failure? failure,
  }) {
    return HomeState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      products: products ?? this.products,
      featuredProducts: featuredProducts ?? this.featuredProducts,
      flashDeals: flashDeals ?? this.flashDeals,
      failure: failure,
    );
  }

  @override
  List<Object?> get props => [
        status,
        categories,
        selectedCategoryId,
        products,
        featuredProducts,
        flashDeals,
        failure,
      ];
}
