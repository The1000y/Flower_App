import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetBestSellerUseCase {
 final CommerceRepo commerceRepo;

  GetBestSellerUseCase({required this.commerceRepo});
  Future<BaseResponce<List<BestSellerEntity>>> call() async {
    return await commerceRepo.getBestSeller();
  }
}
