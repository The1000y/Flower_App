import 'package:injectable/injectable.dart';
import '../../../../config/base/base_responce.dart';
import '../repo/address_repo.dart';

@injectable
class DeleteAddressUseCase {
  final AddressRepo _repo; // Changed here
  DeleteAddressUseCase(this._repo);

  Future<BaseResponce<bool>> execute(String id) {
    return _repo.deleteAddress(id);
  }
}