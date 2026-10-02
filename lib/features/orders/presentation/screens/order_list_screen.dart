import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../orders/domain/enums/order_status.dart';

class OrderListScreen extends StatelessWidget {
  const OrderListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('My Orders'),
        backgroundColor: AppColors.surface,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        itemCount: 4, // Stub data
        itemBuilder: (context, index) {
          final statuses = [
            OrderStatus.outForDelivery,
            OrderStatus.preparing,
            OrderStatus.delivered,
            OrderStatus.cancelled,
          ];
          return _OrderCard(
            orderId: 'ORD-00${index + 1}',
            date: 'Oct ${index + 1}, 2024',
            status: statuses[index],
            total: (850 + index * 200).toDouble(),
            itemCount: index + 1,
          );
        },
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final String orderId;
  final String date;
  final OrderStatus status;
  final double total;
  final int itemCount;

  const _OrderCard({
    required this.orderId,
    required this.date,
    required this.status,
    required this.total,
    required this.itemCount,
  });

  Color get _statusColor {
    switch (status) {
      case OrderStatus.delivered:
        return AppColors.inStockGreen;
      case OrderStatus.cancelled:
        return AppColors.outOfStockRed;
      case OrderStatus.outForDelivery:
        return AppColors.coldChainBlue;
      default:
        return AppColors.lowStockAmber;
    }
  }

  String get _statusLabel {
    switch (status) {
      case OrderStatus.outForDelivery: return 'Out for Delivery';
      case OrderStatus.preparing: return 'Being Prepared';
      case OrderStatus.delivered: return 'Delivered';
      case OrderStatus.cancelled: return 'Cancelled';
      default: return 'Processing';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.surfaceVariant),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      orderId,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(date, style: TextStyle(color: AppColors.outline, fontSize: 13)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: Text(
                    _statusLabel,
                    style: TextStyle(
                      color: _statusColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$itemCount item${itemCount > 1 ? 's' : ''}',
                  style: TextStyle(color: AppColors.outline),
                ),
                Text(
                  'Rs ${total.toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
          ),
          if (status == OrderStatus.outForDelivery)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: const BoxDecoration(
                color: AppColors.coldChainBlueMuted,
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppRadius.md)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.ac_unit, size: 16, color: AppColors.coldChainBlue),
                  SizedBox(width: 6),
                  Text(
                    'Cold-chain active — your order is on its way!',
                    style: TextStyle(color: AppColors.coldChainBlue, fontSize: 12, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
