import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/address_local_data_source.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/location_data_source.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/request/update_address_request_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepo)
class AddressRepoImpl implements AddressRepo {
  final AddressLocalDataSource addressLocalDataSource;
  final LocationDataSource locationDataSource;

  AddressRepoImpl(this.addressLocalDataSource, this.locationDataSource);

  @override
  Future<BaseResponce<AddressEntity>> addAddress({
    required AddAddressParams addAddressParams,
  }) async {
    var response = await addressLocalDataSource.addAddress(
      addAddressRequest: AddAddressRequest(
        recipientName: addAddressParams.recipientName,
        recipientPhone: addAddressParams.recipientPhone,
        addressLine: addAddressParams.addressLine,
        city: addAddressParams.city,
        area: addAddressParams.area,
        lat: addAddressParams.lat,
        lng: addAddressParams.lng,
        label: addAddressParams.label,
      ),
    );

    switch (response) {
      case SuccessResponce<AddressDto>():
        return SuccessResponce(response.data.toDomain());

      case ErrorResponce<AddressDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<List<CityEntity>> getCities({required String governorateId}) async {
    return await addressLocalDataSource.getCities(governorateId: governorateId);
  }

  @override
  Future<List<GovernorateEntity>> getGovernorates() async {
    return await addressLocalDataSource.getGovernorates();
  }

  @override
  Future<Position?> getCurrentLocation() async {
    return await locationDataSource.checkAndRequestLocationAccess();
  }

  @override
  Future<Placemark?> getReverseGeocodedAddress(LatLng coordinates) async {
    return await locationDataSource.getReverseGeocodedAddress(coordinates);
  }

  @override
  Future<List<AddressEntity>> getAddresses() async {
    final response = await addressLocalDataSource.getAddresses();
    switch (response) {
      case SuccessResponce<List<AddressDto>>():
        return response.data.map((e) => e.toDomain()).toList();
      case ErrorResponce<List<AddressDto>>():
        throw response.error;
    }
  }

  @override
  Future<bool> deleteAddress(String id) async {
    final response = await addressLocalDataSource.deleteAddress(id);
    switch (response) {
      case SuccessResponce<bool>():
        return response.data;
      case ErrorResponce<bool>():
        throw response.error;
    }
  }

  @override
  Future<AddressEntity> setDefaultAddress(String id) async {
    final response = await addressLocalDataSource.setDefaultAddress(id);
    switch (response) {
      case SuccessResponce<AddressDto>():
        return response.data.toDomain();
      case ErrorResponce<AddressDto>():
        throw response.error;
    }
  }

  @override
  Future<AddressEntity> updateAddress({
    required String id,
    required AddAddressParams params,
  }) async {
    final response = await addressLocalDataSource.updateAddress(
      id: id,
      request: UpdateAddressRequestDto(
        recipientName: params.recipientName,
        recipientPhone: params.recipientPhone,
        addressLine: params.addressLine,
        city: params.city,
        area: params.area,
        lat: params.lat,
        lng: params.lng,
        label: params.label,
      ),
    );

    switch (response) {
      case SuccessResponce<AddressDto>():
        return response.data.toDomain();
      case ErrorResponce<AddressDto>():
        throw response.error;
    }
  }
}
