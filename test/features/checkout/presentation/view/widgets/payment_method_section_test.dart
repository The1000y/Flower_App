import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/payment_method_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/cubit_stream_stub.dart';
import '../../../mocks/mocks.mocks.dart';

import '../../../../../helpers/flutter_diagnostic_tolerances.dart';
import '../../../fixtures/checkout_fixtures.dart';

void main() {
  late MockCheckoutCubit mockCubit;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> stub;

  setUp(() {
    mockCubit = MockCheckoutCubit();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // TODO(flutter-app): `_PaymentOptionTile` wraps its `RadioListTile` in a
    // `Container` with a background colour, which trips the ListTile
    // ink-visibility diagnostic on every build. Fixing it requires a
    // production change, so only that exact message is dropped here.
    FlutterDiagnosticTolerances.ignoreFlutterDiagnostics({
      FlutterDiagnosticTolerances.listTileInkVisibility,
    });
    addTearDown(FlutterDiagnosticTolerances.restoreFlutterErrorHandler);

    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(800, 1400),
        child: MaterialApp(
          home: Scaffold(
            body: BlocProvider<CheckoutCubit>.value(
              value: mockCubit,
              child: const PaymentMethodSection(),
            ),
          ),
        ),
      ),
    );
  }

  CheckoutState loadedState() => const CheckoutState(
    checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
      data: CheckoutFixtures.tCheckoutDetailsEntity,
      isLoading: false,
    ),
  );

  group('PaymentMethodSection', () {
    testWidgets(
      'shows a loading indicator while the checkout details are loading',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockCubit, const CheckoutState());
        addTearDown(stub.close);

        // Act
        await pumpApp(tester);

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    testWidgets('shows the error message when the checkout details fail', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            errorMessage: 'Failed to get checkout details',
            isLoading: false,
          ),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text('Failed to get checkout details'), findsOneWidget);
    });

    testWidgets('falls back to a generic message when there is no data', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            isLoading: false,
          ),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(AppStrings.somethingWentWrong), findsOneWidget);
    });

    testWidgets('renders the section title when the details are loaded', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(AppStrings.paymentMethod), findsOneWidget);
    });

    testWidgets('renders one radio option per payment method', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(CheckoutFixtures.tCod), findsOneWidget);
      expect(find.text(CheckoutFixtures.tCard), findsOneWidget);
      expect(find.byType(RadioListTile<String>), findsNWidgets(2));
    });

    testWidgets(
      'renders an empty list when the details have no payment methods',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(
          mockCubit,
          const CheckoutState(
            checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
              data: CheckoutDetailsEntity(
                subtotal: 0,
                deliveryFee: 0,
                total: 0,
                estimatedDeliveryAt: '',
                paymentMethods: [],
                isGift: false,
              ),
              isLoading: false,
            ),
          ),
        );
        addTearDown(stub.close);

        // Act
        await pumpApp(tester);

        // Assert
        expect(find.byType(RadioListTile<String>), findsNothing);
        expect(find.text(AppStrings.paymentMethod), findsOneWidget);
      },
    );

    testWidgets(
      'dispatches SelectPaymentMethodEvent when an option is tapped',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockCubit, loadedState());
        addTearDown(stub.close);

        // Act
        await pumpApp(tester);
        await tester.tap(
          find.widgetWithText(RadioListTile<String>, CheckoutFixtures.tCard),
        );
        await tester.pump();

        // Assert
        // TODO(flutter-app): the event classes have no `==` override, so the
        // dispatched instance is captured and inspected instead of matched.
        final captured = verify(mockCubit.doEvent(captureAny)).captured;
        expect(captured.length, 1);
        expect(captured.single, isA<SelectPaymentMethodEvent>());
        expect(
          (captured.single as SelectPaymentMethodEvent).paymentMethod,
          CheckoutFixtures.tCard,
        );
      },
    );

    testWidgets('marks the option matching the selected payment method', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            data: CheckoutFixtures.tCheckoutDetailsEntity,
            isLoading: false,
          ),
          selectedPaymentMethod: CheckoutFixtures.tCod,
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      final tile = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, CheckoutFixtures.tCod),
      );
      // ignore: deprecated_member_use
      expect(tile.groupValue, CheckoutFixtures.tCod);
    });

    testWidgets('rebuilds when a payment method gets selected', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);
      stub.emit(
        const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            data: CheckoutFixtures.tCheckoutDetailsEntity,
            isLoading: false,
          ),
          selectedPaymentMethod: CheckoutFixtures.tCard,
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      final tile = tester.widget<RadioListTile<String>>(
        find.widgetWithText(RadioListTile<String>, CheckoutFixtures.tCard),
      );
      // ignore: deprecated_member_use
      expect(tile.groupValue, CheckoutFixtures.tCard);
    });
  });
}
