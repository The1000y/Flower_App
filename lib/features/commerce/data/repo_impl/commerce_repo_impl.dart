import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_item_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  static const _defaultUpdateCheckInterval = Duration(hours: 1);

  final CommerceRemoteDataSource remoteDataSource;
  final CommerceLocalDataSource localDataSource;
  final Duration updateCheckInterval;

  CommerceRepoImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    @ignoreParam this.updateCheckInterval = _defaultUpdateCheckInterval,
  });

  @override
  Future<bool> checkSectionsUpdate() async {
    final cached = await localDataSource.getCachedSections();

    if (cached == null) {
      return true;
    }

    final lastCheckedAt = await localDataSource.getLastCheckedAt();

    if (lastCheckedAt != null &&
        DateTime.now().difference(lastCheckedAt) < updateCheckInterval) {
      return false;
    }

    final response = await remoteDataSource.getSections();

    switch (response) {
      case SuccessResponce<List<HomeSectionDto>>():
        await localDataSource.saveLastCheckedAt(DateTime.now());

        return !_areSectionsEqual(cached, response.data);
      case ErrorResponce<List<HomeSectionDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<List<ProductEntity>> getBestSeller() async {
    final response = await remoteDataSource.getBestSeller();

    switch (response) {
      case SuccessResponce<List<ItemDto>>():
        return response.data.map((e) => e.toDomain()).toList();

      case ErrorResponce<List<ItemDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    final response = await remoteDataSource.getCategories();

    switch (response) {
      case SuccessResponce<List<CategoryDto>>():
        return response.data.map((e) => e.toDomain()).toList();

      case ErrorResponce<List<CategoryDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<List<OccasionEntity>> getOccasionsHome() async {
    final response = await remoteDataSource.getOccasionsHome();

    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        return response.data.map((e) => e.toDomain()).toList();

      case ErrorResponce<List<OccasionDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<List<HomeEntity>> getSections() async {
    final cached = await localDataSource.getCachedSections();

    if (cached != null) {
      return _prpareSection(cached.map((e) => e.toDomain()).toList());
    }

    final response = await remoteDataSource.getSections();
    switch (response) {
      case SuccessResponce<List<HomeSectionDto>>():
        await localDataSource.saveSections(response.data);
        await localDataSource.saveLastCheckedAt(DateTime.now());
        return _prpareSection(response.data.map((e) => e.toDomain()).toList());

      case ErrorResponce<List<HomeSectionDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<List<HomeEntity>> refreshSections() async {
    final response = await remoteDataSource.getSections();
    switch (response) {
      case SuccessResponce<List<HomeSectionDto>>():
        await localDataSource.saveSections(response.data);

        await localDataSource.saveLastCheckedAt(DateTime.now());

        return _prpareSection(response.data.map((e) => e.toDomain()).toList());

      case ErrorResponce<List<HomeSectionDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  @override
  Future<List<ProductEntity>> getSectionProducts({
    int? occasionId,
    int? categoryId,
  }) async {
    final response = await remoteDataSource.getSectionProducts(
      occasionId: occasionId,
      categoryId: categoryId,
    );

    switch (response) {
      case SuccessResponce<List<ItemDto>>():
        return response.data.map((e) => e.toDomain()).toList();

      case ErrorResponce<List<ItemDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }

  List<HomeEntity> _prpareSection(List<HomeEntity> section) {
    return section.where((s) => s.isActive).toList()
      ..sort((a, b) => a.index.compareTo(b.index));
  }

  bool _areSectionsEqual(
    List<HomeSectionDto> oldSections,
    List<HomeSectionDto> newSections,
  ) {
    if (oldSections.length != newSections.length) {
      return false;
    }

    for (int i = 0; i < oldSections.length; i++) {
      final oldSection = oldSections[i];
      final newSection = newSections[i];

      if (oldSection.id != newSection.id ||
          oldSection.type != newSection.type ||
          oldSection.index != newSection.index ||
          oldSection.isActive != newSection.isActive ||
          oldSection.title != newSection.title ||
          oldSection.occasionId != newSection.occasionId ||
          oldSection.categoryId != newSection.categoryId) {
        return false;
      }
    }

    return true;
  }
  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasions() async {
    try {
      final response = await remoteDataSource.getOccasions();
      if (response.isSuccess) {
        return SuccessResponce(response.toDomain());
      }
      return ErrorResponce(Exception(response.message));
    } catch (error) {
      return ErrorResponce(error is Exception ? error : Exception(error.toString()));
    }
  }
}
