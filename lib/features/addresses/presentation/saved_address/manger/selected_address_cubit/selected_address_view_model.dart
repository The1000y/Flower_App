import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'selected_address_event.dart';
import 'selected_address_state.dart';

@lazySingleton
class SelectedAddressViewModel extends Cubit<SelectedAddressState> {
  SelectedAddressViewModel() : super(const SelectedAddressState());

  void onEvent(SelectedAddressEvent event) {
    switch (event) {
      case AddressSelectedEvent():
        print('✅ [SelectedAddressViewModel] Address Selected! ID: ${event.addressId}, Label: ${event.label}');
        emit(SelectedAddressState(
          addressId: event.addressId,
          label: event.label,
        ));
      case AddressDeselectedEvent():
        print('❌ [SelectedAddressViewModel] Address Deselected!');
        emit(const SelectedAddressState());
    }
  }
}