import 'package:injectable/injectable.dart';
import '../entities/address_entity.dart';
import '../repo/address_repo.dart';

@injectable
class GetAddressesUseCase {
  final AddressRepo _repo;
  GetAddressesUseCase(this._repo);

  Future<List<AddressEntity>> execute() {
    return _repo.getAddresses();
  }
}