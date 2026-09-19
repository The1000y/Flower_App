import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class AddAddressUseCase {
  final AddressRepo addressRepo;

  AddAddressUseCase({required this.addressRepo});

  Future<BaseResponce<AddressEntity>> call(
    AddAddressParams addAddressRequest,
  ) async {
    return await addressRepo.addAddress(addAddressParams: addAddressRequest);
  }
}
