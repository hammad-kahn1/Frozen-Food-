import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../categories/domain/usecases/get_categories.dart';
import '../../../products/domain/usecases/product_usecases.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetCategories _getCategories;
  final GetProductsByCategory _getProductsByCategory;
  final GetFeaturedProducts _getFeaturedProducts;
  final GetFlashDeals _getFlashDeals;

  HomeCubit({
    required GetCategories getCategories,
    required GetProductsByCategory getProductsByCategory,
    required GetFeaturedProducts getFeaturedProducts,
    required GetFlashDeals getFlashDeals,
  })  : _getCategories = getCategories,
        _getProductsByCategory = getProductsByCategory,
        _getFeaturedProducts = getFeaturedProducts,
        _getFlashDeals = getFlashDeals,
        super(const HomeState());

  Future<void> loadHomeData() async {
    emit(state.copyWith(status: HomeStatus.loading));

    final categoriesResult = await _getCategories();
    final featuredResult = await _getFeaturedProducts();
    final flashDealsResult = await _getFlashDeals();
    final productsResult = await _getProductsByCategory('cat_all');

    // Handle results. For a real app, you might want to handle partial failures.
    // Here we'll just gather whatever succeeded.
    
    final categories = categoriesResult.getOrElse(() => []);
    final featured = featuredResult.getOrElse(() => []);
    final flashDeals = flashDealsResult.getOrElse(() => []);
    final products = productsResult.getOrElse(() => []);

    // If categories failed entirely, we might want to emit an error state
    if (categoriesResult.isLeft() && productsResult.isLeft()) {
      categoriesResult.fold(
        (failure) => emit(state.copyWith(status: HomeStatus.error, failure: failure)),
        (_) {},
      );
      return;
    }

    emit(state.copyWith(
      status: HomeStatus.loaded,
      categories: categories,
      featuredProducts: featured,
      flashDeals: flashDeals,
      products: products,
      selectedCategoryId: 'cat_all',
    ));
  }

  Future<void> selectCategory(String categoryId) async {
    if (state.selectedCategoryId == categoryId) return;

    emit(state.copyWith(selectedCategoryId: categoryId, status: HomeStatus.loading));

    final result = await _getProductsByCategory(categoryId);

    result.fold(
      (failure) => emit(state.copyWith(status: HomeStatus.error, failure: failure)),
      (products) => emit(state.copyWith(status: HomeStatus.loaded, products: products)),
    );
  }
}
