import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/address_usecases.dart';
import 'address_event.dart';
import 'address_state.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  final GetUserAddresses _getUserAddresses;
  final AddAddress _addAddress;
  final UpdateAddress _updateAddress;
  final DeleteAddress _deleteAddress;
  final SetDefaultAddress _setDefaultAddress;

  AddressBloc({
    required GetUserAddresses getUserAddresses,
    required AddAddress addAddress,
    required UpdateAddress updateAddress,
    required DeleteAddress deleteAddress,
    required SetDefaultAddress setDefaultAddress,
  })  : _getUserAddresses = getUserAddresses,
        _addAddress = addAddress,
        _updateAddress = updateAddress,
        _deleteAddress = deleteAddress,
        _setDefaultAddress = setDefaultAddress,
        super(const AddressState()) {
    on<FetchAddresses>(_onFetchAddresses);
    on<AddNewAddress>(_onAddNewAddress);
    on<UpdateExistingAddress>(_onUpdateExistingAddress);
    on<DeleteExistingAddress>(_onDeleteExistingAddress);
    on<SetAddressAsDefault>(_onSetAddressAsDefault);
  }

  Future<void> _onFetchAddresses(
    FetchAddresses event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _getUserAddresses(event.userId);
    result.fold(
      (failure) => emit(state.copyWith(status: AddressStatus.error, failure: failure)),
      (addresses) => emit(state.copyWith(status: AddressStatus.loaded, addresses: addresses)),
    );
  }

  Future<void> _onAddNewAddress(
    AddNewAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _addAddress(event.address);
    result.fold(
      (failure) => emit(state.copyWith(status: AddressStatus.error, failure: failure)),
      (newAddress) {
        final updatedList = List.of(state.addresses)..insert(0, newAddress);
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updatedList,
          successMessage: 'Address added successfully',
        ));
      },
    );
  }

  Future<void> _onUpdateExistingAddress(
    UpdateExistingAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _updateAddress(event.address);
    result.fold(
      (failure) => emit(state.copyWith(status: AddressStatus.error, failure: failure)),
      (updatedAddress) {
        final updatedList = state.addresses.map((a) {
          return a.id == updatedAddress.id ? updatedAddress : a;
        }).toList();
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updatedList,
          successMessage: 'Address updated successfully',
        ));
      },
    );
  }

  Future<void> _onDeleteExistingAddress(
    DeleteExistingAddress event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _deleteAddress(event.addressId);
    result.fold(
      (failure) => emit(state.copyWith(status: AddressStatus.error, failure: failure)),
      (_) {
        final updatedList = state.addresses.where((a) => a.id != event.addressId).toList();
        emit(state.copyWith(
          status: AddressStatus.success,
          addresses: updatedList,
          successMessage: 'Address deleted successfully',
        ));
      },
    );
  }

  Future<void> _onSetAddressAsDefault(
    SetAddressAsDefault event,
    Emitter<AddressState> emit,
  ) async {
    emit(state.copyWith(status: AddressStatus.loading));
    final result = await _setDefaultAddress(event.userId, event.addressId);
    result.fold(
      (failure) => emit(state.copyWith(status: AddressStatus.error, failure: failure)),
      (_) {
        // Re-fetch to ensure sync with backend logic that cleared other defaults
        add(FetchAddresses(event.userId));
      },
    );
  }
}
