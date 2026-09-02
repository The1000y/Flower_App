import 'package:injectable/injectable.dart';
import '../../../../config/base/base_responce.dart';
import '../entities/address_entity.dart';
import '../repo/saved_address_repository.dart';

@injectable
class GetAddressesUseCase {
  final SavedAddressRepo _repo; // Changed here
  GetAddressesUseCase(this._repo);

  Future<BaseResponce<List<AddressEntity>>> execute() {
    return _repo.getAddresses();
  }
}