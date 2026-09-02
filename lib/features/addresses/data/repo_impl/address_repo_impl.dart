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
}
