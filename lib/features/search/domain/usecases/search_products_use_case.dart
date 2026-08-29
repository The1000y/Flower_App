import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/search/domain/repo/search_repo.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  final SearchRepo searchRepo;

  SearchProductsUseCase(this.searchRepo);
  Future<BaseResponce<List<ProductEntity>>> call(String query) async {
    return await searchRepo.searchProduct(query);
  }
}
