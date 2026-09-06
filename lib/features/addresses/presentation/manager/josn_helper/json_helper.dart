import 'dart:convert';
import 'package:flower_app/features/addresses/domain/entities/location_entity.dart';
import 'package:flutter/services.dart';

class JsonHelper {
  static Future<List<GovernorateEntity>> getCity() async {
    var jsonCityData = await rootBundle.loadString('assets/jsons/cities.json');

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

  static Future<List<CityEntity>> getArea() async {
    var josnAreaData = await rootBundle.loadString('assets/jsons/states.json');
    List<dynamic> data = json.decode(josnAreaData);
    final governoratesData = data.firstWhere((item) {
      return item['type'] == 'table' && item['name'] == 'cities';
    });
    return (governoratesData['data'] as List).map((e) {
      return CityEntity(
        id: e['id'],
        nameAr: e['city_name_ar'],
        nameEn: e['city_name_en'],
        governorateId: '${e['governorate_id']}',
      );
    }).toList();
  }
}
