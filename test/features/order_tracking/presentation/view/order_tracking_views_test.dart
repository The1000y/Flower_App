import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_cubit.dart';
import 'package:flower_app/features/commerce/presentation/cart/manager/cubit/cart_event.dart';
import 'package:flower_app/features/order_tracking/domain/entities/driver_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/presentation/view/order_map_view.dart';

import 'package:flower_app/features/order_tracking/presentation/view/track_order_view.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';
import 'package:flower_app/features/orders/presentation/view/order_success_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../helpers/fake_tracking_view_model.dart';
import '../../../../helpers/order_tracking_test_helpers.dart';
import 'package:flower_app/l10n/app_localizations_en.dart';

class MockCartCubit extends Mock implements CartCubit {}

final _tracking = TrackingEntity(
  orderId: 'o-1',
  status: 'OutForDelivery',
  driver: const DriverEntity(name: 'Mohamed', phone: '01014194042'),
  estimatedDeliveryAt: DateTime(2024, 9, 3, 11),
);

void main() {
  group('Order tracking views', () {
    testWidgets('TrackOrderView builds and shows the track order title', (
      tester,
    ) async {
      final viewModel = FakeTrackingViewModel()..emitTracking(_tracking);
      addTearDown(viewModel.close);

      await pumpOrderTrackingApp(
        tester,
        BlocProvider<TrackingViewModel>.value(
          value: viewModel,
          child: const TrackOrderView(orderId: 'o-1'),
        ),
        inScaffold: false,
      );

      expect(find.text(AppLocalizationsEn().trackOrder), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('OrderMapView shows a loader until tracking data arrives', (
      tester,
    ) async {
      final viewModel = FakeTrackingViewModel();
      addTearDown(viewModel.close);

      await pumpOrderTrackingApp(
        tester,
        BlocProvider<TrackingViewModel>.value(
          value: viewModel,
          child: const OrderMapView(),
        ),
        inScaffold: false,
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('OrderSuccessView opens the tracking screen', (tester) async {
      registerFallbackValue(ClearCartEvent());
      final cartCubit = MockCartCubit();
      when(() => cartCubit.doEvent(any())).thenAnswer((_) async {});
      getIt.allowReassignment = true;
      getIt.registerSingleton<CartCubit>(cartCubit);
      addTearDown(getIt.reset);

      await pumpOrderTrackingApp(
        tester,
        const OrderSuccessView(orderId: 'o-1'),
        inScaffold: false,
      );

      expect(find.text(AppLocalizationsEn().orderPlacedSuccess), findsOneWidget);

      await tester.tap(
        find.widgetWithText(CustomButton, AppLocalizationsEn().trackOrder),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text(routeStubText(Routes.trackOrder)), findsOneWidget);
    });
  });
}
