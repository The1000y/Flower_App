import '../../../../../config/base/base_responce.dart';
import '../model/ response/address_dto.dart';
import '../model/request/create_address_request_dto.dart';
import '../model/request/update_address_request_dto.dart';

abstract interface class AddressRemoteDataSource {
  Future<BaseResponce<List<AddressDto>>> getAddresses();
  Future<BaseResponce<AddressDto>> addAddress(CreateAddressRequestDto request);
  Future<BaseResponce<AddressDto>> updateAddress(String id, UpdateAddressRequestDto request);
  Future<BaseResponce<bool>> deleteAddress(String id);
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id);
}