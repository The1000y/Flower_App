import 'package:firebase_messaging/firebase_messaging.dart';

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
