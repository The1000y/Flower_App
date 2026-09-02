import '../../../../config/base/base_responce.dart';
import '../entities/address_entity.dart';

abstract interface class SavedAddressRepo {
  Future<BaseResponce<List<AddressEntity>>> getAddresses();
  Future<BaseResponce<bool>> deleteAddress(String id);
  Future<BaseResponce<AddressEntity>> setDefaultAddress(String id);
}