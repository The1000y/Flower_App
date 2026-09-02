import '../../../../config/base/base_responce.dart';
import '../model/ response/address_dto.dart';

abstract interface class SavedAddressLocalDataSource {
  Future<BaseResponce<List<AddressDto>>> getAddresses();
  Future<BaseResponce<bool>> deleteAddress(String id);
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id);
}