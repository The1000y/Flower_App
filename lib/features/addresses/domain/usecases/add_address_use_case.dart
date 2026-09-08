import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAddressUseCase {

  AddressRepo addressRepo;

  AddAddressUseCase({required this.addressRepo});


  Future<BaseResponce<AddressEntity>> call(AddAddressRequest addAddressRequest) async{
  return await addressRepo.addAddress(addAddressRequest: addAddressRequest);
  }
}


