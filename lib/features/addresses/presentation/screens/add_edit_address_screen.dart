import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../domain/entities/address_entity.dart';
import '../bloc/address_bloc.dart';
import '../bloc/address_event.dart';

class AddEditAddressScreen extends StatefulWidget {
  final String userId;
  final AddressEntity? addressToEdit;

  const AddEditAddressScreen({
    super.key,
    required this.userId,
    this.addressToEdit,
  });

  @override
  State<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends State<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  late TextEditingController _labelCtrl;
  late TextEditingController _nameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _streetCtrl;
  late TextEditingController _aptCtrl;
  late TextEditingController _cityCtrl;
  late TextEditingController _stateCtrl;
  late TextEditingController _zipCtrl;
  
  AddressType _selectedType = AddressType.home;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.addressToEdit;
    _labelCtrl = TextEditingController(text: a?.label ?? '');
    _nameCtrl = TextEditingController(text: a?.recipientName ?? '');
    _phoneCtrl = TextEditingController(text: a?.recipientPhone ?? '');
    _streetCtrl = TextEditingController(text: a?.street ?? '');
    _aptCtrl = TextEditingController(text: a?.apartment ?? '');
    _cityCtrl = TextEditingController(text: a?.city ?? '');
    _stateCtrl = TextEditingController(text: a?.state ?? '');
    _zipCtrl = TextEditingController(text: a?.postalCode ?? '');
    
    if (a != null) {
      _selectedType = a.type;
      _isDefault = a.isDefault;
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _streetCtrl.dispose();
    _aptCtrl.dispose();
    _cityCtrl.dispose();
    _stateCtrl.dispose();
    _zipCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final now = DateTime.now();
      final address = AddressEntity(
        id: widget.addressToEdit?.id ?? const Uuid().v4(),
        userId: widget.userId,
        label: _labelCtrl.text.trim(),
        type: _selectedType,
        recipientName: _nameCtrl.text.trim(),
        recipientPhone: _phoneCtrl.text.trim(),
        street: _streetCtrl.text.trim(),
        apartment: _aptCtrl.text.trim().isNotEmpty ? _aptCtrl.text.trim() : null,
        city: _cityCtrl.text.trim(),
        state: _stateCtrl.text.trim(),
        country: 'US', // Hardcoded for blueprint
        postalCode: _zipCtrl.text.trim(),
        isDefault: _isDefault,
        createdAt: widget.addressToEdit?.createdAt ?? now,
        updatedAt: now,
      );

      if (widget.addressToEdit == null) {
        context.read<AddressBloc>().add(AddNewAddress(address));
      } else {
        context.read<AddressBloc>().add(UpdateExistingAddress(address));
      }
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(widget.addressToEdit == null ? 'Add Address' : 'Edit Address'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // Type Selection
            Row(
              children: AddressType.values.map((t) => Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedType = t),
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _selectedType == t ? AppColors.primary : Colors.white,
                      border: Border.all(color: _selectedType == t ? AppColors.primary : AppColors.outline.withOpacity(0.2)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      t.name.toUpperCase(),
                      style: TextStyle(
                        color: _selectedType == t ? Colors.white : AppColors.outline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: AppSpacing.lg),
            
            _buildField('Address Label (e.g. My Apartment)', _labelCtrl),
            _buildField('Recipient Name', _nameCtrl),
            _buildField('Phone Number', _phoneCtrl, keyboardType: TextInputType.phone),
            _buildField('Street Address', _streetCtrl),
            _buildField('Apt, Suite, Bldg (optional)', _aptCtrl, isRequired: false),
            
            Row(
              children: [
                Expanded(child: _buildField('City', _cityCtrl)),
                const SizedBox(width: AppSpacing.md),
                Expanded(child: _buildField('State', _stateCtrl)),
              ],
            ),
            _buildField('Zip / Postal Code', _zipCtrl, keyboardType: TextInputType.number),
            
            const SizedBox(height: AppSpacing.md),
            SwitchListTile(
              title: const Text('Set as Default Address', style: TextStyle(fontWeight: FontWeight.bold)),
              value: _isDefault,
              activeColor: AppColors.primary,
              onChanged: (val) => setState(() => _isDefault = val),
              contentPadding: EdgeInsets.zero,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: ElevatedButton(
            onPressed: _save,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text('Save Address', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }

  Widget _buildField(String label, TextEditingController controller, {bool isRequired = true, TextInputType? keyboardType}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.outline.withOpacity(0.2)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.outline.withOpacity(0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        validator: isRequired ? (val) {
          if (val == null || val.trim().isEmpty) return 'This field is required';
          return null;
        } : null,
      ),
    );
  }
}
