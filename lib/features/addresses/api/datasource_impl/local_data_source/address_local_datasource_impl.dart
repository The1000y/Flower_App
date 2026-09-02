import 'package:injectable/injectable.dart';
import '../../../../../config/base/base_responce.dart';
import '../../../data/datasource/address_local_datasource.dart';
import '../../../data/model/ response/address_dto.dart';
import 'address_dummy_data.dart';

@Injectable(as: SavedAddressLocalDataSource)
class SavedAddressLocalDataSourceImpl implements SavedAddressLocalDataSource {

  @override
  Future<BaseResponce<List<AddressDto>>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final dtos = AddressDummyData.savedAddressesList
          .map((json) => AddressDto.fromJson(json))
          .toList();
      return SuccessResponce(dtos);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<bool>> deleteAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final list = AddressDummyData.savedAddressesList;
      final index = list.indexWhere((a) => a['id'] == id);
      if (index == -1) return SuccessResponce(false);

      final wasDefault = list[index]['isDefault'] as bool;
      list.removeAt(index);
      if (wasDefault && list.isNotEmpty) list[0]['isDefault'] = true;

      return SuccessResponce(true);
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final list = AddressDummyData.savedAddressesList;
      final index = list.indexWhere((a) => a['id'] == id);
      if (index == -1) return ErrorResponce(Exception('Address not found'));

      for (var i = 0; i < list.length; i++) {
        list[i]['isDefault'] = (list[i]['id'] == id);
      }
      return SuccessResponce(AddressDto.fromJson(list[index]));
    } catch (e) {
      return ErrorResponce(Exception(e.toString()));
    }
  }
}