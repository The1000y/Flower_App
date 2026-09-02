import 'dart:developer';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/api/data_source_impl/local/address_dummy_data.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/address_local_data_source.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:injectable/injectable.dart';


@Injectable(as: AddressLocalDataSource)
class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  @override
  Future<BaseResponce<AddressDto>> addAddress({
    required AddAddressRequest addAddressRequest,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      // 🎯 التفقد مع .trim()
      final name = addAddressRequest.recipientName!.trim();
      final phone = addAddressRequest.recipientPhone!.trim();
      final address = addAddressRequest.addressLine!.trim();
      final city = addAddressRequest.city!.trim();
      final area = addAddressRequest.area!.trim();
      final lat = addAddressRequest.lat;
      final lng = addAddressRequest.lng;

      if (name != AddressDummyData.addressDummyData["recipientName"]) {
        return ErrorResponce(Exception("❌ Wrong recipient name: '$name'"));
      }

      if (phone != AddressDummyData.addressDummyData["recipientPhone"]) {
        return ErrorResponce(Exception("❌ Wrong phone: '$phone'"));
      }

      if (city != AddressDummyData.addressDummyData["city"]) {
        return ErrorResponce(Exception("❌ Wrong city: '$city'"));
      }

      if (area != AddressDummyData.addressDummyData["area"]) {
        return ErrorResponce(Exception("❌ Wrong area: '$area'"));
      }

      if (address != AddressDummyData.addressDummyData["addressLine"]) {
        return ErrorResponce(Exception("❌ Wrong address: '$address'"));
      }
      if (lat != AddressDummyData.addressDummyData["lat"]) {
        return ErrorResponce(Exception("❌ Wrong address: '$address'"));
      }
      if (lng != AddressDummyData.addressDummyData["lng"]) {
        return ErrorResponce(Exception("❌ Wrong address: '$address'"));
      }
      

      return SuccessResponce<AddressDto>(
        AddressDto.fromJson(AddressDummyData.addressDummyData),
      );
    } on Exception catch (e) {
      log('❌ Exception: $e');
      return ErrorResponce<AddressDto>(e);
    }
  }
}
