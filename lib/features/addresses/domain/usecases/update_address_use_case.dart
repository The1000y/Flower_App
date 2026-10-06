import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/domain/entities/params/add_address_params.dart';
import 'package:flower_app/features/addresses/domain/repo/address_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class UpdateAddressUseCase {
  final AddressRepo _repo;
  UpdateAddressUseCase(this._repo);

  Future<AddressEntity> execute(String id, AddAddressParams params) {
    return _repo.updateAddress(id: id, params: params);
  }
}