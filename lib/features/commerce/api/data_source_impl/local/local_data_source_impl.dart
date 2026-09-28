import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_dto.dart' as best_seller;
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceLocalDataSource)
class LocalDataSourceImpl implements CommerceLocalDataSource {
  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProducts() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<List<best_seller.ProductDto>>> getBestSellers() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<List<SectionDto>>> getSections() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions() async {
    return ErrorResponce(Exception('Not implemented locally'));
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProductsForOccasion(String occasionId, {int page = 1}) async {
    return ErrorResponce(Exception('Not implemented locally'));
  }
}
