import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';

abstract interface class PlaceOrderRepo {
  Future<BaseResponce<PlaceOrderEntity>> palceOrder({
    required PlaceOrderParam placeOrderParam,
  });
}
