import 'dart:async';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/order_tracking/domain/entities/driver_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/location_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/user_address_entity.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_event.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';
import 'package:flower_app/features/order_tracking/presentation/view/order_map_view.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_delivery_boy_information_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_estimated_arrival_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTrackingRepository implements TrackingRepository {
  final controller = StreamController<BaseResponce<TrackingEntity>>.broadcast();

  @override
  Future<BaseResponce<TrackingEntity>> getTracking(String orderId) async =>
      SuccessResponce<TrackingEntity>(const TrackingEntity());

  @override
  Stream<BaseResponce<TrackingEntity>> startTracking(String orderId) =>
      controller.stream;

  @override
  Future<void> stopTracking(String orderId) async {}

  @override
  Future<void> refreshTracking(String orderId) async {}

  @override
  Future<void> dispose() async {}
}

Future<TrackingViewModel> _pumpMap(
  WidgetTester tester, {
  TrackingEntity? initial,
}) async {
  final repository = _FakeTrackingRepository();
  final viewModel = TrackingViewModel(
    GetTrackingUseCase(repository),
    StartTrackingUseCase(repository),
    StopTrackingUseCase(repository),
  );
  addTearDown(viewModel.close);
  addTearDown(repository.controller.close);

  tester.view.physicalSize = const Size(800, 1400);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: BlocProvider.value(
        value: viewModel,
        child: const MaterialApp(home: OrderMapView()),
      ),
    ),
  );
  await tester.pump();

  if (initial != null) {
    viewModel.handle(StartTrackingEvent('o-1'));
    await tester.pump();
    repository.controller.add(SuccessResponce<TrackingEntity>(initial));
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
  }
  return viewModel;
}

void main() {
  group('OrderMapView', () {
    testWidgets('renders a back button and the info panel with tracking data', (
      tester,
    ) async {
      await _pumpMap(
        tester,
        initial: TrackingEntity(
          orderId: 'o-1',
          status: 'OutForDelivery',
          isLive: true,
          estimatedDeliveryAt: DateTime(2024, 9, 3, 11),
          driver: DriverEntity(name: 'Ali', phone: '01234567890'),
          currentLocation: LocationEntity(lat: 1.0, lng: 2.0),
          userAddress: UserAddressEntity(
            lat: 3.0,
            lng: 4.0,
            addressLine: 'Street',
          ),
        ),
      );

      expect(find.byIcon(Icons.arrow_back_ios), findsOneWidget);
      expect(find.byType(CustomEstimatedArrivalSection), findsOneWidget);
      expect(find.byType(CustomDeliveryBoyInformationCard), findsOneWidget);
      expect(find.text('Ali'), findsOneWidget);
    });

    testWidgets('live updates from the shared cubit re-render the map panel', (
      tester,
    ) async {
      final repository = _FakeTrackingRepository();
      final viewModel = TrackingViewModel(
        GetTrackingUseCase(repository),
        StartTrackingUseCase(repository),
        StopTrackingUseCase(repository),
      );
      addTearDown(viewModel.close);
      addTearDown(repository.controller.close);

      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: BlocProvider.value(
            value: viewModel,
            child: const MaterialApp(home: OrderMapView()),
          ),
        ),
      );
      await tester.pump();

      viewModel.handle(StartTrackingEvent('o-1'));
      await tester.pump();

      repository.controller.add(
        SuccessResponce<TrackingEntity>(
          const TrackingEntity(
            orderId: 'o-1',
            status: 'OutForDelivery',
            isLive: true,
            driver: DriverEntity(name: 'Ali', phone: '01234567890'),
            currentLocation: LocationEntity(lat: 1.0, lng: 2.0),
            userAddress: UserAddressEntity(lat: 3.0, lng: 4.0),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('Ali'), findsOneWidget);

      repository.controller.add(
        SuccessResponce<TrackingEntity>(
          const TrackingEntity(
            orderId: 'o-1',
            status: 'OutForDelivery',
            isLive: true,
            driver: DriverEntity(name: 'Omar', phone: '01234567890'),
            currentLocation: LocationEntity(lat: 1.0, lng: 2.0),
            userAddress: UserAddressEntity(lat: 3.0, lng: 4.0),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('Omar'), findsOneWidget);
      expect(find.text('Ali'), findsNothing);
    });
  });
}