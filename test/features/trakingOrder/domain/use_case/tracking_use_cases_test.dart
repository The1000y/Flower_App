import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/trakingOrder/domain/use_case/stop_tracking_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../tracking_mocks.dart';

void main() {
  late MockTrackingRepository repository;

  setUp(() {
    repository = MockTrackingRepository();
  });

  test(
    'GetTrackingUseCase delegates a single fetch to the repository',
    () async {
      const entity = TrackingEntity(orderId: 'o-1');
      when(
        () => repository.getTracking('o-1'),
      ).thenAnswer((_) async => SuccessResponce<TrackingEntity>(entity));

      final useCase = GetTrackingUseCase(repository);
      final result = await useCase('o-1');

      expect(result, isA<SuccessResponce<TrackingEntity>>());
      verify(() => repository.getTracking('o-1')).called(1);
      verifyNoMoreInteractions(repository);
    },
  );

  test('StartTrackingUseCase exposes the repository owned stream', () async {
    final controller =
        StreamController<BaseResponce<TrackingEntity>>.broadcast();
    when(
      () => repository.startTracking('o-1'),
    ).thenAnswer((_) => controller.stream);

    final useCase = StartTrackingUseCase(repository);
    final stream = useCase('o-1');

    expect(stream, isA<Stream<BaseResponce<TrackingEntity>>>());
    verify(() => repository.startTracking('o-1')).called(1);
    verifyNoMoreInteractions(repository);

    await controller.close();
  });

  test('StopTrackingUseCase stops only the requested session', () async {
    when(() => repository.stopTracking('o-1')).thenAnswer((_) async {});

    final useCase = StopTrackingUseCase(repository);
    await useCase('o-1');

    verify(() => repository.stopTracking('o-1')).called(1);
    verifyNoMoreInteractions(repository);
  });
}
