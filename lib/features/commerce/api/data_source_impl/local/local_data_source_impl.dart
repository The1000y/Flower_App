import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceLocalDataSource)
class LocalDataSourceImpl implements CommerceLocalDataSource {
  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    await Future.delayed(const Duration(seconds: 2));

    List<CategoryDto> categoryDummyList = [
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
      CategoryDto(
        id: 3,
        name: 'Card',
        iconUrl: 'https://cdn.flowery-app.com/categories/card.png',
      ),
      CategoryDto(
        id: 4,
        name: 'Jewellery',
        iconUrl: 'https://cdn.flowery-app.com/categories/jewellery.png',
      ),
    ];
    try {
      return SuccessResponce<List<CategoryDto>>(categoryDummyList);
    } on Exception catch (e) {
      return ErrorResponce<List<CategoryDto>>(e);
    }
  }

  @override
  Future<BaseResponce<List<ProductDto>>> getBestSellers() async {
    await Future.delayed(const Duration(seconds: 3));
    List<ProductDto> itemDummyList = [
      ProductDto(
        id: 1,
        name: "Luxury Red Rose Bouquet",
        imageUrl: "https://images.unsplash.com/photo-1563241527-3004b7be0ffd",
        currency: "SAR",
        price: 150,
        originalPrice: 200,
        discountPercentage: 25,
        status: "available",
      ),
      ProductDto(
        id: 2,
        name: "White Lily Arrangement",
        imageUrl:
            "https://images.unsplash.com/photo-1526047932273-341f2a7631f9",
        currency: "SAR",
        price: 120,
        originalPrice: 150,
        discountPercentage: 20,
        status: "available",
      ),
      ProductDto(
        id: 3,
        name: "Pink Flower Bouquet",
        imageUrl:
            "https://www.bunches.co.uk/cdn/shop/files/rose-and-lily-bouquet.jpg",
        currency: "SAR",
        price: 180,
        originalPrice: 220,
        discountPercentage: 18,
        status: "available",
      ),
      ProductDto(
        id: 4,
        name: "Elegant Orchid Vase",
        imageUrl:
            "https://images.unsplash.com/photo-1611080541599-8c6dbde6ed28",
        currency: "SAR",
        price: 250,
        originalPrice: 300,
        discountPercentage: 17,
        status: "available",
      ),
      ProductDto(
        id: 5,
        name: "Mixed Color Flowers",
        imageUrl:
            "https://images.unsplash.com/photo-1490750967868-88aa4486c946",
        currency: "SAR",
        price: 90,
        originalPrice: 120,
        discountPercentage: 25,
        status: "available",
      ),
      ProductDto(
        id: 6,
        name: "Wedding Flower Set",
        imageUrl:
            "https://images.unsplash.com/photo-1507504031003-b417219a0fde",
        currency: "SAR",
        price: 500,
        originalPrice: 650,
        discountPercentage: 23,
        status: "available",
      ),
      ProductDto(
        id: 7,
        name: "Small Tulip Bouquet",
        imageUrl:
            "https://images.unsplash.com/photo-1526047932273-341f2a7631f9",
        currency: "SAR",
        price: 80,
        originalPrice: 100,
        discountPercentage: 20,
        status: "available",
      ),
      ProductDto(
        id: 8,
        name: "Premium Flower Box",
        imageUrl:
            "https://www.sallyhelmy.com/wp-content/uploads/2025/01/botanical.jpg",
        currency: "SAR",
        price: 300,
        originalPrice: 400,
        discountPercentage: 25,
        status: "available",
      ),
      ProductDto(
        id: 9,
        name: "Garden Fresh Flowers",
        imageUrl:
            "https://images.unsplash.com/photo-1469259943454-aa100abba749",
        currency: "SAR",
        price: 110,
        originalPrice: 140,
        discountPercentage: 21,
        status: "available",
      ),
      ProductDto(
        id: 10,
        name: "Golden Rose Collection",
        imageUrl:
            "https://images.unsplash.com/photo-1518709268805-4e9042af9f23",
        currency: "SAR",
        price: 350,
        originalPrice: 450,
        discountPercentage: 22,
        status: "available",
      ),
    ];

    try {
      return SuccessResponce<List<ProductDto>>(itemDummyList);
    } on Exception catch (e) {
      return ErrorResponce<List<ProductDto>>(e);
    }
  }

  @override
  Future<BaseResponce<List<SectionDto>>> getSections() async {
    List<SectionDto> sectionDummyList = [
      SectionDto(
        id: 1,
        type: 'Categories',
        index: 1,
        isActive: true,
        title: 'Categories',
        occasionId: null,
        categoryId: null,
      ),
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
        id: 3,
        type: 'Occasions',
        index: 2,
        isActive: true,
        title: 'Occasion',
        occasionId: null,
        categoryId: null,
      ),
      // SectionDto(
      //   id: 4,
      //   type: 'ProductsCarousel',
      //   index: 3,
      //   isActive: true,
      //   title: 'Wedding picks',
      //   occasionId: 1,
      //   categoryId: null,
      // ),
    ];

    try {
      return SuccessResponce<List<SectionDto>>(sectionDummyList);
    } on Exception catch (e) {
      return ErrorResponce<List<SectionDto>>(e);
    }
  }

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasion() async {
    Future.delayed(const Duration(seconds: 5));
    List<OccasionDto> occasionDummyList = [
      OccasionDto(
        id: 1,
        name: "Birthday",
        imageUrl:
            "https://images.unsplash.com/photo-1530103862676-de8c9debad1d",
      ),
      OccasionDto(
        id: 2,
        name: "Graduation",
        imageUrl:
            "https://images.unsplash.com/photo-1523050854058-8df90110c9f1",
      ),
      OccasionDto(
        id: 3,
        name: "Wedding",
        imageUrl:
            "https://images.unsplash.com/photo-1519741497674-611481863552",
      ),
      OccasionDto(
        id: 4,
        name: "Anniversary",
        imageUrl:
            "https://images.unsplash.com/photo-1519225421980-715cb0215aed",
      ),
    ];

    try {
      return SuccessResponce<List<OccasionDto>>(occasionDummyList);
    } on Exception catch (e) {
      return ErrorResponce<List<OccasionDto>>(e);
    }
  }


}
