import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/order_summary_section.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_cubit.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_event.dart';
import 'package:flower_app/features/payment/presentation/manager/cubit/place_order_state.dart';
import 'package:flower_app/features/payment/presentation/web_view_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../../helpers/fake_webview_platform.dart';
import '../../../../payment/mocks/mocks.mocks.dart';
import '../../../mocks/cubit_stream_stub.dart';
import '../../../mocks/mocks.mocks.dart';
import '../../../fixtures/checkout_fixtures.dart';

void main() {
  late MockCheckoutCubit mockCubit;
  late MockAddressCubit mockAddressCubit;
  late MockPlaceOrderCubit mockPlaceOrderCubit;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> stub;
  late CubitStreamStub<AddressState, MockAddressCubit> addressStub;
  late CubitStreamStub<PlaceOrderState, MockPlaceOrderCubit> placeOrderStub;
  late GlobalKey<FormState> formKey;

  const orderSuccessRoute = 'order-success-route';
  const checkoutRoute = 'checkout-route';

  setUp(() {
    mockCubit = MockCheckoutCubit();
    mockAddressCubit = MockAddressCubit();
    mockPlaceOrderCubit = MockPlaceOrderCubit();
    formKey = GlobalKey<FormState>();
    // The web view is only ever exercised through the fake platform below, so
    // it is installed once for the whole file and never restored.
    WebViewPlatform.instance = FakeWebViewPlatform();
  });

  FakeWebViewPlatform fakePlatform() =>
      WebViewPlatform.instance! as FakeWebViewPlatform;

  Future<void> pumpApp(
    WidgetTester tester, {
    AddressState? address,
    PlaceOrderState? placeOrder,
  }) async {
    addressStub = CubitStreamStub(
      mockAddressCubit,
      address ?? const AddressState(),
    );
    placeOrderStub = CubitStreamStub(
      mockPlaceOrderCubit,
      placeOrder ?? const PlaceOrderState(),
    );
    addTearDown(addressStub.close);
    addTearDown(placeOrderStub.close);

    tester.view.physicalSize = const Size(800, 1400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(800, 1400),
        child: MaterialApp(
          routes: {
            Routes.orderSuccess: (_) => const Text(orderSuccessRoute),
            Routes.checkout: (_) => const Text(checkoutRoute),
          },
          home: Scaffold(
            body: BlocProvider<CheckoutCubit>.value(
              value: mockCubit,
              child: BlocProvider<AddressCubit>.value(
                value: mockAddressCubit,
                child: BlocProvider<PlaceOrderCubit>.value(
                  value: mockPlaceOrderCubit,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: OrderSummarySection(formKey: formKey),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  CheckoutState loadedState({String selectedPaymentMethod = ''}) =>
      CheckoutState(
        checkoutDetailsState: const BaseState<CheckoutDetailsEntity>(
          data: CheckoutFixtures.tCheckoutDetailsEntity,
          isLoading: false,
        ),
        selectedPaymentMethod: selectedPaymentMethod,
      );

  Future<void> pumpStream(WidgetTester tester) async {
    await tester.pump();
    await tester.pump();
  }

  group('OrderSummarySection', () {
    testWidgets('shows a loading indicator on every amount while loading', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(LoadingCircule), findsNWidgets(3));
      expect(find.byType(CircularProgressIndicator), findsNWidgets(3));
    });

    testWidgets('renders the three summary labels while loading', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(AppStrings.subTotal), findsOneWidget);
      expect(find.text(AppStrings.deliveryFee), findsOneWidget);
      expect(find.text(AppStrings.total), findsOneWidget);
    });

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
      expect(find.byType(LoadingCircule), findsNothing);
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

    testWidgets('renders the subtotal, the delivery fee and the total', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(
        find.text(
          '${CheckoutFixtures.tCheckoutDetailsEntity.subtotal}${AppStrings.currencyUsd}',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '${CheckoutFixtures.tCheckoutDetailsEntity.deliveryFee}${AppStrings.currencyUsd}',
        ),
        findsOneWidget,
      );
      expect(
        find.text(
          '${CheckoutFixtures.tCheckoutDetailsEntity.total}${AppStrings.currencyUsd}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('replaces the loading indicators with the amounts once loaded', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);
      stub.emit(loadedState());
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(LoadingCircule), findsNothing);
      expect(
        find.text(
          '${CheckoutFixtures.tCheckoutDetailsEntity.total}${AppStrings.currencyUsd}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('always renders the enabled place order button', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      final button = tester.widget<CustomButton>(find.byType(CustomButton));
      expect(button.text, AppStrings.placeOrder);
      expect(button.isEnabled, isTrue);
    });

    testWidgets('shows a snackbar when no address is selected', (tester) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        loadedState(selectedPaymentMethod: CheckoutPaymentMethod.COD.name),
      );
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      await tester.tap(find.text(AppStrings.placeOrder));
      await pumpStream(tester);

      // Assert
      expect(find.text('no address selected'), findsOneWidget);
      verifyNever(mockPlaceOrderCubit.doEvent(any));
    });

    testWidgets('shows a snackbar when no payment method is selected', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);
      await pumpApp(
        tester,
        address: const AddressState(selectedAddressId: 'address-1'),
      );

      // Act
      await tester.tap(find.text(AppStrings.placeOrder));
      await pumpStream(tester);

      // Assert
      expect(find.text('no payment method selected'), findsOneWidget);
      verifyNever(mockPlaceOrderCubit.doEvent(any));
    });

    testWidgets('dispatches PostPlaceOrderEvent for a valid order', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        loadedState(selectedPaymentMethod: CheckoutPaymentMethod.COD.name),
      );
      addTearDown(stub.close);
      await pumpApp(
        tester,
        address: const AddressState(selectedAddressId: 'address-1'),
      );

      // Act
      await tester.tap(find.text(AppStrings.placeOrder));
      await pumpStream(tester);

      // Assert
      // TODO(flutter-app): the event classes have no `==` override, so the
      // dispatched instance is captured and inspected instead of matched.
      final captured = verify(mockPlaceOrderCubit.doEvent(captureAny)).captured;
      expect(captured.single, isA<PostPlaceOrderEvent>());

      final param = (captured.single as PostPlaceOrderEvent).placeOrderParam;
      expect(param.addressId, 'address-1');
      expect(param.paymentMethod, CheckoutPaymentMethod.COD);
      expect(param.isGift, isFalse);
      expect(find.text('no address selected'), findsNothing);
      expect(find.text('no payment method selected'), findsNothing);
    });

    testWidgets('keeps the place order button disabled while loading', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);

      // Act
      await pumpApp(
        tester,
        placeOrder: const PlaceOrderState(
          placeOrderState: BaseState<PlaceOrderEntity>(isLoading: true),
        ),
      );

      // Assert
      expect(find.text('loading....'), findsOneWidget);
      final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(button.onPressed, isNull);
    });

    testWidgets('shows the order failure in a snackbar', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      placeOrderStub.emit(
        const PlaceOrderState(
          placeOrderState: BaseState<PlaceOrderEntity>(isLoading: true),
        ),
      );
      await pumpStream(tester);
      placeOrderStub.emit(
        const PlaceOrderState(
          placeOrderState: BaseState<PlaceOrderEntity>(
            errorMessage: 'order failed',
          ),
        ),
      );
      await pumpStream(tester);
      await tester.pump(const Duration(milliseconds: 300));

      // Assert
      expect(find.text('order failed'), findsOneWidget);
      expect(find.byType(WebViewPayment), findsNothing);
    });

    testWidgets('opens the payment web view when a session url is returned', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      placeOrderStub.emit(
        const PlaceOrderState(
          placeOrderState: BaseState<PlaceOrderEntity>(isLoading: true),
        ),
      );
      await pumpStream(tester);
      placeOrderStub.emit(
        const PlaceOrderState(
          placeOrderState: BaseState<PlaceOrderEntity>(
            data: PlaceOrderEntity(
              message: 'created',
              sessionUrl: 'https://pay.example/session',
              successUrl: 'https://pay.example/success',
              cancelUrl: 'https://pay.example/cancel',
            ),
          ),
        ),
      );
      await pumpStream(tester);
      for (var i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Assert
      expect(find.byType(WebViewPayment), findsOneWidget);
      expect(find.text(orderSuccessRoute), findsNothing);
      expect(
        fakePlatform().lastController.loadedUrl,
        'https://pay.example/session',
      );
      expect(fakePlatform().lastController.navigationDelegate, isNotNull);
      expect(fakePlatform().lastDelegate.onNavigationRequest, isNotNull);
    });

    testWidgets(
      'replaces the screen with the success route without a session',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockCubit, loadedState());
        addTearDown(stub.close);
        await pumpApp(tester);

        // Act
        placeOrderStub.emit(
          const PlaceOrderState(
            placeOrderState: BaseState<PlaceOrderEntity>(isLoading: true),
          ),
        );
        await pumpStream(tester);
        placeOrderStub.emit(
          const PlaceOrderState(
            placeOrderState: BaseState<PlaceOrderEntity>(
              data: PlaceOrderEntity(message: 'created'),
            ),
          ),
        );
        await pumpStream(tester);
        for (var i = 0; i < 10; i++) {
          await tester.pump(const Duration(milliseconds: 100));
        }

        // Assert
        expect(find.text(orderSuccessRoute), findsOneWidget);
        expect(find.byType(OrderSummarySection), findsNothing);
        expect(find.byType(WebViewPayment), findsNothing);
      },
    );
  });
}
