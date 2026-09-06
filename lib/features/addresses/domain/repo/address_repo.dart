import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';

abstract interface class AddressRepo {
  Future<BaseResponce<AddressEntity>> addAddress({
    required AddAddressRequest addAddressRequest,
  });
}
