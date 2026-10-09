import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/location_data_source.dart';
import 'package:flower_app/features/addresses/data/data_source/remote_data_source/address_remote_data_source.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/request/update_address_request_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/area_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/nearest_store_dto.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/entities/store_entity.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepo)
class AddressRepoImpl implements AddressRepo {
  final AddressRemoteDataSource addressRemoteDataSource;
  final LocationDataSource locationDataSource;

  AddressRepoImpl(this.addressRemoteDataSource, this.locationDataSource);

  @override
  Future<BaseResponce<AddressEntity>> addAddress({
    required AddAddressParams addAddressParams,
  }) async {
    final response = await addressRemoteDataSource.addAddress(
      addAddressRequest: AddAddressRequest(
        recipientName: addAddressParams.recipientName,
        phone: addAddressParams.recipientPhone,
        addressLine: addAddressParams.addressLine,
        cityId: addAddressParams.cityId,
        areaId: addAddressParams.areaId,
        latitude: addAddressParams.lat,
        longitude: addAddressParams.lng,
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
    final response = await addressRemoteDataSource.getAreas();
    switch (response) {
      case SuccessResponce<List<AreaDto>>():
        final matchedArea = response.data
            .where((area) => area.id == governorateId)
            .toList();
        final cities = matchedArea
            .expand((area) => area.cities ?? const <CityItemDto>[])
            .where((city) => city.id?.isNotEmpty ?? false)
            .map(
              (city) => CityEntity(
                id: city.id ?? '',
                governorateId: governorateId,
                nameAr: city.name ?? '',
                nameEn: city.name ?? '',
              ),
            )
            .toList();
        return cities;
      case ErrorResponce<List<AreaDto>>():
        throw response.error;
    }
  }

  @override
  Future<List<GovernorateEntity>> getGovernorates() async {
    final response = await addressRemoteDataSource.getAreas();
    switch (response) {
      case SuccessResponce<List<AreaDto>>():
        return response.data
            .where((area) => area.id?.isNotEmpty ?? false)
            .map(
              (area) => GovernorateEntity(
                id: area.id ?? '',
                nameAr: area.name ?? '',
                nameEn: area.name ?? '',
              ),
            )
            .toList();
      case ErrorResponce<List<AreaDto>>():
        throw response.error;
    }
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
    final response = await addressRemoteDataSource.getAddresses();
    switch (response) {
      case SuccessResponce<List<AddressDto>>():
        return response.data.map((e) => e.toDomain()).toList();
      case ErrorResponce<List<AddressDto>>():
        throw response.error;
    }
  }

  @override
  Future<bool> deleteAddress(String id) async {
    final response = await addressRemoteDataSource.deleteAddress(id);
    switch (response) {
      case SuccessResponce<bool>():
        return response.data;
      case ErrorResponce<bool>():
        throw response.error;
    }
  }

  @override
  Future<AddressEntity> setDefaultAddress(String id) async {
    final response = await addressRemoteDataSource.setDefaultAddress(id);
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
    final response = await addressRemoteDataSource.updateAddress(
      id: id,
      request: UpdateAddressRequestDto(
        recipientName: params.recipientName,
        phone: params.recipientPhone,
        addressLine: params.addressLine,
        cityId: params.cityId,
        areaId: params.areaId,
        latitude: params.lat,
        longitude: params.lng,
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

  @override
  Future<BaseResponce<StoreEntity>> getNearestStore({
    required double latitude,
    required double longitude,
  }) async {
    final response = await addressRemoteDataSource.getNearestStore(
      latitude: latitude,
      longitude: longitude,
    );
    switch (response) {
      case SuccessResponce<NearestStoreDto>():
        return SuccessResponce(response.data.toDomain());
      case ErrorResponce<NearestStoreDto>():
        return ErrorResponce(response.error);
    }
  }
}
