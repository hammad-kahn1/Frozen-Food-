import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/route_names.dart';
import '../../../products/presentation/widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategoryIndex = 0;
  final _categories = ['All', 'Ice Cream', 'Desserts', 'Seafood', 'Meals'];
  final _categoryIcons = [Icons.restaurant_menu, Icons.icecream, Icons.cake, Icons.water, Icons.dinner_dining];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Custom Header
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
                          'Muhammad! 👋',
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

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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

            // Promotional Banner
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
                            'Get 30% Off\nIce Creams',
                            style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.1),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Categories
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final isSelected = _selectedCategoryIndex == index;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategoryIndex = index),
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
                              _categoryIcons[index], 
                              size: 18, 
                              color: isSelected ? Colors.white : AppColors.outline,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _categories[index],
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

            // Section Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Popular Now',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.secondary),
                ),
              ),
            ),
            
            // Modern Product Grid
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
                    return ProductCard(
                      id: 'prod_$index',
                      name: index % 2 == 0 ? 'Belgian Chocolate Pint' : 'Strawberry Cheesecake',
                      price: index % 2 == 0 ? 1250.0 : 850.0,
                      imageUrl: 'https://via.placeholder.com/150',
                      requiresColdChain: true,
                      onTap: () => context.push('/products/prod_$index'),
                    );
                  },
                  childCount: 6,
                ),
              ),
            ),
            
            const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
          ],
        ),
      ),
    );
  }
}
