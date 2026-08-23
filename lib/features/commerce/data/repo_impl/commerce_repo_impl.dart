import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceLocalDataSource localDataSource;
  CommerceRepoImpl({required this.localDataSource});
  
  @override
  Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
    final response = await localDataSource.getCategories();

    switch (response) {
      case SuccessResponce<List<CategoryDto>>():
        return SuccessResponce<List<CategoryEntity>>(
          response.data.map((e) => e.toDomain()).toList(),
        );

      case ErrorResponce<List<CategoryDto>>():
        throw ErrorResponce(Exception(response.errorMessage));
    }
  }
}
