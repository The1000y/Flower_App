import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/api/client/address_api_client.dart';
import 'package:flower_app/features/addresses/data/data_source/remote_data_source/address_remote_data_source.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/request/update_address_request_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/area_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/nearest_store_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: AddressRemoteDataSource)
class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final AddressApiClient addressApi;
  AddressRemoteDataSourceImpl(this.addressApi);

  @override
  Future<BaseResponce<List<AreaDto>>> getAreas() async {
    try {
      final response = await addressApi.getAreas();
      if ((response.isSuccess == true || response.isSuccess == null) &&
          response.data != null) {
        return SuccessResponce(response.data!);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Failed to load areas'),
      );
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<NearestStoreDto>> getNearestStore({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await addressApi.getNearestStore(latitude, longitude);
      if ((response.isSuccess == true || response.isSuccess == null) &&
          response.data != null) {
        return SuccessResponce(response.data!);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Failed to find nearest store'),
      );
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<List<AddressDto>>> getAddresses() async {
    try {
      final response = await addressApi.getAddresses();

      if (response.isSuccess) {
        return SuccessResponce(response.data);
      }

      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> getAddressById(String id) async {
    try {
      final response = await addressApi.getAddressById(id);
      if ((response.isSuccess == true || response.isSuccess == null) &&
          response.data != null) {
        return SuccessResponce(response.data!);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Failed to load address'),
      );
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> addAddress({
    required AddAddressRequest addAddressRequest,
  }) async {
    try {
      final response = await addressApi.createAddress(addAddressRequest);
      if ((response.isSuccess == true || response.isSuccess == null) &&
          response.data != null) {
        return SuccessResponce(response.data!);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Failed to add address'),
      );
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id) async {
    try {
      final response = await addressApi.setDefaultAddress(id);
      if ((response.isSuccess == true || response.isSuccess == null) &&
          response.data != null) {
        return SuccessResponce(response.data!);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Failed to set default address'),
      );
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<AddressDto>> updateAddress({
    required String id,
    required UpdateAddressRequestDto request,
  }) async {
    try {
      final response = await addressApi.updateAddress(id, request);
      if ((response.isSuccess == true || response.isSuccess == null) &&
          response.data != null) {
        return SuccessResponce(response.data!);
      }
      return ErrorResponce(
        Exception(response.message ?? 'Failed to update address'),
      );
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<bool>> deleteAddress(String id) async {
    try {
      await addressApi.deleteAddress(id);
      return SuccessResponce(true);
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }
}
