import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/repo/checkout_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetCheckoutUseCase {
  final CheckoutRepo checkoutRepo;

  GetCheckoutUseCase({required this.checkoutRepo});

  Future<BaseResponce<CheckoutDetailsEntity>> call() async {
    var result = await checkoutRepo.getCheckoutDetails();
    return result;
  } 
}
