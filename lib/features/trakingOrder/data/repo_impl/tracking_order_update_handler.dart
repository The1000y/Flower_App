import 'package:flower_app/core/services/firebase_update_messaging_service.dart';
import 'package:flower_app/features/trakingOrder/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderUpdateHandler)
class TrackingOrderUpdateHandler implements OrderUpdateHandler {
  TrackingOrderUpdateHandler(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  @override
  Future<void> onOrderUpdated(String orderId) =>
      _trackingRepository.refreshTracking(orderId);
}
