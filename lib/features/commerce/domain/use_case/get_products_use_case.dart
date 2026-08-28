import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

import '../entities/products/pagination_entity.dart';

@injectable
class GetProductsUseCase {
  final CommerceRepo _commerceRepo;
  GetProductsUseCase(this._commerceRepo);

  Future<BaseResponce<PaginatedProducts>> execute(int occasionId, {int page = 1}) {
    return _commerceRepo.getOccasionsProducts(occasionId, page: page);
  }
}