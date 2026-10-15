import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/animations/animated_car_single_file.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/order_tracking/domain/entities/driver_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/presentation/view/track_order_view.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';
import 'package:flower_app/features/order_tracking/presentation/view/waiting_for_driver_view.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_contract_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_delivery_boy_information_card.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_estimated_arrival_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/custom_tracking_buttons_section.dart';
import 'package:flower_app/features/order_tracking/presentation/widgets/order_status_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_tracking_view_model.dart';
import '../../../../helpers/order_tracking_test_helpers.dart';

const _driver = DriverEntity(
  name: 'Mohamed',
  phone: '01014194042',
  photoUrl: 'https://images.unsplash.com/photo-1556761175-b413da4baf72?w=500',
);

TrackingEntity _tracking({
  String status = 'OutForDelivery',
  DriverEntity? driver = _driver,
}) => TrackingEntity(
  orderId: 'o-1',
  status: status,
  driver: driver,
  estimatedDeliveryAt: DateTime(2024, 9, 3, 11),
);

Future<void> _pump(
  WidgetTester tester, {
  TrackingEntity? entity,
  bool loading = false,
  String? error,
  Size surfaceSize = const Size(800, 1400),
}) async {
  final viewModel = FakeTrackingViewModel();
  if (loading) viewModel.emitLoading();
  if (error != null) viewModel.emitError(error);
  if (entity != null) viewModel.emitTracking(entity);
  addTearDown(viewModel.close);

  await pumpOrderTrackingApp(
    tester,
    BlocProvider<TrackingViewModel>.value(
      value: viewModel,
      child: const TrackOrderView(orderId: 'o-1'),
    ),
    inScaffold: false,
    surfaceSize: surfaceSize,
  );
}

void main() {
  group('TrackOrderView - content', () {
    testWidgets('shows the "Track order" title in the app bar', (tester) async {
      await _pump(tester, entity: _tracking());

      expect(
        find.descendant(
          of: find.byType(AppBar),
          matching: find.text(AppStrings.trackOrder),
        ),
        findsOneWidget,
      );
    });

    testWidgets('shows the waiting view while no driver is assigned', (
      tester,
    ) async {
      await _pump(tester, entity: _tracking(driver: null));

      expect(find.byType(WaitingForDriverView), findsOneWidget);
      expect(find.byType(OrderStatusSection), findsNothing);
    });

    testWidgets('shows every section once a driver is assigned', (tester) async {
      await _pump(tester, entity: _tracking());

      expect(find.byType(CustomEstimatedArrivalSection), findsOneWidget);
      expect(find.byType(CustomDeliveryBoyInformationCard), findsOneWidget);
      expect(find.byType(AnimatedCar), findsOneWidget);
      expect(find.byType(OrderStatusSection), findsOneWidget);
      expect(find.byType(CustomTrackingButtonsSection), findsOneWidget);
    });

    testWidgets('shows the driver coming from the tracking data', (tester) async {
      await _pump(tester, entity: _tracking());

      expect(find.text('Mohamed'), findsOneWidget);
      expect(
        tester
            .widget<CustomContactCard>(find.byType(CustomContactCard))
            .phoneNumber,
        '01014194042',
      );
    });

    testWidgets('shows a loader while the snapshot is loading', (tester) async {
      await _pump(tester, loading: true);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('shows the error message when tracking fails', (tester) async {
      await _pump(tester, error: 'offline');

      expect(find.text('offline'), findsOneWidget);
    });
  });

  group('TrackOrderView - scrolling', () {
    testWidgets('the sections scroll with the page', (tester) async {
      await _pump(tester, entity: _tracking());

      for (final type in [
        CustomEstimatedArrivalSection,
        CustomDeliveryBoyInformationCard,
        AnimatedCar,
        OrderStatusSection,
      ]) {
        expect(
          find.descendant(
            of: find.byType(CustomScrollView),
            matching: find.byType(type),
          ),
          findsOneWidget,
          reason: '$type should scroll with the page',
        );
      }
    });

    testWidgets('the bottom buttons stay outside the scroll view', (
      tester,
    ) async {
      await _pump(tester, entity: _tracking());

      expect(
        find.descendant(
          of: find.byType(CustomScrollView),
          matching: find.byType(CustomTrackingButtonsSection),
        ),
        findsNothing,
      );
    });
  });

  group('TrackOrderView - buttons', () {
    testWidgets('shows only "Show map" before the order is delivered', (
      tester,
    ) async {
      await _pump(tester, entity: _tracking());

      expect(
        find.widgetWithText(CustomButton, AppStrings.showMap),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(CustomButton, AppStrings.orderDeliveredAction),
        findsNothing,
      );
    });

    testWidgets('shows the delivered action once the order is delivered', (
      tester,
    ) async {
      await _pump(tester, entity: _tracking(status: 'Delivered'));

      expect(
        find.widgetWithText(CustomButton, AppStrings.orderDeliveredAction),
        findsOneWidget,
      );
    });

    testWidgets('"Show map" opens the order map route', (tester) async {
      await _pump(tester, entity: _tracking());

      await tester.tap(find.widgetWithText(CustomButton, AppStrings.showMap));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text(routeStubText(Routes.orderMap)), findsOneWidget);
    });
  });

  group('TrackOrderView - navigation', () {
    testWidgets('the back arrow closes the screen', (tester) async {
      final viewModel = FakeTrackingViewModel()..emitTracking(_tracking());
      addTearDown(viewModel.close);

      await pumpOrderTrackingApp(
        tester,
        openScreenHome(
          BlocProvider<TrackingViewModel>.value(
            value: viewModel,
            child: const TrackOrderView(orderId: 'o-1'),
          ),
        ),
        inScaffold: false,
      );

      await tester.tap(find.text(openButtonLabel));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      await tester.tap(find.byIcon(Icons.arrow_back_ios));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.byType(TrackOrderView), findsNothing);
      expect(find.text(openButtonLabel), findsOneWidget);
    });
  });
}
