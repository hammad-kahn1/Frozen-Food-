import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/router/route_names.dart';
import '../bloc/cart_bloc.dart';
import '../bloc/cart_state.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Your Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              // Trigger CartCleared event
            },
          )
        ],
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == CartStatus.empty || state.cart == null || state.cart!.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 80, color: AppColors.outline),
                  SizedBox(height: 16),
                  Text('Your cart is empty', style: TextStyle(fontSize: 20, color: AppColors.outline)),
                ],
              ),
            );
          }

          final cart = state.cart!;

          return CustomScrollView(
            slivers: [
              if (cart.requiresColdChain)
                SliverToBoxAdapter(
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.md),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.coldChainBlue.withOpacity(0.1),
                      border: Border.all(color: AppColors.coldChainBlue),
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.ac_unit, color: AppColors.coldChainBlue),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'Your cart contains frozen items. A delivery slot supporting cold-chain is required.',
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final item = cart.items[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        child: Row(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(AppRadius.sm),
                              ),
                              child: const Icon(Icons.image, color: Colors.grey),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.productName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.variantName,
                                    style: const TextStyle(color: AppColors.outline, fontSize: 14),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Rs ${item.unitPrice.toStringAsFixed(0)}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {}, // Increase Qty
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {}, // Decrease Qty
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: cart.items.length,
                ),
              ),
              
              const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
            ],
          );
        },
      ),
      bottomSheet: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.cart == null || state.cart!.isEmpty) return const SizedBox.shrink();
          
          return Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subtotal',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Rs ${state.cart!.subtotal.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton(
                    onPressed: () => context.push(RouteNames.checkout),
                    child: const Text('Proceed to Checkout'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
