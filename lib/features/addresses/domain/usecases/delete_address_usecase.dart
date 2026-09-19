import 'package:injectable/injectable.dart';
import '../repo/address_repo.dart';

@injectable
class DeleteAddressUseCase {
  final AddressRepo _repo;
  DeleteAddressUseCase(this._repo);

  Future<bool> execute(String id) {
    return _repo.deleteAddress(id);
  }
}
