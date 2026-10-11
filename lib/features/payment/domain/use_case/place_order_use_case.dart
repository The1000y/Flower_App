import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flower_app/features/payment/domain/repo/place_order_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlaceOrderUseCase {
  PlaceOrderRepo placeOrderRepo;
  PlaceOrderUseCase({required this.placeOrderRepo});

  Future<BaseResponce<PlaceOrderEntity>> call(
    PlaceOrderParam placeOrderParam,
  ) async {
    var result = await placeOrderRepo.palceOrder(
      placeOrderParam: placeOrderParam,
    );
    return result;
  }
}
