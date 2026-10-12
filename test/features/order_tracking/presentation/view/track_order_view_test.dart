import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/animations/animated_car_single_file.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/order_tracking/domain/entities/driver_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/location_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/user_address_entity.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';
import 'package:flower_app/features/order_tracking/presentation/view/order_map_view.dart';
import 'package:flower_app/features/order_tracking/presentation/view/track_order_view.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_delivery_boy_information_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_estimated_arrival_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_tracking_buttons_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/order_tracking_test_helpers.dart';

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

class _Harness {
  _Harness({this.onGenerateRoute}) {
    _repository = _FakeTrackingRepository();
    viewModel = TrackingViewModel(
      GetTrackingUseCase(_repository),
      StartTrackingUseCase(_repository),
      StopTrackingUseCase(_repository),
    );
  }

  late final _FakeTrackingRepository _repository;
  late TrackingViewModel viewModel;
  RouteFactory? onGenerateRoute;

  void addTracking(TrackingEntity entity) {
    _repository.controller.add(SuccessResponce<TrackingEntity>(entity));
  }

  void addError(String message) {
    _repository.controller.add(
      ErrorResponce<TrackingEntity>(
        DioException(
          requestOptions: RequestOptions(path: '/'),
          response: Response<dynamic>(
            requestOptions: RequestOptions(path: '/'),
            statusCode: 400,
            data: {'message': message},
          ),
        ),
      ),
    );
  }

  Future<void> pump(
    WidgetTester tester, {
    Size surfaceSize = const Size(800, 1400),
  }) async {
    tester.view.physicalSize = surfaceSize;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(viewModel.close);
    addTearDown(_repository.controller.close);

    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        child: BlocProvider.value(
          value: viewModel,
          child: MaterialApp(
            home: const TrackOrderView(orderId: 'o-1'),
            onGenerateRoute: onGenerateRoute ??
                (settings) => MaterialPageRoute<void>(
                  settings: settings,
                  builder: (_) => Scaffold(
                    body: Center(
                      child: Text(routeStubText(settings.name ?? '')),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
    await tester.pump();
  }
}

const _entity = TrackingEntity(
  orderId: 'o-1',
  status: 'OutForDelivery',
  isLive: true,
);

void main() {
  group('TrackOrderView - loading', () {
    testWidgets('shows a loader while no snapshot has arrived', (tester) async {
      final harness = _Harness();
      await harness.pump(tester);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('TrackOrderView - content', () {
    testWidgets('shows the "Track order" title in the app bar', (tester) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addTracking(_entity);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(AppStrings.trackOrder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('renders the sections from the tracking snapshot', (
      tester,
    ) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addTracking(_entity);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(AnimatedCar), findsOneWidget);
      expect(find.byType(OrderStatusSection), findsOneWidget);
      expect(find.byType(CustomTrackingButtonsSection), findsOneWidget);
      expect(find.byType(CustomEstimatedArrivalSection), findsNothing);
      expect(find.byType(CustomDeliveryBoyInformationCard), findsNothing);
    });

    testWidgets('renders driver and arrival data from the tracking snapshot', (
      tester,
    ) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addTracking(
        TrackingEntity(
          orderId: 'o-1',
          status: 'Delivered',
          isLive: false,
          estimatedDeliveryAt: DateTime(2024, 9, 3, 11),
          driver: DriverEntity(
            driverId: 'd-1',
            name: 'Ali',
            phone: '01234567890',
            photoUrl: 'https://example.com/ali.jpg',
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CustomEstimatedArrivalSection), findsOneWidget);
      expect(find.byType(CustomDeliveryBoyInformationCard), findsOneWidget);
      expect(find.text('Ali'), findsOneWidget);
      expect(
        tester
            .widget<CustomContractCard>(find.byType(CustomContractCard))
            .phoneNumber,
        '01234567890',
      );
    });

    testWidgets('replaces the snapshot data when the stream emits again', (
      tester,
    ) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addTracking(
        TrackingEntity(
          orderId: 'o-1',
          status: 'Preparing',
          isLive: true,
          estimatedDeliveryAt: DateTime(2024, 9, 3, 11),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(CustomEstimatedArrivalSection), findsOneWidget);

      harness.addTracking(
        TrackingEntity(
          orderId: 'o-1',
          status: 'Preparing',
          isLive: true,
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.byType(CustomEstimatedArrivalSection), findsNothing);
    });
  });

  group('TrackOrderView - buttons', () {
    testWidgets('only "Show map" is available while not delivered', (
      tester,
    ) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addTracking(_entity);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.widgetWithText(CustomButton, AppStrings.showMap),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CustomButton, AppStrings.orderDeliveredAction),
        findsNothing,
      );
    });

    testWidgets('shows the delivered action when the order is delivered', (
      tester,
    ) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addTracking(
        const TrackingEntity(orderId: 'o-1', status: 'delivered'),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(
        find.widgetWithText(CustomButton, AppStrings.orderDeliveredAction),
        findsOneWidget,
      );
    });

    testWidgets('"Show map" shares the same cubit with the map screen', (
      tester,
    ) async {
      Object? capturedArguments;
      final harnessWithRoute = _Harness(
        onGenerateRoute: (settings) {
          if (settings.name == Routes.orderMap) {
            capturedArguments = settings.arguments;
          }
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => Scaffold(
              body: Center(child: Text(routeStubText(settings.name ?? ''))),
            ),
          );
        },
      );
      await harnessWithRoute.pump(tester);
      harnessWithRoute.addTracking(
        const TrackingEntity(
          orderId: 'o-1',
          status: 'OutForDelivery',
          isLive: true,
          currentLocation: LocationEntity(lat: 1.0, lng: 2.0),
          userAddress: UserAddressEntity(
            lat: 3.0,
            lng: 4.0,
            addressLine: 'Street',
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      await tester.tap(find.widgetWithText(CustomButton, AppStrings.showMap));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(routeStubText(Routes.orderMap)), findsOneWidget);
      expect(capturedArguments, isA<OrderMapRouteArguments>());
      final args = capturedArguments as OrderMapRouteArguments;
      expect(args.viewModel, same(harnessWithRoute.viewModel));
      expect(args.tracking?.orderId, 'o-1');
    });
  });

  group('TrackOrderView - error', () {
    testWidgets('shows the error message and retries', (tester) async {
      final harness = _Harness();
      await harness.pump(tester);
      harness.addError('offline');
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('offline'), findsOneWidget);

      await tester.tap(find.text(AppStrings.retry));
      await tester.pump();

      harness.addTracking(_entity);
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));

      expect(find.text('offline'), findsNothing);
      expect(find.byType(CustomTrackingButtonsSection), findsOneWidget);
    });
  });

  group('TrackOrderView - navigation', () {
    testWidgets('the back arrow closes the screen', (tester) async {
      final harness = _Harness();
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(harness.viewModel.close);
      addTearDown(harness._repository.controller.close);

      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          child: BlocProvider.value(
            value: harness.viewModel,
            child: MaterialApp(
              home: Builder(
                builder: (context) => Scaffold(
                  body: Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const TrackOrderView(orderId: 'o-1'),
                        ),
                      ),
                      child: const Text(openButtonLabel),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text(openButtonLabel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(TrackOrderView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(TrackOrderView), findsNothing);
      expect(find.text(openButtonLabel), findsOneWidget);
    });
  });
}