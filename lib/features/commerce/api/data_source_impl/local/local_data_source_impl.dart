import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceLocalDataSource)
class LocalDataSourceImpl implements CommerceLocalDataSource {

  @override
  Future<BaseResponce<List<CategoryDto>>> getCategories() async {
    await Future.delayed(const Duration(seconds:2));

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
}
