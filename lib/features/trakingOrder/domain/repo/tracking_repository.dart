import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';

abstract interface class TrackingRepository {
  Future<BaseResponce<TrackingEntity>> getTracking(String orderId);

  Stream<BaseResponce<TrackingEntity>> startTracking(String orderId);

  Future<void> stopTracking(String orderId);

  Future<void> refreshTracking(String orderId);

  /// Closes every active polling session. Intended to be called by the owner
  /// of the repository (e.g. on app teardown) so controllers and timers cannot
  /// outlive the sessions that created them.
  Future<void> dispose();
}
