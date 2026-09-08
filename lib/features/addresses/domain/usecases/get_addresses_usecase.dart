import 'package:injectable/injectable.dart';
import '../../../../config/base/base_responce.dart';
import '../entities/address_entity.dart';
import '../repo/address_repo.dart';

@injectable
class GetAddressesUseCase {
  final AddressRepo _repo;
  GetAddressesUseCase(this._repo);

  Future<BaseResponce<List<AddressEntity>>> execute() {
    return _repo.getAddresses();
  }
}