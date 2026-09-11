import 'dart:convert';
import 'dart:developer';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/addresses/api/data_source_impl/local/address_dummy_data.dart';
import 'package:flower_app/features/addresses/data/data_source/local_data_source/address_local_data_source.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_dto.dart';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import '../../../data/model/request/update_address_request_dto.dart';

@Injectable(as: AddressLocalDataSource)
class AddressLocalDataSourceImpl implements AddressLocalDataSource {
  final AssetBundle assetBundle;

  AddressLocalDataSourceImpl({required this.assetBundle});

  @override
  Future<BaseResponce<AddressDto>> addAddress({
    required AddAddressRequest addAddressRequest,
  }) async {
    await Future.delayed(const Duration(seconds: 1));
    try {
      // 🎯 التفقد مع .trim()
      final name = addAddressRequest.recipientName.trim();
      final phone = addAddressRequest.recipientPhone.trim();
      final label = addAddressRequest.label.trim();
      final address = addAddressRequest.addressLine.trim();
      final city = addAddressRequest.city.trim();
      final area = addAddressRequest.area.trim();
      final lat = addAddressRequest.lat;
      final lng = addAddressRequest.lng;

      if (name != AddressDummyData.addressDummyData["recipientName"]) {
        return ErrorResponce(Exception("❌ Wrong recipient name: '$name'"));
      }

      if (phone != AddressDummyData.addressDummyData["recipientPhone"]) {
        return ErrorResponce(Exception("❌ Wrong phone: '$phone'"));
      }
      if (label != AddressDummyData.addressDummyData["label"]) {
        return ErrorResponce(Exception("❌ Wrong label: '$label'"));
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
        return ErrorResponce(Exception("❌ Wrong latitude: '$lat'"));
      }
      if (lng != AddressDummyData.addressDummyData["lng"]) {
        return ErrorResponce(Exception("❌ Wrong longitude: '$lng'"));
      }

      // 🎯 Create a copy of the dummy data with a unique ID
      final newAddressMap = Map<String, dynamic>.from(
        AddressDummyData.addressDummyData,
      );
      newAddressMap["id"] = "dummy-id-${DateTime.now().millisecondsSinceEpoch}";
      newAddressMap["isDefault"] = AddressDummyData
          .savedAddressesList
          .isEmpty; // Make default if it's the only one

      // 🎯 Add it to the static list so getAddresses() will see it
      AddressDummyData.savedAddressesList.add(newAddressMap);

      return SuccessResponce<AddressDto>(AddressDto.fromJson(newAddressMap));
    } on Exception catch (e) {
      log('❌ Exception: $e');
      return ErrorResponce<AddressDto>(e);
    }
  }

  @override
  Future<BaseResponce<List<AddressDto>>> getAddresses() async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final dtos = AddressDummyData.savedAddressesList
          .map((json) => AddressDto.fromJson(json))
          .toList();

      return SuccessResponce<List<AddressDto>>(dtos);
    } on Exception catch (e) {
      log('❌ Exception: $e');
      return ErrorResponce<List<AddressDto>>(e);
    }
  }

  @override
  Future<BaseResponce<bool>> deleteAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final list = AddressDummyData.savedAddressesList;
      final index = list.indexWhere((a) => a['id'] == id);

      if (index == -1) {
        return SuccessResponce<bool>(false);
      }

      final wasDefault = list[index]['isDefault'] as bool;
      list.removeAt(index);

      if (wasDefault && list.isNotEmpty) {
        list[0]['isDefault'] = true;
      }

      return SuccessResponce<bool>(true);
    } on Exception catch (e) {
      log('❌ Exception: $e');
      return ErrorResponce<bool>(e);
    }
  }

  @override
  Future<BaseResponce<AddressDto>> setDefaultAddress(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final list = AddressDummyData.savedAddressesList;
      final index = list.indexWhere((a) => a['id'] == id);

      if (index == -1) {
        return ErrorResponce(Exception("❌ Address not found with id: '$id'"));
      }

      for (var i = 0; i < list.length; i++) {
        list[i]['isDefault'] = (list[i]['id'] == id);
      }

      return SuccessResponce<AddressDto>(AddressDto.fromJson(list[index]));
    } on Exception catch (e) {
      log('❌ Exception: $e');
      return ErrorResponce<AddressDto>(e);
    }
  }

  @override
  Future<List<CityEntity>> getCities({required String governorateId}) async {
    var josnAreaData = await assetBundle.loadString('assets/jsons/states.json');
    List<dynamic> data = json.decode(josnAreaData);
    final governoratesData = data.firstWhere((item) {
      return item['type'] == 'table' && item['name'] == 'cities';
    });
    return (governoratesData['data'] as List)
        .where((element) {
          return element['governorate_id'].toString() == governorateId;
        })
        .map((e) {
          return CityEntity(
            id: e['id'],
            nameAr: e['city_name_ar'],
            nameEn: e['city_name_en'],
            governorateId: '${e['governorate_id']}',
          );
        })
        .toList();
  }

  @override
  Future<List<GovernorateEntity>> getGovernorates() async {
    var jsonCityData = await assetBundle.loadString('assets/jsons/cities.json');

    List<dynamic> data = json.decode(jsonCityData);
    final governoratesData = data.firstWhere((item) {
      return item['type'] == 'table' && item['name'] == 'governorates';
    });

    return (governoratesData['data'] as List).map((e) {
      return GovernorateEntity(
        id: e['id'],
        nameAr: e['governorate_name_ar'],
        nameEn: e['governorate_name_en'],
      );
    }).toList();
  }

  @override
  Future<BaseResponce<AddressDto>> updateAddress({
    required String id,
    required UpdateAddressRequestDto request,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      final list = AddressDummyData.savedAddressesList;
      final index = list.indexWhere((a) => a['id'] == id);

      if (index == -1) {
        return ErrorResponce(Exception("❌ Address not found with id: '$id'"));
      }

      final existing = list[index];
      final updated = Map<String, dynamic>.from(existing);

      if (request.recipientName != null)
        updated['recipientName'] = request.recipientName;
      if (request.recipientPhone != null)
        updated['recipientPhone'] = request.recipientPhone;
      if (request.addressLine != null)
        updated['addressLine'] = request.addressLine;
      if (request.city != null) updated['city'] = request.city;
      if (request.area != null) updated['area'] = request.area;
      if (request.lat != null) updated['lat'] = request.lat;
      if (request.lng != null) updated['lng'] = request.lng;
      if (request.label != null) updated['label'] = request.label;

      list[index] = updated;

      return SuccessResponce<AddressDto>(AddressDto.fromJson(updated));
    } on Exception catch (e) {
      log('❌ Exception: $e');
      return ErrorResponce<AddressDto>(e);
    }
  }
}
