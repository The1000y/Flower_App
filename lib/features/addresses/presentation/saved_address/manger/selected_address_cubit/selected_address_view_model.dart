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
        emit(SelectedAddressState(
          addressId: event.addressId,
          label: event.label,
        ));
    }
  }
}