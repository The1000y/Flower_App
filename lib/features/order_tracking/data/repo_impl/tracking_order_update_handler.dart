import 'package:flower_app/core/services/order_update_handler.dart';
import 'package:injectable/injectable.dart';

import '../../domain/repo/tracking_repository.dart';

@LazySingleton(as: OrderUpdateHandler)
class TrackingOrderUpdateHandler implements OrderUpdateHandler {
  TrackingOrderUpdateHandler(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  @override
  Future<void> onOrderUpdated(String orderId) =>
      _trackingRepository.refreshTracking(orderId);
}
