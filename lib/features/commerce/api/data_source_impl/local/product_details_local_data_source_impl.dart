import 'package:flower_app/features/commerce/data/data_source/local_data_source/product_details_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_include_item_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsLocalDataSource)
class ProductDetailsLocalDataSourceImpl implements ProductDetailsLocalDataSource {
  @override
  Future<ProductDetailsResponseDto> getProductDetails(int productId) async {
    // Dummy local data
    return ProductDetailsResponseDto(
      isSuccess: true,
      message: 'Success',
      errorCode: '0',
      data: ProductDetailsDto(
        id: productId,
        name: '15 Pink Rose Bouquet',
        imageUrl:
            'https://images.unsplash.com/photo-1561181286-d397369328d0?q=80&w=1000&auto=format&fit=crop',
        currency: 'EGP',
        price: 1500,
        status: 'In stock',
        images: [
          'https://images.unsplash.com/photo-1561181286-d397369328d0?q=80&w=1000&auto=format&fit=crop',
          'https://images.unsplash.com/photo-1526047932273-341f2a7631f9?q=80&w=1000&auto=format&fit=crop',
        ],
        description:
            'Lorem ipsum dolor sit amet consectetur. Id sit morbi ornare morbi duis rhoncus orci massa.',
        includes: [
          ProductIncludeItemDto(name: 'Pink roses', quantity: 15),
          ProductIncludeItemDto(name: 'White wrap', quantity: 1),
        ],
        occasionIds: [1, 2],
      ),
    );
  }
}