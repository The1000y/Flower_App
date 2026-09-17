import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/request/update_address_request_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/area_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/nearest_store_dto.dart';

abstract interface class AddressRemoteDataSource {
  Future<BaseResponce<List<AreaDto>>> getAreas();
  Future<BaseResponce<NearestStoreDto>> getNearestStore({
    required double latitude,
    required double longitude,
  });
  Future<BaseResponce<List<AddressDto>>> getAddresses();
  Future<BaseResponce<AddressDto>> getAddressById(String id);
  Future<BaseResponce<AddressDto>> addAddress({
    required AddAddressRequest addAddressRequest,
  });
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id);
  Future<BaseResponce<AddressDto>> updateAddress({
    required String id,
    required UpdateAddressRequestDto request,
  });
  Future<BaseResponce<bool>> deleteAddress(String id);
}