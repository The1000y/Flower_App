import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flower_app/features/checkout/domain/repo/checkout_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class EstimationTimeUseCase {

  CheckoutRepo checkoutRepo ;

  EstimationTimeUseCase(this.checkoutRepo);

  Future<BaseResponce<EstimationTimeEntity>> call({required String addressId}) async {
    return await checkoutRepo.getEstimationTime(addressId);
  }
}
