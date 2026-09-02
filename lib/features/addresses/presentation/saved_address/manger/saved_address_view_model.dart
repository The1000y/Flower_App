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
class SavedAddressViewModel extends Cubit<SavedAddressState> {
  final GetAddressesUseCase _getAddresses;
  final DeleteAddressUseCase _deleteAddress;
  final SetDefaultAddressUseCase _setDefaultAddress;

  SavedAddressViewModel(
      this._getAddresses,
      this._deleteAddress,
      this._setDefaultAddress,
      ) : super(SavedAddressInitial());

  Future<void> onEvent(SavedAddressEvent event) async {
    switch (event) {
      case LoadAddresses():
        await _loadAddresses();
      case DeleteAddressPressed(id: final id):
        await _deleteAndReload(id);
      case SetDefaultAddressPressed(id: final id):
        await _setDefaultAndReload(id);
    }
  }

  Future<void> _loadAddresses() async {
    emit(SavedAddressLoading());
    final response = await _getAddresses.execute();
    switch (response) {
      case SuccessResponce<List<AddressEntity>>():
        emit(SavedAddressLoaded(response.data));
      case ErrorResponce<List<AddressEntity>>():
        emit(SavedAddressError(response.error.toString()));
    }
  }

  Future<void> _deleteAndReload(String id) async {
    final response = await _deleteAddress.execute(id);
    switch (response) {
      case SuccessResponce<bool>():
        await _loadAddresses();
      case ErrorResponce<bool>():
        emit(SavedAddressError(response.error.toString()));
    }
  }

  Future<void> _setDefaultAndReload(String id) async {
    final response = await _setDefaultAddress.execute(id);
    switch (response) {
      case SuccessResponce<AddressEntity>():
        await _loadAddresses();
      case ErrorResponce<AddressEntity>():
        emit(SavedAddressError(response.error.toString()));
    }
  }
}