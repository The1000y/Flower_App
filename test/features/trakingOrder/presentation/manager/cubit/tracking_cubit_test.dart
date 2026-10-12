import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/presentation/manager/cubit/tracking_cubit.dart';
import 'package:flower_app/features/trakingOrder/presentation/manager/cubit/tracking_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../tracking_mocks.dart';

void main() {
  late MockTrackingRepository repository;
  late TrackingCubit cubit;
  late StreamController<BaseResponce<TrackingEntity>> streamController;
  late bool sessionStopped;

  setUp(() {
    repository = MockTrackingRepository();
    sessionStopped = false;
    streamController = StreamController<BaseResponce<TrackingEntity>>.broadcast(
      onCancel: () => sessionStopped = true,
    );
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

  blocTest<TrackingCubit, TrackingState>(
    'startTracking emits loading then the incoming snapshot in order',
    build: () => cubit,
    act: (cubit) {
      cubit.startTracking('o-1');
      streamController.add(
        SuccessResponce<TrackingEntity>(
          const TrackingEntity(
            orderId: 'o-1',
            status: 'Preparing',
            isLive: true,
          ),
        ),
      );
    },
    expect: () => [
      isA<TrackingState>()
          .having((s) => s.orderId, 'orderId', 'o-1')
          .having((s) => s.trackingState.isLoading, 'isLoading', isTrue)
          .having((s) => s.trackingState.data, 'data', isNull),
      isA<TrackingState>()
          .having((s) => s.orderId, 'orderId', 'o-1')
          .having((s) => s.trackingState.isLoading, 'isLoading', isFalse)
          .having((s) => s.trackingState.data?.orderId, 'data.orderId', 'o-1')
          .having(
            (s) => s.trackingState.data?.status,
            'data.status',
            'Preparing',
          )
          .having((s) => s.trackingState.errorMessage, 'errorMessage', isEmpty),
    ],
  );

  blocTest<TrackingCubit, TrackingState>(
    'an error response keeps the last snapshot and surfaces the message',
    build: () => cubit,
    act: (cubit) {
      cubit.startTracking('o-1');
      streamController.add(
        SuccessResponce<TrackingEntity>(
          const TrackingEntity(orderId: 'o-1', status: 'OutForDelivery'),
        ),
      );
      streamController.add(ErrorResponce<TrackingEntity>(Exception('offline')));
    },
    expect: () => [
      isA<TrackingState>().having(
        (s) => s.trackingState.isLoading,
        'isLoading',
        isTrue,
      ),
      isA<TrackingState>()
          .having(
            (s) => s.trackingState.data?.status,
            'status',
            'OutForDelivery',
          )
          .having((s) => s.trackingState.errorMessage, 'errorMessage', isEmpty),
      isA<TrackingState>()
          .having(
            (s) => s.trackingState.data?.status,
            'status',
            'OutForDelivery',
          )
          .having(
            (s) => s.trackingState.errorMessage,
            'errorMessage',
            isNotEmpty,
          ),
    ],
  );

  blocTest<TrackingCubit, TrackingState>(
    'getTracking emits loading then the fetched snapshot without polling',
    build: () {
      when(() => repository.getTracking('o-9')).thenAnswer(
        (_) async => SuccessResponce<TrackingEntity>(
          const TrackingEntity(orderId: 'o-9'),
        ),
      );
      return cubit;
    },
    act: (cubit) => cubit.getTracking('o-9'),
    expect: () => [
      isA<TrackingState>()
          .having((s) => s.orderId, 'orderId', 'o-9')
          .having((s) => s.trackingState.isLoading, 'isLoading', isTrue),
      isA<TrackingState>()
          .having((s) => s.orderId, 'orderId', 'o-9')
          .having((s) => s.trackingState.isLoading, 'isLoading', isFalse)
          .having((s) => s.trackingState.data?.orderId, 'data.orderId', 'o-9'),
    ],
    verify: (_) {
      verify(() => repository.getTracking('o-9')).called(1);
      verifyNever(() => repository.startTracking('o-9'));
    },
  );

  test('repeated start for the same order keeps one subscription', () {
    cubit.startTracking('o-1');
    cubit.startTracking('o-1');

    verify(() => repository.startTracking('o-1')).called(1);
  });

  test('stopTracking cancels the subscription and stops the session', () async {
    cubit.startTracking('o-1');
    await cubit.stopTracking();

    verify(() => repository.stopTracking('o-1')).called(1);

    streamController.add(ErrorResponce<TrackingEntity>(Exception('late')));
    await Future<void>.delayed(Duration.zero);
    expect(cubit.state.trackingState.errorMessage, isEmpty);
  });

  test(
    'closing the cubit stops the session when it owns the last listener',
    () async {
      cubit.startTracking('o-1');
      await cubit.close();
      await Future<void>.delayed(Duration.zero);

      expect(sessionStopped, isTrue);
      verifyNever(() => repository.stopTracking('o-1'));
    },
  );

  test(
    'closing the cubit keeps the session alive for another listener',
    () async {
      cubit.startTracking('o-1');
      final otherListener = streamController.stream.listen((_) {});
      await cubit.close();
      await Future<void>.delayed(Duration.zero);

      expect(sessionStopped, isFalse);

      await otherListener.cancel();
      await Future<void>.delayed(Duration.zero);
      expect(sessionStopped, isTrue);
    },
  );

  test('switching orders cancels the previous subscription only', () async {
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
