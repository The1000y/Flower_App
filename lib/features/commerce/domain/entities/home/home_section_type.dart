import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';

enum HomeSectionType {
  categories,
  bestSeller,
  occasions,
  productsCarousel,
  unknown,
}

extension HomeSectionTypeX on String {
  HomeSectionType get asHomeSectionType {
    final normalized = toLowerCase().trim();

    return switch (normalized) {
      'categories' => HomeSectionType.categories,
      'bestseller' => HomeSectionType.bestSeller,
      'occasions' => HomeSectionType.occasions,
      'productscarousel' => HomeSectionType.productsCarousel,
      _ => HomeSectionType.unknown,
    };
  }
}

extension HomeSectionX on HomeEntity {
  HomeSectionType get sectionType => type.asHomeSectionType;

  bool isType(HomeSectionType other) => sectionType == other;

  String? get displayTitle {
    final trimmed = title?.trim();

    if (trimmed == null || trimmed.isEmpty) {
      return null;
    }

    return trimmed;
  }
}

extension HomeSectionListX on List<HomeEntity> {
  List<HomeEntity> get activeSorted {
    final filtered = where((section) => section.isActive).toList()
      ..sort((a, b) => a.index.compareTo(b.index));

    return filtered;
  }

  bool get requiresCategories =>
      any((section) => section.isType(HomeSectionType.categories));

  bool get requiresBestSellers =>
      any((section) => section.isType(HomeSectionType.bestSeller));

  bool get requiresOccasions =>
      any((section) => section.isType(HomeSectionType.occasions));

  List<HomeEntity> get productsCarouselSections => where(
        (section) => section.isType(HomeSectionType.productsCarousel),
      ).toList();
}
