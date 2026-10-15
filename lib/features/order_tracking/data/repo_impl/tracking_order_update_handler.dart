import 'package:flower_app/core/services/order_update_handler.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: OrderUpdateHandler)
class TrackingOrderUpdateHandler implements OrderUpdateHandler {
  TrackingOrderUpdateHandler(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  @override
  Future<void> onOrderUpdated(String orderId) =>
      _trackingRepository.refreshTracking(orderId);
}
