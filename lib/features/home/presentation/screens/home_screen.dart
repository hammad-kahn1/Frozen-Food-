import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../app/router/route_names.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../bloc/home_cubit.dart';
import '../bloc/home_state.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<HomeCubit>()..loadHomeData(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  IconData _getCategoryIcon(String slug) {
    switch (slug) {
      case 'all': return Icons.restaurant_menu;
      case 'ice-cream': return Icons.icecream;
      case 'desserts': return Icons.cake;
      case 'seafood': return Icons.water;
      case 'meals': return Icons.dinner_dining;
      case 'meat': return Icons.kebab_dining;
      default: return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            if (state.status == HomeStatus.initial || (state.status == HomeStatus.loading && state.categories.isEmpty)) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == HomeStatus.error && state.categories.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: AppColors.error, size: 48),
                    const SizedBox(height: 16),
                    Text(state.failure?.message ?? 'Failed to load home data'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => context.read<HomeCubit>().loadHomeData(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Header ───────────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Good Morning,',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.secondary.withOpacity(0.7),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Text(
                              'Arctic Fan! 👋',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.secondary,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.1),
                                blurRadius: 15,
                                offset: const Offset(0, 5),
                              )
                            ],
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.shopping_bag_outlined, color: AppColors.primary),
                            onPressed: () => context.push(RouteNames.cart),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Search Bar ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    child: GestureDetector(
                      onTap: () => context.push(RouteNames.search), // If you implement search
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 20, right: 12),
                              child: Icon(Icons.search, color: AppColors.outline),
                            ),
                            const Expanded(
                              child: Text(
                                'Search your craving...',
                                style: TextStyle(color: AppColors.outline, fontSize: 16),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.tune, color: Colors.white, size: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Promotional Banner (Uses first Flash Deal if available) ──
                if (state.flashDeals.isNotEmpty)
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, Color(0xFFFF9E80)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          )
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(Icons.bolt, size: 150, color: Colors.white.withOpacity(0.2)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('FLASH DEAL', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Get ${state.flashDeals.first.flashDealDiscountPercent?.toInt() ?? 20}% Off\n${state.flashDeals.first.name}',
                                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1.1),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  // Fallback banner
                  SliverToBoxAdapter(
                    child: Container(
                      margin: const EdgeInsets.all(24),
                      height: 160,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primary, AppColors.secondary],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            right: -20,
                            bottom: -20,
                            child: Icon(Icons.icecream, size: 150, color: Colors.white.withOpacity(0.2)),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('PROMO', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  'Welcome to\nArctic Fresh!',
                                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // ── Categories ───────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: state.categories.length,
                      itemBuilder: (context, index) {
                        final category = state.categories[index];
                        final isSelected = state.selectedCategoryId == category.id;
                        
                        return GestureDetector(
                          onTap: () => context.read<HomeCubit>().selectCategory(category.id),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeOut,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.secondary : Colors.white,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: isSelected ? [
                                BoxShadow(color: AppColors.secondary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))
                              ] : [],
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _getCategoryIcon(category.slug),
                                  size: 18, 
                                  color: isSelected ? Colors.white : AppColors.outline,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  category.name,
                                  style: TextStyle(
                                    color: isSelected ? Colors.white : AppColors.outline,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ── Section Title ────────────────────────────────────────────
                const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                    child: Text(
                      'Products',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.secondary),
                    ),
                  ),
                ),
                
                // ── Product Grid ─────────────────────────────────────────────
                if (state.status == HomeStatus.loading)
                  const SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                else if (state.products.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Text(
                          'No products found in this category.',
                          style: TextStyle(color: AppColors.outline, fontSize: 16),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        childAspectRatio: 0.65, // Taller cards
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = state.products[index];
                          return ProductCard(
                            id: product.id,
                            name: product.name,
                            price: product.variants.isNotEmpty ? product.variants.first.price : 0.0,
                            imageUrl: product.images.isNotEmpty ? product.images.first : 'https://via.placeholder.com/150',
                            requiresColdChain: product.requiresColdChainHandling,
                            onTap: () => context.push('/products/${product.id}'),
                          );
                        },
                        childCount: state.products.length,
                      ),
                    ),
                  ),
                
                const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
              ],
            );
          },
        ),
      ),
    );
  }
}
