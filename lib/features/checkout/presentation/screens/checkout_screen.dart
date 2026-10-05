import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_radius.dart';
import '../../../addresses/domain/entities/address_entity.dart';
import '../../../addresses/presentation/bloc/address_bloc.dart';
import '../../../addresses/presentation/bloc/address_event.dart';
import '../../../addresses/presentation/bloc/address_state.dart';
import '../../../addresses/presentation/screens/address_list_screen.dart';
import '../../../cart/presentation/bloc/cart_bloc.dart';
import '../../../cart/presentation/bloc/cart_state.dart';
import '../../../delivery/domain/entities/delivery_slot_entity.dart';
import '../../../delivery/presentation/screens/delivery_slot_picker_screen.dart';
import '../../../orders/domain/entities/order_entity.dart';
import '../../../orders/domain/entities/order_item_entity.dart';
import '../../../orders/domain/enums/order_status.dart';
import '../../../orders/domain/enums/payment_status.dart' as order_payment;
import '../../../payments/presentation/bloc/payment_bloc.dart';
import '../../../payments/presentation/bloc/payment_event.dart';
import '../../../payments/presentation/bloc/payment_state.dart' as pay_state;
import '../bloc/checkout_bloc.dart';
import '../bloc/checkout_event.dart';
import '../bloc/checkout_state.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<CheckoutBloc>()),
        BlocProvider(create: (_) => sl<PaymentBloc>()),
        // AddressBloc is already global, but let's just use the global instance
      ],
      child: const _CheckoutView(),
    );
  }
}

class _CheckoutView extends StatefulWidget {
  const _CheckoutView();

  @override
  State<_CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<_CheckoutView> {
  int _currentStep = 0;
  
  AddressEntity? _selectedAddress;
  DeliverySlotEntity? _selectedSlot;
  String _selectedPaymentMethod = 'card';
  bool _coldChainConfirmed = false;
  bool _tempIntegrityConfirmed = false;

  void _placeOrder() {
    final cartState = context.read<CartBloc>().state;
    if (cartState.status == CartStatus.loaded && cartState.cart != null && cartState.cart!.items.isNotEmpty) {
      if (_selectedAddress == null || _selectedSlot == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select address and delivery slot')));
        return;
      }
      if (cartState.cart.requiresColdChain && (!_coldChainConfirmed || !_tempIntegrityConfirmed)) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please acknowledge cold-chain terms')));
        return;
      }

      // 1. Initialize Payment
      final total = cartState.cart!.subtotal + _selectedSlot!.deliveryFee;
      context.read<PaymentBloc>().add(InitializePayment(
        amount: total,
        currency: 'USD',
      ));
    }
  }

  void _onPaymentSuccess(String clientSecret) {
    // In a real app, confirm with Stripe. We are mocking confirmation.
    context.read<PaymentBloc>().add(ConfirmPaymentEvent(clientSecret: clientSecret));
  }

