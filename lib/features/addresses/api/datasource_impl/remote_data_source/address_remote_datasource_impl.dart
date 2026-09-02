import 'package:injectable/injectable.dart';
import '../../../../../config/base/base_responce.dart';
import '../../../data/datasource/address_local_storage.dart';
import '../../../data/datasource/address_remote_datasource.dart';
import '../../../data/model/ response/address_dto.dart';
import '../../../data/model/request/create_address_request_dto.dart';
import '../../../data/model/request/update_address_request_dto.dart';

@Injectable(as: AddressRemoteDataSource)
class RemoteDataSourceImpl implements AddressRemoteDataSource {
  final AddressLocalStorage _storage;
  RemoteDataSourceImpl(this._storage);

  @override
  Future<BaseResponce<List<AddressDto>>> getAddresses() async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final addresses = await _storage.load();
      return SuccessResponce(addresses);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> addAddress(CreateAddressRequestDto request) async {

throw UnimplementedError('Add address logic is now handled by the 100y');
  }

  @override
  Future<BaseResponce<AddressDto>> updateAddress(String id, UpdateAddressRequestDto request) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final addresses = await _storage.load();
      final index = addresses.indexWhere((a) => a.id == id);
      if (index == -1) {
        return ErrorResponce(Exception('Address not found'));
      }

      final current = addresses[index];
      final updated = AddressDto(
        id: current.id,
        recipientName: request.recipientName ?? current.recipientName,
        recipientPhone: request.recipientPhone ?? current.recipientPhone,
        addressLine: request.addressLine ?? current.addressLine,
        city: request.city ?? current.city,
        area: request.area ?? current.area,
        lat: request.lat ?? current.lat,
        lng: request.lng ?? current.lng,
        label: request.label ?? current.label,
        isDefault: current.isDefault,
        storeId: current.storeId,
        isServiceable: current.isServiceable,
      );

      addresses[index] = updated;
      await _storage.save(addresses);
      return SuccessResponce(updated);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<bool>> deleteAddress(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final addresses = await _storage.load();
      final index = addresses.indexWhere((a) => a.id == id);
      if (index == -1) {
        return SuccessResponce(false);
      }

      final wasDefault = addresses[index].isDefault;
      addresses.removeAt(index);


      if (wasDefault && addresses.isNotEmpty) {
        final first = addresses[0];
        addresses[0] = AddressDto(
          id: first.id,
          recipientName: first.recipientName,
          recipientPhone: first.recipientPhone,
          addressLine: first.addressLine,
          city: first.city,
          area: first.area,
          lat: first.lat,
          lng: first.lng,
          label: first.label,
          isDefault: true,
          storeId: first.storeId,
          isServiceable: first.isServiceable,
        );
      }

      await _storage.save(addresses);
      return SuccessResponce(true);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      final addresses = await _storage.load();
      final index = addresses.indexWhere((a) => a.id == id);
      if (index == -1) {
        return ErrorResponce(Exception('Address not found'));
      }

      for (var i = 0; i < addresses.length; i++) {
        final a = addresses[i];
        addresses[i] = AddressDto(
          id: a.id,
          recipientName: a.recipientName,
          recipientPhone: a.recipientPhone,
          addressLine: a.addressLine,
          city: a.city,
          area: a.area,
          lat: a.lat,
          lng: a.lng,
          label: a.label,
          isDefault: a.id == id,
          storeId: a.storeId,
          isServiceable: a.isServiceable,
        );
      }

      await _storage.save(addresses);
      return SuccessResponce(addresses[index]);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }
}