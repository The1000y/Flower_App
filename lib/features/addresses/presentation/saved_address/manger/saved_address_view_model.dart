import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../../config/base/base_responce.dart';
import '../../../domain/entities/address_entity.dart';
import '../../../domain/usecases/delete_address_usecase.dart';
import '../../../domain/usecases/get_addresses_usecase.dart';
import '../../../domain/usecases/set_default_address_usecase.dart';
import 'saved_address_event.dart';
import 'saved_address_state.dart';

@injectable
class SavedAddressCubit extends Cubit<SavedAddressState> {
  final GetAddressesUseCase _getAddresses;
  final DeleteAddressUseCase _deleteAddress;
  final SetDefaultAddressUseCase _setDefaultAddress;

  SavedAddressCubit(
      this._getAddresses,
      this._deleteAddress,
      this._setDefaultAddress,
      ) : super(const SavedAddressState());

  void handle(SavedAddressEvent event) {
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
      addressesState: state.addressesState.copyWith(isLoading: true, errorMessage: ''),
    ));

    final response = await _getAddresses.execute();

    switch (response) {
      case SuccessResponce():
        emit(state.copyWith(
          addressesState: state.addressesState.copyWith(isLoading: false, data: response.data),
        ));
      case ErrorResponce():
        emit(state.copyWith(
          addressesState: state.addressesState.copyWith(isLoading: false, errorMessage: response.error.toString()),
        ));
    }
  }

  Future<void> _deleteAndReload(String id) async {
    final response = await _deleteAddress.execute(id);
    switch (response) {
      case SuccessResponce():
        await _loadAddresses();
      case ErrorResponce():
        emit(state.copyWith(
          addressesState: state.addressesState.copyWith(errorMessage: response.error.toString()),
        ));
    }
  }

  Future<void> _setDefaultAndReload(String id) async {
    final response = await _setDefaultAddress.execute(id);
    switch (response) {
      case SuccessResponce():
        await _loadAddresses();
      case ErrorResponce():
        emit(state.copyWith(
          addressesState: state.addressesState.copyWith(errorMessage: response.error.toString()),
        ));
    }
  }
}