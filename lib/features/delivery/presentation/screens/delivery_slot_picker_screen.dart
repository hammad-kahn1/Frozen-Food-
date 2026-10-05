import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../bloc/delivery_cubit.dart';
import '../bloc/delivery_state.dart';

class DeliverySlotPickerScreen extends StatelessWidget {
  final bool requiresColdChain;
  final bool requiresDryIce;

  const DeliverySlotPickerScreen({
    super.key,
    this.requiresColdChain = false,
    this.requiresDryIce = false,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<DeliveryCubit>()..fetchSlotsForDate(
        DateTime.now(),
        requiresColdChain: requiresColdChain,
        requiresDryIce: requiresDryIce,
      ),
      child: _DeliverySlotPickerView(
        requiresColdChain: requiresColdChain,
        requiresDryIce: requiresDryIce,
      ),
    );
  }
}

class _DeliverySlotPickerView extends StatefulWidget {
  final bool requiresColdChain;
  final bool requiresDryIce;

  const _DeliverySlotPickerView({
    required this.requiresColdChain,
    required this.requiresDryIce,
  });

  @override
  State<_DeliverySlotPickerView> createState() => _DeliverySlotPickerViewState();
}

class _DeliverySlotPickerViewState extends State<_DeliverySlotPickerView> {
  int _selectedDayIndex = 0;
  String? _selectedSlotId;

  List<DateTime> get _days {
    final now = DateTime.now();
    return List.generate(5, (index) => now.add(Duration(days: index)));
  }

  String _formatDay(DateTime date, int index) {
    if (index == 0) return 'Today';
    if (index == 1) return 'Tomorrow';
    return DateFormat('EEE').format(date); // Wed, Thu, Fri
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Select Delivery Slot'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.onSurface,
        elevation: 0,
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
                final date = _days[index];
                final selected = _selectedDayIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                      _selectedSlotId = null; // reset selection
                    });
                    context.read<DeliveryCubit>().changeDate(
                          date,
                          requiresColdChain: widget.requiresColdChain,
                          requiresDryIce: widget.requiresDryIce,
                        );
                  },
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
                      _formatDay(date, index),
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
          if (widget.requiresColdChain)
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
            child: BlocBuilder<DeliveryCubit, DeliveryState>(
              builder: (context, state) {
                if (state.status == DeliveryStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.status == DeliveryStatus.error) {
                  return Center(child: Text(state.failure?.message ?? 'Failed to load slots'));
                }
                if (state.slots.isEmpty) {
                  return const Center(
                    child: Text(
                      'No available slots for this day.\nPlease select another day.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.outline, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  itemCount: state.slots.length,
                  itemBuilder: (context, index) {
                    final slot = state.slots[index];
                    final isFull = slot.isFull;
                    final isLow = slot.isAlmostFull;
                    final isSelected = _selectedSlotId == slot.id;

                    return GestureDetector(
                      onTap: isFull ? null : () => setState(() => _selectedSlotId = slot.id),
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
                                    slot.timeRangeDisplay,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: isFull ? Colors.grey : AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      if (slot.dryIceSupported)
                                        _badge('Dry Ice', AppColors.dryIcePurple, AppColors.dryIcePurpleMuted),
                                      if (slot.dryIceSupported) const SizedBox(width: 6),
                                      if (isFull)
                                        _badge('Full', AppColors.outOfStockRed, AppColors.errorContainer)
                                      else if (isLow)
                                        _badge('Only ${slot.remainingCapacity} left!', AppColors.lowStockAmber, AppColors.flashDealOrangeMuted)
                                      else
                                        _badge('Available', AppColors.inStockGreen, AppColors.tertiaryContainer),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Fee
                            Text(
                              '\$${slot.deliveryFee.toStringAsFixed(2)}',
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
                );
              },
            ),
          ),

          // Confirm Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: ElevatedButton(
                onPressed: _selectedSlotId == null
                    ? null
                    : () {
                        // Find slot object
                        final selectedSlot = context.read<DeliveryCubit>().state.slots.firstWhere((s) => s.id == _selectedSlotId);
                        Navigator.pop(context, selectedSlot);
                      },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Confirm Delivery Slot', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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
