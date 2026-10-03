import 'package:injectable/injectable.dart';
import '../entities/address_entity.dart';
import '../repo/address_repo.dart';

@injectable
class SetDefaultAddressUseCase {
  final AddressRepo _repo;
  SetDefaultAddressUseCase(this._repo);

  Future<AddressEntity> execute(String id) {
    return _repo.setDefaultAddress(id);
  }
}
