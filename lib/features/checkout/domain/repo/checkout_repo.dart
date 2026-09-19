import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';

abstract interface class CheckoutRepo {
  Future<BaseResponce<CheckoutDetailsEntity>> getCheckoutDetails();
}
