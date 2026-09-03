import 'package:injectable/injectable.dart';
import '../../../../config/base/base_responce.dart';
import '../entities/address_entity.dart';
import '../repo/saved_address_repository.dart';

@injectable
class SetDefaultAddressUseCase {
  final SavedAddressRepo _repo;
  SetDefaultAddressUseCase(this._repo);

  Future<BaseResponce<AddressEntity>> execute(String id) {
    return _repo.setDefaultAddress(id);
  }
}