  void _createOrderEntity() {
    final cartState = context.read<CartBloc>().state;
    final cart = cartState.cart;
    if (cart != null) {
      final order = OrderEntity(
        id: const Uuid().v4(),
        userId: cart.userId ?? 'guest',
        shippingAddress: _selectedAddress!,
        deliverySlot: _selectedSlot!,
        items: cart.items.map((e) => OrderItemEntity(
          productId: e.productId,
          variantId: e.variantId,
          productName: e.productName,
          variantName: e.variantName,
          imageUrl: e.imageUrl,
          quantity: e.quantity,
          unitPrice: e.unitPrice,
          totalPrice: e.totalPrice,
          coldChainRequired: e.coldChainRequired,
          requiresDryIce: e.requiresDryIce,
        )).toList(),
        subtotal: cart.subtotal,
        discount: 0,
        deliveryFee: _selectedSlot!.deliveryFee,
        tip: 0,
        tax: 0,
        total: cart.subtotal + _selectedSlot!.deliveryFee,
        currency: 'USD',
        status: OrderStatus.confirmed,
        paymentStatus: order_payment.PaymentStatus.paid,
        paymentMethod: _selectedPaymentMethod,
        coldChainConfirmed: _coldChainConfirmed,
        temperatureIntegrityConfirmed: _tempIntegrityConfirmed,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      context.read<CheckoutBloc>().add(PlaceCheckoutOrder(order));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<PaymentBloc, pay_state.PaymentState>(
          listener: (context, state) {
            if (state.status == pay_state.PaymentStatus.intentCreated && state.paymentIntent != null) {
              _onPaymentSuccess(state.paymentIntent!.clientSecret);
            } else if (state.status == pay_state.PaymentStatus.success) {
              _createOrderEntity();
            } else if (state.status == pay_state.PaymentStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure?.message ?? 'Payment failed')));
            }
          },
        ),
        BlocListener<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state.status == CheckoutStatus.success) {
              // Clear cart (in a real app)
              // context.read<CartBloc>().add(ClearCart()); 
              context.go('/orders'); // Go to orders list
            } else if (state.status == CheckoutStatus.error) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.failure?.message ?? 'Failed to place order')));
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.surface,
        appBar: AppBar(
          title: const Text('Checkout'),
          backgroundColor: AppColors.surface,
          elevation: 0,
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, cartState) {
            final isCartReady = cartState.status == CartStatus.loaded && cartState.cart != null;
            if (!isCartReady) {
              return const Center(child: CircularProgressIndicator());
            }
            final cart = cartState.cart!;

            final requiresColdChain = cart.requiresColdChain;

            return BlocBuilder<CheckoutBloc, CheckoutState>(
              builder: (context, checkoutState) {
                final isProcessing = checkoutState.status == CheckoutStatus.loading || 
                                     context.watch<PaymentBloc>().state.status == pay_state.PaymentStatus.loading ||
                                     context.watch<PaymentBloc>().state.status == pay_state.PaymentStatus.processing;

                return Stack(
                  children: [
                    Stepper(
                      currentStep: _currentStep,
                      onStepContinue: () {
                        if (_currentStep == 0 && _selectedAddress == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select an address first')));
                          return;
                        }
                        if (_currentStep == 1 && _selectedSlot == null) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Select a delivery slot first')));
                          return;
                        }
                        if (_currentStep == 2 && requiresColdChain && (!_coldChainConfirmed || !_tempIntegrityConfirmed)) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the cold chain terms')));
                          return;
                        }
                        
                        if (_currentStep < (requiresColdChain ? 3 : 2)) {
                          setState(() => _currentStep++);
                        } else if (_currentStep == (requiresColdChain ? 3 : 2)) {
                          _placeOrder();
                        }
                      },
                      onStepCancel: () {
                        if (_currentStep > 0) setState(() => _currentStep--);
                      },
                      controlsBuilder: (context, details) {
                        final isLastStep = _currentStep == (requiresColdChain ? 3 : 2);
                        return Padding(
                          padding: const EdgeInsets.only(top: AppSpacing.md),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: isProcessing ? null : details.onStepContinue,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(isLastStep ? 'Place Order - \$${(cartState.cart.subtotal + (_selectedSlot?.deliveryFee ?? 0)).toStringAsFixed(2)}' : 'Continue'),
                              ),
                              const SizedBox(width: 12),
                              if (_currentStep > 0)
                                TextButton(
                                  onPressed: isProcessing ? null : details.onStepCancel,
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
                            userId: cartState.cart.userId,
                            selectedAddress: _selectedAddress,
                            onSelected: (addr) => setState(() => _selectedAddress = addr),
                          ),
                        ),
                        // Step 2 - Delivery Slot
                        Step(
                          title: const Text('Delivery Slot'),
                          isActive: _currentStep >= 1,
                          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
                          content: _SlotStep(
                            requiresColdChain: requiresColdChain,
                            selectedSlot: _selectedSlot,
                            onSelected: (slot) => setState(() => _selectedSlot = slot),
                          ),
                        ),
                        // Step 3 - Cold Chain Confirmation (Only if required)
                        if (requiresColdChain)
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
                          isActive: _currentStep >= (requiresColdChain ? 3 : 2),
                          state: StepState.indexed,
                          content: _PaymentStep(
                            selectedMethod: _selectedPaymentMethod,
                            onMethodSelected: (method) => setState(() => _selectedPaymentMethod = method),
                          ),
                        ),
                      ],
                    ),
                    if (isProcessing)
                      Container(
                        color: Colors.black12,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _AddressStep extends StatelessWidget {
  final String userId;
  final AddressEntity? selectedAddress;
  final ValueChanged<AddressEntity> onSelected;

  const _AddressStep({required this.userId, required this.selectedAddress, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedAddress != null)
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(selectedAddress!.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(selectedAddress!.fullAddress),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () async {
            // Pre-fetch addresses
            context.read<AddressBloc>().add(FetchAddresses(userId));
            final result = await Navigator.push<AddressEntity>(
              context,
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<AddressBloc>(),
                  child: AddressListScreen(userId: userId, isSelectionMode: true),
                ),
              ),
            );
            if (result != null) {
              onSelected(result);
            }
          },
          icon: const Icon(Icons.location_on),
          label: Text(selectedAddress == null ? 'Choose Address' : 'Change Address'),
        ),
      ],
    );
  }
}

class _SlotStep extends StatelessWidget {
  final bool requiresColdChain;
  final DeliverySlotEntity? selectedSlot;
  final ValueChanged<DeliverySlotEntity> onSelected;

  const _SlotStep({required this.requiresColdChain, required this.selectedSlot, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (selectedSlot != null)
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
                Expanded(
                  child: Text(
                    'Selected: ${selectedSlot!.timeRangeDisplay} - \$${selectedSlot!.deliveryFee.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: AppSpacing.sm),
        OutlinedButton.icon(
          onPressed: () async {
            final result = await Navigator.push<DeliverySlotEntity>(
              context,
              MaterialPageRoute(
                builder: (_) => DeliverySlotPickerScreen(requiresColdChain: requiresColdChain),
              ),
            );
            if (result != null) {
              onSelected(result);
            }
          },
          icon: const Icon(Icons.schedule),
          label: Text(selectedSlot == null ? 'Choose Delivery Slot' : 'Change Delivery Slot'),
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
      {'id': 'card', 'label': 'Credit / Debit Card (Stripe)', 'icon': Icons.credit_card},
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
