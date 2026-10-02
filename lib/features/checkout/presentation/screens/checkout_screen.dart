import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  int _currentStep = 0;
  String? _selectedAddressId;
  String? _selectedSlotId;
  String _selectedPaymentMethod = 'card';
  bool _coldChainConfirmed = false;
  bool _tempIntegrityConfirmed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: AppColors.surface,
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) setState(() => _currentStep++);
        },
        onStepCancel: () {
          if (_currentStep > 0) setState(() => _currentStep--);
        },
        controlsBuilder: (context, details) {
          return Padding(
            padding: const EdgeInsets.only(top: AppSpacing.md),
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: details.onStepContinue,
                  child: Text(_currentStep == 3 ? 'Place Order' : 'Continue'),
                ),
                const SizedBox(width: 12),
                if (_currentStep > 0)
                  TextButton(
                    onPressed: details.onStepCancel,
                    child: const Text('Back'),
                  ),
              ],
            ),
          );
        },
        steps: [
          // Step 1 - Address
          Step(
            title: const Text('Delivery Address'),
            isActive: _currentStep >= 0,
            state: _currentStep > 0 ? StepState.complete : StepState.indexed,
            content: _AddressStep(
              selectedId: _selectedAddressId,
              onSelected: (id) => setState(() => _selectedAddressId = id),
            ),
          ),
          // Step 2 - Delivery Slot
          Step(
            title: const Text('Delivery Slot'),
            isActive: _currentStep >= 1,
            state: _currentStep > 1 ? StepState.complete : StepState.indexed,
            content: _SlotStep(
              selectedSlotId: _selectedSlotId,
              onSelected: (id) => setState(() => _selectedSlotId = id),
            ),
          ),
          // Step 3 - Cold Chain Confirmation
          Step(
            title: const Text('Cold-Chain Acknowledgement'),
            isActive: _currentStep >= 2,
            state: _currentStep > 2 ? StepState.complete : StepState.indexed,
            content: _ColdChainStep(
              coldChainConfirmed: _coldChainConfirmed,
              tempIntegrityConfirmed: _tempIntegrityConfirmed,
              onColdChainChanged: (v) => setState(() => _coldChainConfirmed = v),
              onTempChanged: (v) => setState(() => _tempIntegrityConfirmed = v),
            ),
          ),
          // Step 4 - Payment
          Step(
            title: const Text('Payment'),
            isActive: _currentStep >= 3,
            state: StepState.indexed,
            content: _PaymentStep(
              selectedMethod: _selectedPaymentMethod,
              onMethodSelected: (method) => setState(() => _selectedPaymentMethod = method),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressStep extends StatelessWidget {
  final String? selectedId;
  final ValueChanged<String> onSelected;

  const _AddressStep({required this.selectedId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final addresses = [
      {'id': 'addr_1', 'label': 'Home', 'address': '34-B, Gulshan-e-Iqbal, Block 13, Karachi'},
      {'id': 'addr_2', 'label': 'Office', 'address': 'Plot 7, Tech Park, Shahrah-e-Faisal, Karachi'},
    ];

    return Column(
      children: [
        ...addresses.map((addr) => RadioListTile<String>(
          value: addr['id']!,
          groupValue: selectedId,
          onChanged: (v) => onSelected(v!),
          title: Text(addr['label']!, style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(addr['address']!),
          activeColor: AppColors.primary,
          contentPadding: EdgeInsets.zero,
        )),
        TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('Add New Address'),
        ),
      ],
    );
  }
}

class _SlotStep extends StatelessWidget {
  final String? selectedSlotId;
  final ValueChanged<String> onSelected;

  const _SlotStep({required this.selectedSlotId, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedSlotId != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Row(
              children: [
                const Icon(Icons.schedule, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  'Selected: Today, 9:00 AM – 11:00 AM',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
          )
        else
          OutlinedButton.icon(
            onPressed: () {
              // Navigate to DeliverySlotPickerScreen
            },
            icon: const Icon(Icons.schedule),
            label: const Text('Choose a Delivery Slot'),
          ),
      ],
    );
  }
}

class _ColdChainStep extends StatelessWidget {
  final bool coldChainConfirmed;
  final bool tempIntegrityConfirmed;
  final ValueChanged<bool> onColdChainChanged;
  final ValueChanged<bool> onTempChanged;

  const _ColdChainStep({
    required this.coldChainConfirmed,
    required this.tempIntegrityConfirmed,
    required this.onColdChainChanged,
    required this.onTempChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.coldChainBlueMuted,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.coldChainBlue),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.ac_unit, color: AppColors.coldChainBlue),
              SizedBox(width: 8),
              Text(
                'Cold-Chain Acknowledgement',
                style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.coldChainBlue),
              ),
            ],
          ),
          const Divider(height: 16),
          CheckboxListTile(
            value: coldChainConfirmed,
            onChanged: (v) => onColdChainChanged(v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'I understand these items must be kept frozen and handled with care upon receipt.',
              style: TextStyle(fontSize: 13),
            ),
            activeColor: AppColors.primary,
          ),
          CheckboxListTile(
            value: tempIntegrityConfirmed,
            onChanged: (v) => onTempChanged(v ?? false),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            title: const Text(
              'I confirm temperature integrity may not be guaranteed if not received promptly.',
              style: TextStyle(fontSize: 13),
            ),
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _PaymentStep extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onMethodSelected;

  const _PaymentStep({required this.selectedMethod, required this.onMethodSelected});

  @override
  Widget build(BuildContext context) {
    final methods = [
      {'id': 'card', 'label': 'Credit / Debit Card', 'icon': Icons.credit_card},
      {'id': 'cash', 'label': 'Cash on Delivery', 'icon': Icons.payments_outlined},
      {'id': 'wallet', 'label': 'Digital Wallet', 'icon': Icons.account_balance_wallet_outlined},
    ];

    return Column(
      children: methods.map((method) => RadioListTile<String>(
        value: method['id'] as String,
        groupValue: selectedMethod,
        onChanged: (v) => onMethodSelected(v!),
        activeColor: AppColors.primary,
        contentPadding: EdgeInsets.zero,
        secondary: Icon(method['icon'] as IconData, color: AppColors.primary),
        title: Text(method['label'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
      )).toList(),
    );
  }
}
