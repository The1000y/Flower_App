import 'dart:convert';

import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommerceLocalDataSource)
class LocalDataSourceImpl implements CommerceLocalDataSource {
  final FlutterSecureStorage secureStorage;

  LocalDataSourceImpl(this.secureStorage);

  @override
  Future<List<HomeSectionDto>?> getCachedSections() async {
    final jsonString = await secureStorage.read(key: AppStrings.sectionsKey);

    if (jsonString == null) {
      return null;
    }

    final List<dynamic> jsonList = jsonDecode(jsonString);

    return jsonList
        .map((json) => HomeSectionDto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DateTime?> getLastCheckedAt() async {
    final value = await secureStorage.read(key: AppStrings.lastCheckedKey);

    if (value == null) {
      return null;
    }

    return DateTime.tryParse(value);
  }

  @override
  Future<void> saveLastCheckedAt(DateTime dateTime) async {
    await secureStorage.write(
      key: AppStrings.lastCheckedKey,
      value: dateTime.toIso8601String(),
    );
  }

  @override
  Future<void> saveSections(List<HomeSectionDto> sections) async {
    final jsonString = jsonEncode(sections.map((e) => e.toJson()).toList());

    await secureStorage.write(key: AppStrings.sectionsKey, value: jsonString);
  }
}
