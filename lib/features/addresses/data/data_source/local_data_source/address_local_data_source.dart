import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';

abstract interface class AddressLocalDataSource {

  Future<BaseResponce<AddressDto>> addAddress({required AddAddressRequest addAddressRequest});
}