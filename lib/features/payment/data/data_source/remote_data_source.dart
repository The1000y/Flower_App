import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';

abstract interface class RemoteDataSource {
  Future<BaseResponce<PlaceOrderDto>> palceOrder({required PlaceOrderRequest placeOrderRequest});
}