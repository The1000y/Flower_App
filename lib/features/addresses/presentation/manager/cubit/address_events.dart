import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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
  final AddAddressRequest addAddressRequest;
  SubmitAddressEvent({required this.addAddressRequest});
}
