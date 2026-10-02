import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../../app/theme/app_spacing.dart';

class ProductCard extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final bool requiresColdChain;
  final VoidCallback onTap;

  const ProductCard({
    super.key,
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.requiresColdChain = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Area (Large & Rounded)
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                      // Normally use NetworkImage here:
                      // image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
                    ),
                    child: Center(
                      child: Icon(Icons.fastfood_rounded, size: 60, color: AppColors.primary.withOpacity(0.5)),
                    ),
                  ),
                ),
                
                // Details Area
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Rs ${price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            
            // Floating Add to Cart Button
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight: Radius.circular(24),
                    ),
                    onTap: () {}, // Trigger Add to Cart
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ),
            
            // Cold Chain Badge
            if (requiresColdChain)
              Positioned(
                top: 16,
                left: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.ac_unit, size: 14, color: AppColors.coldChainBlue),
                      const SizedBox(width: 4),
                      Text(
                        'FROZEN',
                        style: TextStyle(
                          color: Colors.blue.shade900, 
                          fontSize: 10, 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
            // Favorite Button
            Positioned(
              top: 12,
              right: 12,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.favorite_border, color: AppColors.secondary, size: 20),
                  constraints: const BoxConstraints(),
                  padding: const EdgeInsets.all(8),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
