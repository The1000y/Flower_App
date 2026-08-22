import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';

abstract interface class CommerceLocalDataSource {
   Future<List<HomeSectionDto>?> getCachedSections();

  Future<void> saveSections(
    List<HomeSectionDto> sections,
  );

  Future<DateTime?> getLastCheckedAt();

  Future<void> saveLastCheckedAt(
    DateTime dateTime,
  );
}