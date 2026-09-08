import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/address_local_data_source.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRepo)
class AddressRepoImpl implements AddressRepo {
  AddressLocalDataSource addressLocalDataSource;

  AddressRepoImpl(this.addressLocalDataSource);
  @override
  Future<BaseResponce<AddressEntity>> addAddress({
    required AddAddressRequest addAddressRequest,
  }) async {
    var responce = await addressLocalDataSource.addAddress(
      addAddressRequest: addAddressRequest,
    );
    
    switch (responce) {
      case SuccessResponce<AddressDto>():

        return SuccessResponce(responce.data.toDomain());

      case ErrorResponce<AddressDto>():
        return ErrorResponce(responce.error);
    }
  }
  @override
  Future<BaseResponce<List<AddressEntity>>> getAddresses() async {
    final response = await addressLocalDataSource.getAddresses();
    switch (response) {
      case SuccessResponce<List<AddressDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<AddressDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<bool>> deleteAddress(String id) {
    return addressLocalDataSource.deleteAddress(id);
  }

  @override
  Future<BaseResponce<AddressEntity>> setDefaultAddress(String id) async {
    final response = await addressLocalDataSource.setDefaultAddress(id);
    switch (response) {
      case SuccessResponce<AddressDto>():
        return SuccessResponce(response.data.toDomain());
      case ErrorResponce<AddressDto>():
        return ErrorResponce(response.error);
    }
  }
}
