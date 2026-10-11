import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';

abstract interface class TrackingRepository {
  Future<BaseResponce<TrackingEntity>> getTracking(String orderId);

  Stream<BaseResponce<TrackingEntity>> startTracking(String orderId);

  Future<void> stopTracking(String orderId);
}
