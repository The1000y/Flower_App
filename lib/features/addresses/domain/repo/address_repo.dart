import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract interface class AddressRepo {
  Future<BaseResponce<AddressEntity>> addAddress({
    required AddAddressParams addAddressParams,
  });
  Future<List<GovernorateEntity>> getGovernorates();
  Future<List<CityEntity>> getCities({required String governorateId});
  Future<Position?> getCurrentLocation();
  Future<Placemark?> getReverseGeocodedAddress(LatLng coordinates);
}
