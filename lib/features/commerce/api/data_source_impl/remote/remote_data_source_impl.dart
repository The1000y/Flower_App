import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:injectable/injectable.dart';
import '../../client/commerce_api_client.dart';

@Injectable(as: CommerceRemoteDataSource)
class RemoteDataSourceImpl implements CommerceRemoteDataSource {
  final CommerceApiClient commerceApi;
  RemoteDataSourceImpl(this.commerceApi);

  @override
  Future<BaseResponce<List<SectionDto>>> getSections() async {
    try {
      final response = await commerceApi.getHomeSections();
      if (response.isSuccess == true || response.isSuccess == null) {
        return SuccessResponce(response.data ?? []);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    try {
      final response = await commerceApi.getCategories();
      if (response.isSuccess == true) {
        return SuccessResponce(response.data);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<List<OccasionDto>>> getOccasions({int pageNumber = 1, int pageSize = 10}) async {
    try {
      final response = await commerceApi.getOccasions(pageNumber, pageSize);
      if (response.isSuccess == true || response.isSuccess == null) {
        return SuccessResponce(response.data.items);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<ProductsResponseDto>> getProducts({String? categoryId, String? occasionId, String? keyword, String? sortBy, int page = 1, int pageSize = 10}) async {
    try {
      final response = await commerceApi.getProducts(categoryId, occasionId, keyword, sortBy, page, pageSize);
      if (response.isSuccess == true || response.isSuccess == null) {
        return SuccessResponce(response);
      }
      return ErrorResponce(Exception(response.message));
    } catch (e) {
      return ErrorResponce(e is Exception ? e : Exception(e.toString()));
    }
  }
}

