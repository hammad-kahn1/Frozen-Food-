import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String orderId;
  final double total;

  const OrderConfirmationScreen({
    super.key,
    required this.orderId,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Success Icon
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.tertiary,
                  size: 72,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),

              Text(
                'Order Confirmed!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Your frozen items are being packed with care.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.outline, fontSize: 16),
              ),

              const SizedBox(height: AppSpacing.xl),

              // Order Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.md),
                  border: Border.all(color: AppColors.surfaceVariant),
                ),
                child: Column(
                  children: [
                    _row('Order ID', '#${orderId.substring(0, 8).toUpperCase()}'),
                    const Divider(height: 20),
                    _row('Total Paid', 'Rs ${total.toStringAsFixed(0)}'),
                    const Divider(height: 20),
                    _row('Estimated Delivery', 'Today, 9:00 AM – 11:00 AM'),
                    const Divider(height: 20),
                    _row('Payment', 'Credit Card ****4242'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Cold Chain Banner
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.coldChainBlueMuted,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.ac_unit, color: AppColors.coldChainBlue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Your order is packed with ice-packs. Please refrigerate immediately upon delivery.',
                        style: TextStyle(fontSize: 13, color: AppColors.coldChainBlue),
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Actions
              ElevatedButton(
                onPressed: () {
                  // Navigate to Order Tracking screen
                },
                child: const Text('Track My Order'),
              ),
              const SizedBox(height: AppSpacing.sm),
              TextButton(
                onPressed: () {
                  // Navigate back to Home
                },
                child: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: AppColors.outline)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    );
  }
}
