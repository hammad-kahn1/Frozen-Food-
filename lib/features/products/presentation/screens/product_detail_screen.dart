import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_detail_cubit.dart';
import '../bloc/product_detail_state.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Assuming context.read<ProductDetailCubit>() is provided by router
    // context.read<ProductDetailCubit>().loadProduct(widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          )
        ],
      ),
      body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
        builder: (context, state) {
          if (state.status == ProductDetailStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == ProductDetailStatus.error) {
            return const Center(child: Text('Failed to load product.'));
          }

          final product = state.product;
          if (product == null) return const SizedBox();

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  height: 300,
                  color: Colors.grey.shade200,
                  child: Center(
                    child: Icon(Icons.image, size: 100, color: Colors.grey.shade400),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Text(
                      product.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Price will dynamically update based on variant',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    if (product.requiresColdChainHandling)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.blue.shade200),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.ac_unit, color: Colors.blue),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Frozen Item: Requires special cold-chain delivery to maintain temperature.',
                                style: TextStyle(color: Colors.blue.shade900),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                    const SizedBox(height: 24),
                    const Text('Select Variant', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: product.variants.map((v) => ChoiceChip(
                        label: Text(v.name),
                        selected: state.selectedVariant?.id == v.id,
                        onSelected: (selected) {
                          if (selected) {
                            context.read<ProductDetailCubit>().selectVariant(v);
                          }
                        },
                      )).toList(),
                    ),
                    
                    const SizedBox(height: 24),
                    const Text('Description', style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(product.description ?? 'No description available.'),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              // Trigger CartBloc AddToCart event
            },
            child: const Text('Add to Cart'),
          ),
        ),
      ),
    );
  }
}
