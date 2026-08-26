import 'package:flower_app/features/commerce/data/data_source/local_data_source/best_seller_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BestSellerLocalDataSource)
class BestSellerLocalDataSourceImpl implements BestSellerLocalDataSource {
  @override
  Future<ProductsResponseDto> getBestSeller({int page = 1}) async {
    return ProductsResponseDto(
      isSuccess: true,
      message: 'Success',
      errorCode: '0',
      data: ProductListDataDto(
        items: List.generate(
          6,
          (index) => ProductDto(
            id: (page - 1) * 6 + index + 1,
            name: 'Red roses - Page $page',
            imageUrl:
                'https://images.unsplash.com/photo-1561181286-d397369328d0?q=80&w=1000&auto=format&fit=crop',
            currency: 'EGP',
            price: 600,
            originalPrice: 800,
            discountPercentage: 20,
            status: 'In stock',
          ),
        ),
        pagination: PaginationDto(
          page: page,
          pageSize: 6,
          totalCount: 30, // Simulate 5 pages
          totalPages: 5,
          hasNextPage: page < 5,
          hasPreviousPage: page > 1,
        ),
      ),
    );
  }
}
