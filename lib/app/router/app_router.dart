import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/products/presentation/screens/product_detail_screen.dart';
import '../../features/cart/presentation/screens/cart_screen.dart';

// Note: These screens are stubs. We will implement them in the UI phase.
class StubScreen extends StatelessWidget {
  final String title;
  const StubScreen(this.title, {super.key});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)));
}

class AppRouter {
  // In a real app, inject the AuthBloc here to use for redirects
  AppRouter();

  late final GoRouter router = GoRouter(
    initialLocation: RouteNames.home,
    routes: [
      GoRoute(
        path: RouteNames.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: RouteNames.categories,
        builder: (context, state) => const StubScreen('Categories'),
      ),
      GoRoute(
        path: RouteNames.cart,
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: RouteNames.checkout,
        builder: (context, state) => const StubScreen('Checkout'),
      ),
      GoRoute(
        path: '/products/:productId',
        name: RouteNames.productDetail,
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['productId'] ?? '',
        ),
      ),
    ],
  );
}
