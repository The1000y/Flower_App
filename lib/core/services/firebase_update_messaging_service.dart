import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

class OrderUpdateMessage {
  const OrderUpdateMessage({required this.orderId});

  final String orderId;

  static OrderUpdateMessage? tryParse(RemoteMessage message) {
    final orderId = message.data['orderId'];
    if (orderId is! String) return null;
    final normalized = orderId.trim();
    if (normalized.isEmpty) return null;
    return OrderUpdateMessage(orderId: normalized);
  }
}

abstract interface class OrderUpdateHandler {
  Future<void> onOrderUpdated(String orderId);
}

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
