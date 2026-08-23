import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/api/client/home_api_client.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_item_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';

import 'package:injectable/injectable.dart';

@LazySingleton(as: CommerceRemoteDataSource, env: [Environment.prod])
class RemoteDataSourceImpl implements CommerceRemoteDataSource {
  final HomeApi homeApi;
  // final dummmyData dummy;
  RemoteDataSourceImpl(this.homeApi);

  @override
  Future<BaseResponce<List<ItemDto>>> getBestSeller() async {
    final response = await homeApi.getBestSeller();
    try {
      if (response.isSuccess==true&&response.data!=null) {
        return SuccessResponce(response.data!.items??[]);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(Exception(response.message));
    }
  }

  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    final response = await homeApi.getCategories();
    try {
      return SuccessResponce(response.data);
    } catch (e) {
      return ErrorResponce(Exception(response.message));
    }
  }

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasionsHome() async {
    final response = await homeApi.getOccasions();
    try {
      return SuccessResponce(response.data);
    } catch (e) {
      return ErrorResponce(Exception(response.message));
    }
  }

  @override
  Future<BaseResponce<List<HomeSectionDto>>> getSections() async {
    final response = await homeApi.getSections();
    try {
      return SuccessResponce(response.dataSection ?? []);
    } catch (e) {
      return ErrorResponce(Exception(response.message));
    }
  }

  @override
  Future<BaseResponce<List<ItemDto>>> getSectionProducts({
    int? occasionId,
    int? categoryId,
  }) async {
    final response = await homeApi.getProducts(
      occasionId: occasionId,
      categoryId: categoryId,
    );
    try {
      if (response.isSuccess == true && response.data != null) {
        return SuccessResponce(response.data!.items ?? []);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(Exception(response.message));
    }
  }


  @override
  Future<OccasionsResponseDto> getOccasions() async {
    await Future.delayed(const Duration(seconds: 1));
    return OccasionsResponseDto(
      data: [
        OccasionDto(id: 1, name: 'Wedding', imageUrl: 'https://cdn.flowery-app.com/occasions/wedding.jpg'),
        OccasionDto(id: 2, name: 'Graduation', imageUrl: 'https://cdn.flowery-app.com/occasions/graduation.jpg'),
        OccasionDto(id: 3, name: 'Birthday', imageUrl: 'https://cdn.flowery-app.com/occasions/birthday.jpg'),
      ],
      isSuccess: true,
      message: '',
      errorCode: 'None',
    );
  }

  @override
  Future<ProductsResponseDto> getProducts(int occasionId) async {
    await Future.delayed(const Duration(seconds: 1));

    final allProducts = [
      ProductDto(id: 101, name: 'Red roses', imageUrl: 'https://cdn.flowery-app.com/products/101.jpg', currency: 'EGP', price: 600, originalPrice: 800, discountPercentage: 20, status: 'InStock'),
      ProductDto(id: 102, name: 'Red roses', imageUrl: 'https://cdn.flowery-app.com/products/102.jpg', currency: 'EGP', price: 600, originalPrice: 800, discountPercentage: 20, status: 'InStock'),
    ];

    return ProductsResponseDto(
      data: ProductListDataDto(
        items: allProducts,
        pagination: PaginationDto(
          page: 1,
          pageSize: 10,
          totalCount: allProducts.length,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      ),
      isSuccess: true,
      message: '',
      errorCode: 'None',
    );
  }
}
