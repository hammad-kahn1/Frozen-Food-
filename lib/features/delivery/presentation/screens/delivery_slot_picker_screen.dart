import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';

class DeliverySlotPickerScreen extends StatefulWidget {
  const DeliverySlotPickerScreen({super.key});

  @override
  State<DeliverySlotPickerScreen> createState() => _DeliverySlotPickerScreenState();
}

class _DeliverySlotPickerScreenState extends State<DeliverySlotPickerScreen> {
  int _selectedDayIndex = 0;
  String? _selectedSlotId;

  final _days = ['Today', 'Tomorrow', 'Wed', 'Thu', 'Fri'];

  final _slots = [
    {'id': 'slot_1', 'time': '9:00 AM – 11:00 AM', 'fee': 150.0, 'remaining': 5, 'coldChain': true, 'dryIce': false},
    {'id': 'slot_2', 'time': '11:00 AM – 1:00 PM', 'fee': 150.0, 'remaining': 2, 'coldChain': true, 'dryIce': true},
    {'id': 'slot_3', 'time': '2:00 PM – 4:00 PM',  'fee': 100.0, 'remaining': 0, 'coldChain': true, 'dryIce': false},
    {'id': 'slot_4', 'time': '4:00 PM – 6:00 PM',  'fee': 100.0, 'remaining': 8, 'coldChain': true, 'dryIce': false},
    {'id': 'slot_5', 'time': '7:00 PM – 9:00 PM',  'fee': 120.0, 'remaining': 3, 'coldChain': true, 'dryIce': true},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Select Delivery Slot'),
        backgroundColor: AppColors.surface,
      ),
      body: Column(
        children: [
          // Day Selector
          Container(
            height: 60,
            color: Colors.white,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.sm),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final selected = _selectedDayIndex == index;
                return GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                      border: Border.all(
                        color: selected ? AppColors.primary : AppColors.surfaceVariant,
                      ),
                    ),
                    child: Text(
                      _days[index],
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: selected ? Colors.white : AppColors.onSurface,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Cold-chain notice
          Container(
            margin: const EdgeInsets.all(AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.coldChainBlueMuted,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: const Row(
              children: [
                Icon(Icons.ac_unit, color: AppColors.coldChainBlue, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Your cart needs cold-chain delivery. Only compatible slots are shown.',
                    style: TextStyle(fontSize: 12, color: AppColors.coldChainBlue),
                  ),
                ),
              ],
            ),
          ),

          // Slot List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: _slots.length,
              itemBuilder: (context, index) {
                final slot = _slots[index];
                final isFull = (slot['remaining'] as int) == 0;
                final isLow = (slot['remaining'] as int) <= 3 && !isFull;
                final isSelected = _selectedSlotId == slot['id'];

                return GestureDetector(
                  onTap: isFull ? null : () => setState(() => _selectedSlotId = slot['id'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isFull ? Colors.grey.shade100 : Colors.white,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                      border: Border.all(
                        color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
                        width: isSelected ? 2 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ] : [],
                    ),
                    child: Row(
                      children: [
                        // Radio
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.outline,
                              width: 2,
                            ),
                            color: isSelected ? AppColors.primary : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check, color: Colors.white, size: 14)
                              : null,
                        ),
                        const SizedBox(width: 12),

                        // Slot Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                slot['time'] as String,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: isFull ? Colors.grey : AppColors.onSurface,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  if (slot['dryIce'] as bool)
                                    _badge('Dry Ice', AppColors.dryIcePurple, AppColors.dryIcePurpleMuted),
                                  if (slot['dryIce'] as bool) const SizedBox(width: 6),
                                  if (isFull)
                                    _badge('Full', AppColors.outOfStockRed, AppColors.errorContainer)
                                  else if (isLow)
                                    _badge('Only ${slot['remaining']} left!', AppColors.lowStockAmber, AppColors.flashDealOrangeMuted)
                                  else
                                    _badge('Available', AppColors.inStockGreen, AppColors.tertiaryContainer),
                                ],
                              ),
                            ],
                          ),
                        ),

                        // Fee
                        Text(
                          'Rs ${(slot['fee'] as double).toStringAsFixed(0)}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isFull ? Colors.grey : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Confirm Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ElevatedButton(
                onPressed: _selectedSlotId == null ? null : () => Navigator.pop(context, _selectedSlotId),
                child: const Text('Confirm Delivery Slot'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String label, Color color, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
