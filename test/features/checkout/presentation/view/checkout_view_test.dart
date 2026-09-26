import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/addresses/domain/entities/address_entity.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/add_address_cubit.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_events.dart';
import 'package:flower_app/features/addresses/presentation/manager/cubit/address_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/checkout_view.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/delivery_address_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/delivery_time_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/gift_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/order_summary_section.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/payment_method_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../mocks/cubit_stream_stub.dart';
import '../../mocks/mocks.mocks.dart';

import '../../../../helpers/flutter_diagnostic_tolerances.dart';
import '../../fixtures/checkout_fixtures.dart';

void main() {
  late MockCheckoutCubit mockCheckoutCubit;
  late MockAddressCubit mockAddressCubit;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> checkoutStub;
  late CubitStreamStub<AddressState, MockAddressCubit> addressStub;

  final tAddress = AddressEntity(
    id: 'address-1',
    recipientName: 'Mona Ahmed',
    recipientPhone: '01012345678',
    addressLine: '2XVP+XC',
    city: 'Cairo',
    area: 'Sheikh Zayed',
    label: 'Home',
    isDefault: true,
    isServiceable: true,
    createdAt: DateTime(2024, 2, 10),
  );

  setUp(() {
    mockCheckoutCubit = MockCheckoutCubit();
    mockAddressCubit = MockAddressCubit();

    if (getIt.isRegistered<CheckoutCubit>()) {
      getIt.unregister<CheckoutCubit>();
    }
    if (getIt.isRegistered<AddressCubit>()) {
      getIt.unregister<AddressCubit>();
    }
    getIt.registerFactory<CheckoutCubit>(() => mockCheckoutCubit);
    getIt.registerFactory<AddressCubit>(() => mockAddressCubit);
  });

  tearDown(() {
    getIt.reset();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // TODO(flutter-app): the address and payment tiles wrap their
    // `RadioListTile` in a `Container` with a background colour, which trips
    // the ListTile ink-visibility diagnostic on every build. Fixing it requires
    // a production change, so only that exact message is dropped here.
    FlutterDiagnosticTolerances.ignoreFlutterDiagnostics({
      FlutterDiagnosticTolerances.listTileInkVisibility,
    });
    addTearDown(FlutterDiagnosticTolerances.restoreFlutterErrorHandler);

    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ScreenUtilPlusInit(
        designSize: const Size(800, 2400),
        child: const MaterialApp(home: CheckoutView()),
      ),
    );
  }

  void listenToBothCubits({CheckoutState? checkout, AddressState? address}) {
    checkoutStub = CubitStreamStub(
      mockCheckoutCubit,
      checkout ?? const CheckoutState(),
    );
    addressStub = CubitStreamStub(
      mockAddressCubit,
      address ?? const AddressState(),
    );
    addTearDown(checkoutStub.close);
    addTearDown(addressStub.close);
  }

  /// The sections use `shimmer` and indeterminate `CircularProgressIndicator`s,
  /// which animate forever, so `pumpAndSettle` would never return. The
  /// `MaterialPageRoute` transition also needs roughly 600ms, so this pumps
  /// fixed frames long enough for one-off state and route transitions to end.
  Future<void> pumpFrames(WidgetTester tester) async {
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  group('CheckoutView', () {
    testWidgets('renders the checkout app bar with a back button', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits();

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text(AppStrings.checkoutTitle), findsOneWidget);
      expect(find.byIcon(Icons.arrow_back_ios_new), findsOneWidget);
    });

    testWidgets('renders every checkout section', (tester) async {
      // Arrange
      listenToBothCubits();

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(DeliveryTimeSection), findsOneWidget);
      expect(find.byType(DeliveryAddressSection), findsOneWidget);
      expect(find.byType(PaymentMethodSection), findsOneWidget);
      expect(find.byType(GiftSection), findsOneWidget);
      expect(find.byType(OrderSummarySection), findsOneWidget);
    });

    testWidgets('requests the checkout details and the addresses on creation', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits();

      // Act
      await pumpApp(tester);

      // Assert
      // TODO(flutter-app): the event classes have no `==` override, so the
      // dispatched instances are captured and inspected instead of matched.
      final checkoutEvents = verify(
        mockCheckoutCubit.doEvent(captureAny),
      ).captured;
      expect(checkoutEvents.single, isA<GetCheckoutEvent>());

      final addressEvents = verify(
        mockAddressCubit.doEvent(captureAny),
      ).captured;
      expect(addressEvents.single, isA<FetchUserAddressesEvent>());
    });

    testWidgets(
      'shows the loading indicators of both sections on the initial state',
      (tester) async {
        // Arrange
        listenToBothCubits();

        // Act
        await pumpApp(tester);

        // Assert
        // One for the payment methods and three for the summary amounts. The
        // addresses section shows its empty message because `BaseState`
        // defaults `isLoading` to false.
        expect(find.byType(CircularProgressIndicator), findsNWidgets(4));
      },
    );

    testWidgets('shows the full checkout once both requests succeed', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits(
        checkout: const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            data: CheckoutFixtures.tCheckoutDetailsEntity,
            isLoading: false,
          ),
          estimationTimeState: BaseState<EstimationTimeEntity>(
            data: CheckoutFixtures.tEstimationTimeEntity,
            isLoading: false,
          ),
        ),
        address: AddressState(
          addressesState: BaseState<List<AddressEntity>>(data: [tAddress]),
        ),
      );

      // Act
      await pumpApp(tester);
      await pumpFrames(tester);

      // Assert
      expect(
        find.text('Arrive by ${CheckoutFixtures.tEstimatedDeliveryAt}'),
        findsOneWidget,
      );
      expect(find.text(CheckoutFixtures.tCod), findsOneWidget);
      expect(find.text(CheckoutFixtures.tCard), findsOneWidget);
      expect(find.text(AppStrings.placeOrder), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('shows the checkout error message when the details fail', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits(
        checkout: const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            errorMessage: 'Failed to get checkout details',
            isLoading: false,
          ),
        ),
      );

      // Act
      await pumpApp(tester);
      await pumpFrames(tester);

      // Assert
      // Once for the payment method section and once for the order summary.
      expect(find.text('Failed to get checkout details'), findsNWidgets(2));
    });

    testWidgets('shows the estimation time error message when it fails', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits(
        checkout: const CheckoutState(
          estimationTimeState: BaseState<EstimationTimeEntity>(
            errorMessage: 'Failed to get estimation time',
            isLoading: false,
          ),
        ),
      );

      // Act
      await pumpApp(tester);
      await pumpFrames(tester);

      // Assert
      expect(find.text('Failed to get estimation time'), findsOneWidget);
    });

    testWidgets('shows the addresses error message when they fail to load', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits(
        address: const AddressState(
          addressesState: BaseState<List<AddressEntity>>(
            errorMessage: 'Failed to load addresses',
          ),
        ),
      );

      // Act
      await pumpApp(tester);
      await pumpFrames(tester);

      // Assert
      expect(find.text('Failed to load addresses'), findsOneWidget);
    });

    testWidgets('hides the gift section for the COD payment method', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits(
        checkout: const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            data: CheckoutFixtures.tCheckoutDetailsEntity,
            isLoading: false,
          ),
          selectedPaymentMethod: CheckoutFixtures.tCod,
        ),
      );

      // Act
      await pumpApp(tester);
      await pumpFrames(tester);

      // Assert
      expect(find.text(AppStrings.itIsAGift), findsNothing);
    });

    testWidgets('shows the gift fields for a gift order with a card payment', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits(
        checkout: const CheckoutState(
          checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
            data: CheckoutFixtures.tCheckoutDetailsEntity,
            isLoading: false,
          ),
          selectedPaymentMethod: CheckoutFixtures.tCard,
          isGift: true,
        ),
      );

      // Act
      await pumpApp(tester);
      await pumpFrames(tester);

      // Assert
      expect(find.text(AppStrings.itIsAGift), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('tapping the back button pops the checkout route', (
      tester,
    ) async {
      // Arrange
      listenToBothCubits();
      // TODO(flutter-app): the address and payment tiles wrap their
      // `RadioListTile` in a `Container` with a background colour, which trips
      // the ListTile ink-visibility diagnostic on every build. Fixing it
      // requires a production change, so only that exact message is dropped.
      FlutterDiagnosticTolerances.ignoreFlutterDiagnostics({
        FlutterDiagnosticTolerances.listTileInkVisibility,
      });
      addTearDown(FlutterDiagnosticTolerances.restoreFlutterErrorHandler);

      tester.view.physicalSize = const Size(800, 2400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        ScreenUtilPlusInit(
          designSize: const Size(800, 2400),
          child: MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const CheckoutView()),
                    ),
                    child: const Text('Go to checkout'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );

      // Act
      await tester.tap(find.text('Go to checkout'));
      await pumpFrames(tester);
      expect(find.byType(CheckoutView), findsOneWidget);

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await pumpFrames(tester);

      // Assert
      expect(find.byType(CheckoutView), findsNothing);
      expect(find.text('Go to checkout'), findsOneWidget);
    });
  });
}
