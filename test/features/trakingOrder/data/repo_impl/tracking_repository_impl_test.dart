import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/data/model/tracking_dto.dart';
import 'package:flower_app/features/trakingOrder/data/repo_impl/tracking_repository_impl.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../tracking_mocks.dart';

class _TestTrackingRepository extends TrackingRepositoryImpl {
  _TestTrackingRepository(super.remoteDataSource, this.interval);

  final Duration interval;

  @override
  Duration get pollingInterval => interval;
}

TrackingDto _successDto({
  String orderId = 'o-1',
  String status = 'OutForDelivery',
  bool isLive = true,
}) {
  return TrackingDto.fromJson({
    'data': {'orderId': orderId, 'status': status, 'isLive': isLive},
    'isSuccess': true,
  });
}

void main() {
  late MockTrackingRemoteDataSource dataSource;
  late _TestTrackingRepository repository;

  const interval = Duration(milliseconds: 10);

  setUp(() {
    dataSource = MockTrackingRemoteDataSource();
    repository = _TestTrackingRepository(dataSource, interval);
  });

  tearDown(() async {
    await repository.stopTracking('o-1');
    await repository.stopTracking('a');
    await repository.stopTracking('b');
    reset(dataSource);
  });

  test('getTracking maps a successful DTO to a tracking entity', () async {
    when(
      () => dataSource.getOrderTracking('o-1'),
    ).thenAnswer((_) async => SuccessResponce<TrackingDto>(_successDto()));

    final result = await repository.getTracking('o-1');

    expect(result, isA<SuccessResponce<TrackingEntity>>());
    expect((result as SuccessResponce<TrackingEntity>).data.orderId, 'o-1');
  });

  test('getTracking maps a failed response to an error response', () async {
    when(
      () => dataSource.getOrderTracking('o-1'),
    ).thenAnswer((_) async => ErrorResponce<TrackingDto>(Exception('offline')));

    final result = await repository.getTracking('o-1');

    expect(result, isA<ErrorResponce<TrackingEntity>>());
  });

  test(
    'startTracking publishes snapshots and keeps polling while live',
    () async {
      when(
        () => dataSource.getOrderTracking('o-1'),
      ).thenAnswer((_) async => SuccessResponce<TrackingDto>(_successDto()));

      final events = <BaseResponce<TrackingEntity>>[];
      final subscription = repository.startTracking('o-1').listen(events.add);

      await Future<void>.delayed(const Duration(milliseconds: 80));

      expect(events.length, greaterThanOrEqualTo(2));
      expect(events.first, isA<SuccessResponce<TrackingEntity>>());

      await subscription.cancel();
    },
  );

  test('repeated starts for the same order reuse a single session', () async {
    when(
      () => dataSource.getOrderTracking('o-1'),
    ).thenAnswer((_) async => SuccessResponce<TrackingDto>(_successDto()));

    repository = _TestTrackingRepository(
      dataSource,
      const Duration(milliseconds: 200),
    );

    final firstEvents = <BaseResponce<TrackingEntity>>[];
    final secondEvents = <BaseResponce<TrackingEntity>>[];
    final firstSubscription = repository
        .startTracking('o-1')
        .listen(firstEvents.add);
    final secondSubscription = repository
        .startTracking('o-1')
        .listen(secondEvents.add);

    await Future<void>.delayed(const Duration(milliseconds: 40));

    verify(() => dataSource.getOrderTracking('o-1')).called(1);
    expect(firstEvents, isNotEmpty);
    expect(secondEvents, isNotEmpty);

    await firstSubscription.cancel();
    await secondSubscription.cancel();
  });

  test(
    'terminal status emits the final snapshot then closes the stream',
    () async {
      when(() => dataSource.getOrderTracking('o-1')).thenAnswer(
        (_) async => SuccessResponce<TrackingDto>(
          _successDto(status: 'Delivered', isLive: false),
        ),
      );

      final events = <BaseResponce<TrackingEntity>>[];
      final done = Completer<void>();
      repository.startTracking('o-1').listen(events.add, onDone: done.complete);

      await done.future.timeout(const Duration(seconds: 2));

      expect(events.length, 1);
      final snapshot = (events.single as SuccessResponce<TrackingEntity>).data;
      expect(snapshot.isDelivered, isTrue);
      expect(snapshot.isTerminal, isTrue);

      await Future<void>.delayed(const Duration(milliseconds: 40));
      verify(() => dataSource.getOrderTracking('o-1')).called(1);
    },
  );

  test(
    'isLive false stops polling without losing the final snapshot',
    () async {
      when(() => dataSource.getOrderTracking('o-1')).thenAnswer(
        (_) async => SuccessResponce<TrackingDto>(
          _successDto(status: 'Preparing', isLive: false),
        ),
      );

      final events = <BaseResponce<TrackingEntity>>[];
      final done = Completer<void>();
      repository.startTracking('o-1').listen(events.add, onDone: done.complete);

      await done.future.timeout(const Duration(seconds: 2));

      expect(events.length, 1);
      final snapshot = (events.single as SuccessResponce<TrackingEntity>).data;
      expect(snapshot.isLive, isFalse);
      expect(snapshot.status, 'Preparing');
      expect(snapshot.isTerminal, isFalse);
    },
  );

  test('temporary failures keep the session alive and recover', () async {
    var calls = 0;
    when(() => dataSource.getOrderTracking('o-1')).thenAnswer((_) async {
      calls++;
      if (calls == 1) {
        return ErrorResponce<TrackingDto>(Exception('offline'));
      }
      return SuccessResponce<TrackingDto>(_successDto());
    });

    final events = <BaseResponce<TrackingEntity>>[];
    final subscription = repository.startTracking('o-1').listen(events.add);

    await Future<void>.delayed(const Duration(milliseconds: 120));

    expect(events.first, isA<ErrorResponce<TrackingEntity>>());
    expect(events.whereType<SuccessResponce<TrackingEntity>>(), isNotEmpty);

    await subscription.cancel();
  });

  test('does not overlap requests for the same session', () async {
    final gate = Completer<TrackingDto>();
    when(
      () => dataSource.getOrderTracking('o-1'),
    ).thenAnswer((_) async => SuccessResponce<TrackingDto>(await gate.future));

    final subscription = repository.startTracking('o-1').listen((_) {});

    await Future<void>.delayed(const Duration(milliseconds: 40));
    verify(() => dataSource.getOrderTracking('o-1')).called(1);

    gate.complete(_successDto(isLive: false));
    await Future<void>.delayed(const Duration(milliseconds: 20));

    await subscription.cancel();
  });

  test('stopTracking releases the session and stops polling', () async {
    var calls = 0;
    when(() => dataSource.getOrderTracking('o-1')).thenAnswer((_) async {
      calls++;
      return SuccessResponce<TrackingDto>(_successDto());
    });

    final subscription = repository.startTracking('o-1').listen((_) {});

    await Future<void>.delayed(const Duration(milliseconds: 60));
    await repository.stopTracking('o-1');
    final callsAfterStop = calls;

    await Future<void>.delayed(const Duration(milliseconds: 60));
    expect(calls, callsAfterStop);

    await subscription.cancel();
  });

  test('sessions for different orders stay isolated', () async {
    when(() => dataSource.getOrderTracking('a')).thenAnswer(
      (_) async => SuccessResponce<TrackingDto>(_successDto(orderId: 'a')),
    );
    when(() => dataSource.getOrderTracking('b')).thenAnswer(
      (_) async => SuccessResponce<TrackingDto>(_successDto(orderId: 'b')),
    );

    final orderA = <BaseResponce<TrackingEntity>>[];
    final orderB = <BaseResponce<TrackingEntity>>[];
    final subscriptionA = repository.startTracking('a').listen(orderA.add);
    final subscriptionB = repository.startTracking('b').listen(orderB.add);

    await Future<void>.delayed(const Duration(milliseconds: 40));
    await repository.stopTracking('a');
    final orderACount = orderA.length;

    await Future<void>.delayed(const Duration(milliseconds: 40));

    expect(orderA.length, orderACount);
    expect(orderB, isNotEmpty);
    expect((orderB.first as SuccessResponce<TrackingEntity>).data.orderId, 'b');

    await subscriptionA.cancel();
    await subscriptionB.cancel();
  });
}
