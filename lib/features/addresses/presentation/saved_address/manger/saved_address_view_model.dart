import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/delete_address_usecase.dart';
import '../../../domain/usecases/get_addresses_usecase.dart';
import '../../../domain/usecases/set_default_address_usecase.dart';
import 'saved_address_event.dart';
import 'saved_address_state.dart';
import 'selected_address_cubit/selected_address_event.dart';
import 'selected_address_cubit/selected_address_view_model.dart';

@lazySingleton
class SavedAddressViewModel extends Cubit<SavedAddressState> {
  final GetAddressesUseCase _getAddresses;
  final DeleteAddressUseCase _deleteAddress;
  final SetDefaultAddressUseCase _setDefaultAddress;
  final SelectedAddressViewModel _selectedAddressViewModel;

  SavedAddressViewModel(
      this._getAddresses,
      this._deleteAddress,
      this._setDefaultAddress,
      this._selectedAddressViewModel,
      ) : super(const SavedAddressState());

  void doEvent(SavedAddressEvent event) {
    switch (event) {
      case LoadAddresses():
        _loadAddresses();
      case DeleteAddressPressed():
        _deleteAndReload(event.id);
      case SetDefaultAddressPressed():
        _setDefaultAndReload(event.id);
    }
  }

  Future<void> _loadAddresses() async {
    emit(state.copyWith(
      addressesState: state.addressesState.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    ));

    try {
      final addresses = await _getAddresses.execute();

      emit(state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: false,
          data: addresses,
        ),
      ));
    } catch (e) {
      emit(state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      ));
    }
  }

  Future<void> _deleteAndReload(String id) async {
    emit(state.copyWith(
      addressesState: state.addressesState.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    ));

    try {
      final isDeleted = await _deleteAddress.execute(id);

      if (isDeleted) {
        // FIX: clear the selected address if it was the one just deleted,
        // so a stale addressId is never sent to checkout.
        if (_selectedAddressViewModel.state.addressId == id) {
          _selectedAddressViewModel.onEvent(AddressDeselectedEvent());
        }
        await _loadAddresses();
      } else {
        emit(state.copyWith(
          addressesState: state.addressesState.copyWith(
            isLoading: false,
            errorMessage: 'Failed to delete address.',
          ),
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      ));
    }
  }

  Future<void> _setDefaultAndReload(String id) async {
    emit(state.copyWith(
      addressesState: state.addressesState.copyWith(
        isLoading: true,
        errorMessage: '',
      ),
    ));

    try {
      await _setDefaultAddress.execute(id);
      await _loadAddresses();
    } catch (e) {
      emit(state.copyWith(
        addressesState: state.addressesState.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      ));
    }
  }
}