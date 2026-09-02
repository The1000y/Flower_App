// domain/entities/location_entity.dart
class GovernorateEntity {
  final String id;
  final String nameAr;
  final String nameEn;

  GovernorateEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });
}

class CityEntity {
  final String id;
  final String governorateId;
  final String nameAr;
  final String nameEn;

  CityEntity({
    required this.id,
    required this.governorateId,
    required this.nameAr,
    required this.nameEn,
  });
}