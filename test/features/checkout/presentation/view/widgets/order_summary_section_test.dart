import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/core/shared/app_widgets/custom_button.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/order_summary_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/cubit_stream_stub.dart';
import '../../../mocks/mocks.mocks.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  late MockCheckoutCubit mockCubit;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> stub;

  setUp(() {
    mockCubit = MockCheckoutCubit();
  });

  Future<void> pumpApp(WidgetTester tester) async {
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
              child: const OrderSummarySection(),
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

    testWidgets('tapping place order does not throw', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, loadedState());
      addTearDown(stub.close);
      await pumpApp(tester);

      // Act
      await tester.tap(find.text(AppStrings.placeOrder));
      await tester.pump();

      // Assert
      expect(tester.takeException(), isNull);
    });
  });
}
