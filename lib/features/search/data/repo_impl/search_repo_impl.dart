import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/search/domain/repo/search_repo.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: SearchRepo)
class SearchRepoImpl implements SearchRepo {
  SearchRepoImpl(this.repository);
  final CommerceRepo repository;
  
  @override
  Future<BaseResponce<List<ProductEntity>>> searchProduct(String query) async {
    final response = await repository.getProducts();
    switch (response) {
      case SuccessResponce<List<ProductEntity>>():
        return SuccessResponce(
          response.data.where((product) {
            return product.name.toLowerCase().contains(query.toLowerCase());
          }).toList(),
        );
      case ErrorResponce<List<ProductEntity>>():
        return ErrorResponce(Exception(response.errorMessage));
    }
  }
}
