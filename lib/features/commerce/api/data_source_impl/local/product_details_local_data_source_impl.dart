import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/product_details_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_include_item_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: ProductDetailsLocalDataSource)
class ProductDetailsLocalDataSourceImpl implements ProductDetailsLocalDataSource {
  @override
  Future<BaseResponce<ProductDetailsResponseDto>> getProductDetails(int productId) async {
    // Determine details based on productId to avoid static content
    final Map<int, ProductDetailsDto> products = {
      1: ProductDetailsDto(
        id: 1,
        name: "Luxury Red Rose Bouquet",
        imageUrl: "https://images.unsplash.com/photo-1563241527-3004b7be0ffd",
        currency: "SAR",
        price: 150,
        originalPrice: 200,
        discountPercentage: 25,
        status: "In stock",
        images: [
          "https://images.unsplash.com/photo-1563241527-3004b7be0ffd",
          "https://images.unsplash.com/photo-1561181286-d397369328d0",
        ],
        description: "A premium arrangement of 24 deep red roses, symbolizing love and elegance.",
        includes: [
          ProductIncludeItemDto(name: 'Red roses', quantity: 24),
          ProductIncludeItemDto(name: 'Black wrap', quantity: 1),
        ],
        occasionIds: [1, 3],
      ),
      2: ProductDetailsDto(
        id: 2,
        name: "White Lily Arrangement",
        imageUrl: "https://images.unsplash.com/photo-1526047932273-341f2a7631f9",
        currency: "SAR",
        price: 120,
        originalPrice: 150,
        discountPercentage: 20,
        status: "In stock",
        images: [
          "https://images.unsplash.com/photo-1526047932273-341f2a7631f9",
          "https://images.unsplash.com/photo-1519225421980-715cb0215aed",
        ],
        description: "Fresh white lilies paired with green foliage for a clean, sophisticated look.",
        includes: [
          ProductIncludeItemDto(name: 'White lilies', quantity: 6),
          ProductIncludeItemDto(name: 'Glass vase', quantity: 1),
        ],
        occasionIds: [3, 4],
      ),
      // Default / Fallback for other IDs
    };

    final productData = products[productId] ??
        ProductDetailsDto(
          id: productId,
          name: "Bestseller Item $productId",
          imageUrl: "https://images.unsplash.com/photo-1561181286-d397369328d0",
          currency: "SAR",
          price: 100 + productId,
          status: "In stock",
          images: ["https://images.unsplash.com/photo-1561181286-d397369328d0"],
          description: "This is a detailed description for bestseller item number $productId.",
          includes: [
            ProductIncludeItemDto(name: 'Fresh Flowers', quantity: 12),
          ],
          occasionIds: [1],
        );

    final response = ProductDetailsResponseDto(
      isSuccess: true,
      message: 'Success',
      errorCode: '0',
      data: productData,
    );
    return SuccessResponce<ProductDetailsResponseDto>(response);
  }
}