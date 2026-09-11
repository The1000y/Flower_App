import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../domain/entities/address_entity.dart';

sealed class AddressEvents {}

class InitializeAddressEvent extends AddressEvents {
  final AddressEntity? existingAddress;

  InitializeAddressEvent({this.existingAddress});
}

class SelectLocationFromMapEvent extends AddressEvents {
  LatLng coordinates;
  SelectLocationFromMapEvent({required this.coordinates});
}

class SelectGovernorateEvent extends AddressEvents {
  final String governorateId;
  SelectGovernorateEvent({required this.governorateId});
}

class SelectCityEvent extends AddressEvents {
  final String cityId;
  SelectCityEvent({required this.cityId});
}

class SubmitAddressEvent extends AddressEvents {
  final AddAddressParams addAddressParams;
  SubmitAddressEvent({required this.addAddressParams});
}

class UpdateExistingAddressEvent extends AddressEvents {
  final String id;
  final AddAddressParams params;
  UpdateExistingAddressEvent({required this.id, required this.params});
}
