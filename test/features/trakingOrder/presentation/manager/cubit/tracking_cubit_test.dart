import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/presentation/manager/cubit/tracking_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../tracking_mocks.dart';

void main() {
  late MockTrackingRepository repository;
  late TrackingCubit cubit;
  late StreamController<BaseResponce<TrackingEntity>> streamController;

  setUp(() {
    repository = MockTrackingRepository();
    streamController =
        StreamController<BaseResponce<TrackingEntity>>.broadcast();
    when(
      () => repository.startTracking('o-1'),
    ).thenAnswer((_) => streamController.stream);
    when(() => repository.stopTracking('o-1')).thenAnswer((_) async {});
    cubit = TrackingCubit(
      GetTrackingUseCase(repository),
      StartTrackingUseCase(repository),
      StopTrackingUseCase(repository),
    );
  });

  tearDown(() async {
    if (!cubit.isClosed) {
      await cubit.close();
    }
    if (!streamController.isClosed) {
      await streamController.close();
    }
  });

  test('startTracking publishes incoming snapshots', () async {
    cubit.startTracking('o-1');
    streamController.add(
      SuccessResponce<TrackingEntity>(
        const TrackingEntity(orderId: 'o-1', status: 'Preparing', isLive: true),
      ),
    );
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.orderId, 'o-1');
    expect(cubit.state.trackingState.data?.orderId, 'o-1');
    expect(cubit.state.trackingState.errorMessage, isEmpty);
  });

  test('a temporary error preserves the last valid snapshot', () async {
    cubit.startTracking('o-1');
    streamController.add(
      SuccessResponce<TrackingEntity>(
        const TrackingEntity(orderId: 'o-1', status: 'OutForDelivery'),
      ),
    );
    await Future<void>.delayed(Duration.zero);
    streamController.add(ErrorResponce<TrackingEntity>(Exception('offline')));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.trackingState.data?.status, 'OutForDelivery');
    expect(cubit.state.trackingState.errorMessage, isNotEmpty);
  });

  test('repeated start for the same order keeps one subscription', () {
    cubit.startTracking('o-1');
    cubit.startTracking('o-1');

    verify(() => repository.startTracking('o-1')).called(1);
  });

  test('getTracking performs a single fetch without polling', () async {
    when(() => repository.getTracking('o-9')).thenAnswer(
      (_) async =>
          SuccessResponce<TrackingEntity>(const TrackingEntity(orderId: 'o-9')),
    );

    await cubit.getTracking('o-9');

    expect(cubit.state.orderId, 'o-9');
    expect(cubit.state.trackingState.data?.orderId, 'o-9');
    verify(() => repository.getTracking('o-9')).called(1);
    verifyNever(() => repository.startTracking('o-9'));
  });

  test('stopTracking cancels the subscription and stops the session', () async {
    cubit.startTracking('o-1');
    await cubit.stopTracking();

    verify(() => repository.stopTracking('o-1')).called(1);

    streamController.add(ErrorResponce<TrackingEntity>(Exception('late')));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.trackingState.errorMessage, isEmpty);
  });

  test('closing the cubit does not stop the shared session', () async {
    cubit.startTracking('o-1');
    await cubit.close();

    verifyNever(() => repository.stopTracking('o-1'));
  });

  test('switching orders cancels the old subscription only', () async {
    final secondController =
        StreamController<BaseResponce<TrackingEntity>>.broadcast();
    when(
      () => repository.startTracking('o-2'),
    ).thenAnswer((_) => secondController.stream);

    cubit.startTracking('o-1');
    cubit.startTracking('o-2');
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.orderId, 'o-2');
    verify(() => repository.startTracking('o-2')).called(1);
    verifyNever(() => repository.stopTracking('o-1'));

    await secondController.close();
  });
}
