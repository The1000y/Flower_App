import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_include_item_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceLocalDataSource)
class LocalDataSourceImpl implements CommerceLocalDataSource {
  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final List<CategoryDto> categoryDummyList = [
      CategoryDto(
        id: 1,
        name: 'Flowers',
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/869/869824.png',
      ),
      CategoryDto(
        id: 2,
        name: 'Gifts',
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/3144/3144456.png',
      ),
      CategoryDto(
        id: 3,
        name: 'Cards',
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/2910/2910791.png',
      ),
      CategoryDto(
        id: 4,
        name: 'Jewellery',
        iconUrl: 'https://cdn-icons-png.flaticon.com/512/1085/1085810.png',
      ),
    ];

    try {
      return SuccessResponce<List<CategoryDto>>(categoryDummyList);
    } on Exception catch (e) {
      return ErrorResponce<List<CategoryDto>>(e);
    }
  }

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final List<OccasionDto> occasions = [
      OccasionDto(
        id: 1,
        name: 'Wedding',
        imageUrl: 'https://images.unsplash.com/photo-1519741497674-611481863552?w=500',
      ),
      OccasionDto(
        id: 2,
        name: 'Birthday',
        imageUrl: 'https://images.unsplash.com/photo-1513151233558-d860c5398176?w=500',
      ),
      OccasionDto(
        id: 3,
        name: 'Graduation',
        imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=500',
      ),
    ];

    try {
      return SuccessResponce<List<OccasionDto>>(occasions);
    } on Exception catch (e) {
      return ErrorResponce<List<OccasionDto>>(e);
    }
  }

  @override
  Future<BaseResponce<List<ProductDto>>> getBestSellers() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final List<ProductDto> bestSellers = [
      ProductDto(
        id: 1,
        name: 'Sunny Bouquet',
        imageUrl: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=500',
        currency: 'EGP',
        price: 600,
        originalPrice: 750,
        discountPercentage: 20,
        status: 'Available',
      ),
      ProductDto(
        id: 2,
        name: 'Red Roses Elegance',
        imageUrl: 'https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?w=500',
        currency: 'EGP',
        price: 850,
        originalPrice: 1000,
        discountPercentage: 15,
        status: 'Available',
      ),
      ProductDto(
        id: 3,
        name: 'White Lilies Box',
        imageUrl: 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=500',
        currency: 'EGP',
        price: 1200,
        originalPrice: null,
        discountPercentage: null,
        status: 'Available',
      ),
    ];

    try {
      return SuccessResponce<List<ProductDto>>(bestSellers);
    } on Exception catch (e) {
      return ErrorResponce<List<ProductDto>>(e);
    }
  }

  @override
  Future<BaseResponce<List<HomeSectionDto>>> getHomeSections() async {
    await Future.delayed(const Duration(milliseconds: 300));

    final List<HomeSectionDto> homeSections = [
      HomeSectionDto(
        id: 1,
        type: 'categories',
        index: 1,
        isActive: true,
        title: 'Categories',
      ),
      HomeSectionDto(
        id: 2,
        type: 'best_seller',
        index: 2,
        isActive: true,
        title: 'Best Seller',
      ),
      HomeSectionDto(
        id: 3,
        type: 'occasions',
        index: 3,
        isActive: true,
        title: 'Occasions',
      ),
    ];

    try {
      return SuccessResponce<List<HomeSectionDto>>(homeSections);
    } on Exception catch (e) {
      return ErrorResponce<List<HomeSectionDto>>(e);
    }
  }

  @override
  Future<BaseResponce<ProductDetailsDto>> getProductDetails(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final details = ProductDetailsDto(
      id: id,
      name: 'Sunny Bouquet Premium',
      imageUrl: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=500',
      currency: 'EGP',
      price: 600,
      originalPrice: 750,
      discountPercentage: 20,
      status: 'Available',
      images: [
        'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=500',
        'https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?w=500',
      ],
      description: 'A beautiful bouquet of fresh yellow sunflowers mixed with white baby roses and green foliage.',
      includes: [
        ProductIncludeItemDto(name: 'Sunflowers', quantity: 10),
        ProductIncludeItemDto(name: 'White Baby Roses', quantity: 5),
        ProductIncludeItemDto(name: 'Wrapping Paper', quantity: 1),
      ],
      categoryId: 1,
      occasionIds: [1, 2],
    );

    try {
      return SuccessResponce<ProductDetailsDto>(details);
    } on Exception catch (e) {
      return ErrorResponce<ProductDetailsDto>(e);
    }
  }

  @override
  Future<BaseResponce<List<ProductDto>>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final allProducts = [
      ProductDto(
        id: 1,
        name: 'Sunny Bouquet',
        imageUrl: 'https://images.unsplash.com/photo-1561181286-d3fee7d55364?w=500',
        currency: 'EGP',
        price: 600,
        originalPrice: 750,
        discountPercentage: 20,
        status: 'Available',
      ),
      ProductDto(
        id: 2,
        name: 'Red Roses Elegance',
        imageUrl: 'https://images.unsplash.com/photo-1582794543139-8ac9cb0f7b11?w=500',
        currency: 'EGP',
        price: 850,
        originalPrice: 1000,
        discountPercentage: 15,
        status: 'Available',
      ),
      ProductDto(
        id: 3,
        name: 'White Lilies Box',
        imageUrl: 'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?w=500',
        currency: 'EGP',
        price: 1200,
        originalPrice: null,
        discountPercentage: null,
        status: 'Available',
      ),
    ];

    try {
      final filtered = allProducts
          .where((p) => p.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
      return SuccessResponce<List<ProductDto>>(filtered);
    } on Exception catch (e) {
      return ErrorResponce<List<ProductDto>>(e);
    }
  }
}