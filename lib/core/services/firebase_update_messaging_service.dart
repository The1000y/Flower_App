import 'package:flower_app/core/services/order_update_handler.dart';
import 'package:flower_app/core/services/order_update_message.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FirebaseUpdateMessagingService {
  FirebaseUpdateMessagingService(this._updateHandler);

  final OrderUpdateHandler _updateHandler;

  Future<void> handle(OrderUpdateMessage update) async {
    try {
      await _updateHandler.onOrderUpdated(update.orderId);
    } catch (e) {
      debugPrint('Failed to handle order update message: $e');
    }
  }
}
