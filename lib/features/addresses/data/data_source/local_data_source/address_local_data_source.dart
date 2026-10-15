import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/request/update_address_request_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';

abstract interface class AddressLocalDataSource {
  Future<BaseResponce<AddressDto>> addAddress({
    required AddAddressRequest addAddressRequest,
  });
  Future<List<GovernorateEntity>> getGovernorates();
  Future<List<CityEntity>> getCities({required String governorateId});

  Future<BaseResponce<List<AddressDto>>> getAddresses();
  Future<BaseResponce<bool>> deleteAddress(String id);
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id);
  Future<BaseResponce<AddressDto>> updateAddress({
    required String id,
    required UpdateAddressRequestDto request,
  });
}
