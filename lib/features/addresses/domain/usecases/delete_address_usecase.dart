import 'package:injectable/injectable.dart';
import '../../../../config/base/base_responce.dart';
import '../repo/saved_address_repository.dart';

@injectable
class DeleteAddressUseCase {
  final SavedAddressRepo _repo; // Changed here
  DeleteAddressUseCase(this._repo);

  Future<BaseResponce<bool>> execute(String id) {
    return _repo.deleteAddress(id);
  }
}