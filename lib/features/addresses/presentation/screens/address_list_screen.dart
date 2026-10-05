import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/address_entity.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';
import '../bloc/address_state.dart';
import 'add_edit_address_screen.dart';

class AddressListScreen extends StatelessWidget {
  final String userId;
  final bool isSelectionMode;

  const AddressListScreen({
    super.key,
    required this.userId,
    this.isSelectionMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(isSelectionMode ? 'Select Address' : 'My Addresses'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 0,
        centerTitle: true,
      ),
      body: BlocConsumer<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.successMessage!)),
            );
          }
        },
        builder: (context, state) {
          if (state.status == AddressStatus.loading && state.addresses.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AddressStatus.error && state.addresses.isEmpty) {
            return Center(child: Text(state.failure?.message ?? 'Failed to load addresses'));
          }

          if (state.addresses.isEmpty) {
            return const Center(
              child: Text(
                'No addresses found.\nAdd one to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.outline, fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: state.addresses.length,
            separatorBuilder: (context, index) => const SizedBox(height: AppSpacing.sm),
            itemBuilder: (context, index) {
              final address = state.addresses[index];
              return _AddressCard(
                address: address,
                userId: userId,
                isSelectionMode: isSelectionMode,
              );
            },
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<AddressBloc>(),
                    child: AddEditAddressScreen(userId: userId),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Add New Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final AddressEntity address;
  final String userId;
  final bool isSelectionMode;

  const _AddressCard({
    required this.address,
    required this.userId,
    required this.isSelectionMode,
  });

  IconData _getIcon() {
    switch (address.type) {
      case AddressType.office:
        return Icons.business;
      case AddressType.other:
        return Icons.location_on;
      case AddressType.home:
      default:
        return Icons.home;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : AppColors.outline.withOpacity(0.2),
          width: address.isDefault ? 2 : 1,
        ),
        boxShadow: [
          if (address.isDefault)
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(AppSpacing.md),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: address.isDefault ? AppColors.primary.withOpacity(0.1) : AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(_getIcon(), color: address.isDefault ? AppColors.primary : AppColors.outline),
        ),
        title: Row(
          children: [
            Text(address.label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            if (address.isDefault) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: AppColors.primary, borderRadius: BorderRadius.circular(12)),
                child: const Text('Default', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ]
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(address.recipientName, style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.secondary)),
              const SizedBox(height: 4),
              Text(address.fullAddress, style: const TextStyle(color: AppColors.outline, height: 1.4)),
              const SizedBox(height: 4),
              Text(address.recipientPhone, style: const TextStyle(color: AppColors.outline)),
            ],
          ),
        ),
        onTap: () {
          if (isSelectionMode) {
            Navigator.pop(context, address);
          } else if (!address.isDefault) {
            context.read<AddressBloc>().add(SetAddressAsDefault(userId: userId, addressId: address.id));
          }
        },
        trailing: isSelectionMode
            ? (address.isDefault ? const Icon(Icons.check_circle, color: AppColors.primary) : null)
            : PopupMenuButton(
                icon: const Icon(Icons.more_vert, color: AppColors.outline),
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: AppColors.error))),
                ],
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: context.read<AddressBloc>(),
                          child: AddEditAddressScreen(userId: userId, addressToEdit: address),
                        ),
                      ),
                    );
                  } else if (value == 'delete') {
                    context.read<AddressBloc>().add(DeleteExistingAddress(address.id));
                  }
                },
              ),
      ),
    );
  }
}
