import 'dart:convert';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_item_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommerceRemoteDataSource, env: ['dummy'])
class RemoteDataSourceDummyImpl implements CommerceRemoteDataSource {
  static const _basePath = 'assets/dummy';
  static const _networkDelay = Duration(milliseconds: 600);

  @override
  Future<BaseResponce<List<HomeSectionDto>>> getSections() =>
      _loadList('$_basePath/home_sections.json', (json) {
        final list = json['data'] as List<dynamic>? ?? [];

        return list
            .map((item) => HomeSectionDto.fromJson(item as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() =>
      _loadList('$_basePath/categories.json', (json) {
        final list = json['data'] as List<dynamic>? ?? [];

        return list
            .map((item) => CategoryDto.fromJson(item as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions() =>
      _loadList('$_basePath/occasions.json', (json) {
        final list = json['data'] as List<dynamic>? ?? [];

        return list
            .map((item) => OccasionDto.fromJson(item as Map<String, dynamic>))
            .toList();
      });

  @override
  Future<BaseResponce<List<ItemDto>>> getBestSeller() =>
      _loadList('$_basePath/best_sellers.json', _extractItems);

  @override
  Future<BaseResponce<List<ItemDto>>> getSectionProducts({
    int? occasionId,
    int? categoryId,
  }) =>
      _loadList('$_basePath/products.json', _extractItems);

  static List<ItemDto> _extractItems(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final items = data['items'] as List<dynamic>? ?? [];

    return items
        .map((item) => ItemDto.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<BaseResponce<List<T>>> _loadList<T>(
    String path,
    List<T> Function(Map<String, dynamic> json) extract,
  ) async {
    await Future.delayed(_networkDelay);

    try {
      final raw = await rootBundle.loadString(path);
      final decoded = jsonDecode(raw) as Map<String, dynamic>;

      return SuccessResponce(extract(decoded));
    } catch (error) {
      return ErrorResponce(Exception('Failed to load dummy data: $path'));
    }
  }
}
