import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/api/client/home_api_client.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_item_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: CommerceRemoteDataSource)
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
  Future<BaseResponce<List<OccasionDto>>> getOccasions() async {
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
}
