import 'package:flower_app/features/commerce/data/model/responce/best_seller/item_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';

/// Fixed test data (fixtures) shared across the commerce feature tests.
class CommerceFixtures {
  CommerceFixtures._();

  // ---------------------------------------------------------------------
  // Categories
  // ---------------------------------------------------------------------
  static const List<CategoryEntity> tCategories = [
    CategoryEntity(
      id: 1,
      name: 'Flowers',
      iconUrl: 'https://cdn.flowery-app.com/categories/flowers.png',
    ),
    CategoryEntity(
      id: 2,
      name: 'Gift',
      iconUrl: 'https://cdn.flowery-app.com/categories/gift.png',
    ),
  ];

  static final List<CategoryDto> tCategoryDtos = [
    CategoryDto(
      id: 1,
      name: 'Flowers',
      iconUrl: 'https://cdn.flowery-app.com/categories/flowers.png',
    ),
    CategoryDto(
      id: 2,
      name: 'Gift',
      iconUrl: 'https://cdn.flowery-app.com/categories/gift.png',
    ),
  ];

  // ---------------------------------------------------------------------
  // Best sellers
  // ---------------------------------------------------------------------
  static const List<BestSellerEntity> tBestSellers = [
    BestSellerEntity(
      id: 1,
      name: 'Luxury Red Rose Bouquet',
      imageUrl: 'https://images.unsplash.com/photo-1563241527',
      currency: 'EGP',
      price: 150,
      originalPrice: 200,
      discountPercentage: 25,
      status: 'available',
    ),
  ];

  static final List<ProductDto> tBestSellerDtos = [
    ProductDto(
      id: 1,
      name: 'Luxury Red Rose Bouquet',
      imageUrl: 'https://images.unsplash.com/photo-1563241527',
      currency: 'EGP',
      price: 150,
      originalPrice: 200,
      discountPercentage: 25,
      status: 'available',
    ),
  ];

  // ---------------------------------------------------------------------
  // Home sections (unsorted input + expected sorted & filtered output)
  // ---------------------------------------------------------------------

  /// Input as returned by the data source: unsorted and contains one
  /// inactive section that must be dropped.
  static final List<SectionEntity> tUnsortedSections = [
    const SectionEntity(
      id: 5,
      type: SectionType.category,
      index: 9,
      isActive: false,
      title: 'Should be filtered out',
    ),
    const SectionEntity(
      id: 1,
      type: SectionType.category,
      index: 1,
      isActive: true,
      title: 'Categories',
    ),
    const SectionEntity(
      id: 2,
      type: SectionType.bestSeller,
      index: 0,
      isActive: true,
      title: 'Best seller',
    ),
  ];

  /// Expected output after sorting by index and removing inactive sections.
  static const List<SectionEntity> tActiveSortedSections = [
    SectionEntity(
      id: 2,
      type: SectionType.bestSeller,
      index: 0,
      isActive: true,
      title: 'Best seller',
    ),
    SectionEntity(
      id: 1,
      type: SectionType.category,
      index: 1,
      isActive: true,
      title: 'Categories',
    ),
  ];

  static final List<SectionDto> tSectionDtos = [
    SectionDto(
      id: 2,
      type: 'BestSeller',
      index: 0,
      isActive: true,
      title: 'Best seller',
      occasionId: null,
      categoryId: null,
    ),
    SectionDto(
      id: 1,
      type: 'Categories',
      index: 1,
      isActive: true,
      title: 'Categories',
      occasionId: null,
      categoryId: null,
    ),
  ];

  // ---------------------------------------------------------------------
  // Occasions
  // ---------------------------------------------------------------------
  static final List<OccasionEntity> tOccasions = [
    OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'birthday.png'),
    OccasionEntity(id: 2, name: 'Wedding', imageUrl: 'wedding.png'),
  ];

  static final List<OccasionDto> tOccasionDtos = [
    OccasionDto(id: 1, name: 'Birthday', imageUrl: 'birthday.png'),
    OccasionDto(id: 2, name: 'Wedding', imageUrl: 'wedding.png'),
  ];
}
