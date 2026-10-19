import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/order_tracking/data/model/tracking_dto.dart';

abstract interface class TrackingRemoteDataSource {
  Future<BaseResponce<TrackingDto>> getOrderTracking(String orderId);
  Future<BaseResponce<void>> confirmOrderDelivery(String orderId);
}
