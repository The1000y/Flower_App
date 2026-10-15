import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flower_app/core/services/firebase_update_messaging_service.dart';
import 'package:flower_app/core/services/order_update_handler.dart';
import 'package:flower_app/core/services/order_update_message.dart';
import 'package:flutter_test/flutter_test.dart';

RemoteMessage _message([Map<String, dynamic>? data]) =>
    RemoteMessage(data: data ?? const <String, dynamic>{});

class _RecordingOrderUpdateHandler implements OrderUpdateHandler {
  final List<String> orderIds = [];
  Object? error;

  @override
  Future<void> onOrderUpdated(String orderId) async {
    final failure = error;
    if (failure != null) throw failure;
    orderIds.add(orderId);
  }
}

void main() {
  group('OrderUpdateMessage.tryParse', () {
    test('parses a non-empty orderId', () {
      final update = OrderUpdateMessage.tryParse(_message({'orderId': 'o-1'}));

      expect(update, isNotNull);
      expect(update!.orderId, 'o-1');
    });

    test('trims surrounding whitespace from the orderId', () {
      final update = OrderUpdateMessage.tryParse(
        _message({'orderId': '  o-2  '}),
      );

      expect(update!.orderId, 'o-2');
    });

    test('ignores other data keys', () {
      final update = OrderUpdateMessage.tryParse(
        _message({'orderId': 'o-3', 'status': 'Delivered'}),
      );

      expect(update!.orderId, 'o-3');
    });

    test('rejects a missing orderId', () {
      expect(OrderUpdateMessage.tryParse(_message({'foo': 'bar'})), isNull);
    });

    test('rejects an empty orderId', () {
      expect(OrderUpdateMessage.tryParse(_message({'orderId': ''})), isNull);
    });

    test('rejects a whitespace-only orderId', () {
      expect(OrderUpdateMessage.tryParse(_message({'orderId': '   '})), isNull);
    });

    test('rejects a non-string orderId', () {
      expect(OrderUpdateMessage.tryParse(_message({'orderId': 42})), isNull);
    });

    test('rejects a message without any data', () {
      expect(OrderUpdateMessage.tryParse(_message()), isNull);
    });
  });

  group('FirebaseUpdateMessagingService', () {
    late _RecordingOrderUpdateHandler handler;
    late FirebaseUpdateMessagingService service;

    setUp(() {
      handler = _RecordingOrderUpdateHandler();
      service = FirebaseUpdateMessagingService(handler);
    });

    test('routes the parsed orderId to the handler', () async {
      await service.handle(const OrderUpdateMessage(orderId: 'o-1'));

      expect(handler.orderIds, ['o-1']);
    });

    test('forwards every update independently', () async {
      await service.handle(const OrderUpdateMessage(orderId: 'o-1'));
      await service.handle(const OrderUpdateMessage(orderId: 'o-2'));

      expect(handler.orderIds, ['o-1', 'o-2']);
    });

    test('swallows handler failures so FCM cannot crash the app', () async {
      handler.error = Exception('offline');

      await expectLater(
        service.handle(const OrderUpdateMessage(orderId: 'o-1')),
        completes,
      );
      expect(handler.orderIds, isEmpty);
    });
  });
}
