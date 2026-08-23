import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRemoteDataSource)
class RemoteDataSourceImpl implements CommerceRemoteDataSource {
  const RemoteDataSourceImpl();

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