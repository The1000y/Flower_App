// features/addresses/data/repo_impl/saved_address_repo_impl.dart
import 'package:injectable/injectable.dart';
import '../../../../config/base/base_responce.dart';
import '../../domain/entities/address_entity.dart';
import '../../domain/repo/saved_address_repository.dart';
import '../datasource/address_local_datasource.dart';
import '../model/ response/address_dto.dart';

@Injectable(as: SavedAddressRepo)
class SavedAddressRepoImpl implements SavedAddressRepo {
  final SavedAddressLocalDataSource _dataSource;

  SavedAddressRepoImpl(this._dataSource);

  @override
  Future<BaseResponce<List<AddressEntity>>> getAddresses() async {
    final response = await _dataSource.getAddresses();
    switch (response) {
      case SuccessResponce<List<AddressDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<AddressDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<bool>> deleteAddress(String id) {
    return _dataSource.deleteAddress(id);
  }

  @override
  Future<BaseResponce<AddressEntity>> setDefaultAddress(String id) async {
    final response = await _dataSource.setDefaultAddress(id);
    switch (response) {
      case SuccessResponce<AddressDto>():
        return SuccessResponce(response.data.toDomain());
      case ErrorResponce<AddressDto>():
        return ErrorResponce(response.error);
    }
  }
}