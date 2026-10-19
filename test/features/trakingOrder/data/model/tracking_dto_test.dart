import 'package:flower_app/features/order_tracking/data/model/tracking_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TrackingDto', () {
    test('parses the response envelope and maps to a tracking entity', () {
      final dto = TrackingDto.fromJson({
        'data': {
          'orderId': 'o-1',
          'status': 'OutForDelivery',
          'isLive': true,
          'driver': {
            'driverId': 'd-1',
            'name': 'Ali',
            'photoUrl': 'https://cdn.example/driver.png',
            'phone': '+201000000000',
          },
          'currentLocation': {
            'lat': 30.1234567,
            'lng': 31.7654321,
            'recordedAt': '2026-10-10T22:29:23.953Z',
            'isStale': true,
          },
          'userAddress': {
            'lat': 30.1001,
            'lng': 31.2002,
            'addressLine': 'Street 1',
          },
          'estimatedDeliveryAt': '2026-10-10T23:29:23.953Z',
          'awaitingCustomerConfirmation': true,
        },
        'success': true,
        'message': 'ok',
        'messageLocalized': 'تم',
        'statusCode': 'Success',
      });

      expect(dto.isSuccess, isTrue);
      expect(dto.message, 'ok');
      expect(dto.messageLocalized, 'تم');
      expect(dto.statusCode, 'Success');

      final entity = dto.toEntity();
      expect(entity, isNotNull);
      expect(entity!.orderId, 'o-1');
      expect(entity.status, 'OutForDelivery');
      expect(entity.isLive, isTrue);
      expect(entity.driver?.driverId, 'd-1');
      expect(entity.driver?.name, 'Ali');
      expect(entity.driver?.photoUrl, 'https://cdn.example/driver.png');
      expect(entity.driver?.phone, '+201000000000');
      expect(entity.currentLocation?.lat, 30.1234567);
      expect(entity.currentLocation?.lng, 31.7654321);
      expect(entity.currentLocation?.isStale, isTrue);
      expect(entity.isLocationStale, isTrue);
      expect(entity.currentLocation?.recordedAt?.isUtc, isTrue);
      expect(
        entity.currentLocation?.recordedAt,
        DateTime.parse('2026-10-10T22:29:23.953Z'),
      );
      expect(entity.userAddress?.addressLine, 'Street 1');
      expect(entity.userAddress?.lat, 30.1001);
      expect(
        entity.estimatedDeliveryAt,
        DateTime.parse('2026-10-10T23:29:23.953Z'),
      );
      expect(entity.awaitingCustomerConfirmation, isTrue);
      expect(entity.isAwaitingCustomerConfirmation, isTrue);
    });

    test('handles null driver and current location while preparing', () {
      final dto = TrackingDto.fromJson({
        'data': {
          'orderId': 'o-2',
          'status': 'Preparing',
          'isLive': true,
          'driver': null,
          'currentLocation': null,
          'userAddress': {'lat': 1.5, 'lng': 2.5, 'addressLine': 'A'},
          'estimatedDeliveryAt': null,
          'awaitingCustomerConfirmation': null,
        },
        'success': true,
      });

      final entity = dto.toEntity()!;
      expect(entity.driver, isNull);
      expect(entity.hasDriver, isFalse);
      expect(entity.currentLocation, isNull);
      expect(entity.hasCurrentLocation, isFalse);
      expect(entity.isLive, isTrue);
      expect(entity.isTerminal, isFalse);
      expect(entity.awaitingCustomerConfirmation, isNull);
      expect(entity.isAwaitingCustomerConfirmation, isFalse);
    });

    test('returns a null entity when data is missing', () {
      final dto = TrackingDto.fromJson({'success': false, 'data': null});

      expect(dto.toEntity(), isNull);
    });

    test('keeps unknown statuses without treating them as terminal', () {
      final dto = TrackingDto.fromJson({
        'data': {
          'orderId': 'o-3',
          'status': 'SomeFutureStatus',
          'isLive': true,
        },
      });

      final entity = dto.toEntity()!;
      expect(entity.status, 'SomeFutureStatus');
      expect(entity.isDelivered, isFalse);
      expect(entity.isCancelled, isFalse);
      expect(entity.isTerminal, isFalse);
    });

    test('detects terminal statuses case-insensitively', () {
      final delivered = TrackingDto.fromJson({
        'data': {'orderId': 'o-4', 'status': 'delivered', 'isLive': false},
      }).toEntity()!;
      final cancelled = TrackingDto.fromJson({
        'data': {'orderId': 'o-5', 'status': 'CANCELLED', 'isLive': false},
      }).toEntity()!;

      expect(delivered.isDelivered, isTrue);
      expect(delivered.isTerminal, isTrue);
      expect(cancelled.isCancelled, isTrue);
      expect(cancelled.isTerminal, isTrue);
    });

    test('preserves integer coordinates as doubles', () {
      final dto = TrackingDto.fromJson({
        'data': {
          'orderId': 'o-6',
          'status': 'Preparing',
          'isLive': true,
          'currentLocation': {
            'lat': 0,
            'lng': 0,
            'recordedAt': '2026-10-10T22:29:23.953Z',
            'isStale': false,
          },
          'userAddress': {'lat': 0, 'lng': 0, 'addressLine': 'origin'},
        },
      });

      final entity = dto.toEntity()!;
      expect(entity.currentLocation!.lat, 0.0);
      expect(entity.currentLocation!.lat, isA<double>());
      expect(entity.userAddress!.lng, 0.0);
      expect(entity.userAddress!.lng, isA<double>());
    });
  });
}
