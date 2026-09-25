import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_cubit.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flower_app/features/checkout/presentation/view/widgets/delivery_time_section.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../mocks/cubit_stream_stub.dart';
import '../../../mocks/mocks.mocks.dart';
import 'package:shimmer/shimmer.dart';

import '../../../fixtures/checkout_fixtures.dart';

void main() {
  late MockCheckoutCubit mockCubit;
  late CubitStreamStub<CheckoutState, MockCheckoutCubit> stub;

  setUp(() {
    mockCubit = MockCheckoutCubit();
  });

  Future<void> pumpApp(WidgetTester tester) async {
    // A wide surface is used on purpose: the section lays the schedule icon,
    // the " Instant, " label and the estimated time out in a single unbounded
    // Row, and the flutter_test font renders every glyph at the full font
    // size, so a 375pt wide viewport overflows.
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
              child: const DeliveryTimeSection(),
            ),
          ),
        ),
      ),
    );
  }

  group('DeliveryTimeSection', () {
    testWidgets('renders the static delivery time labels', (tester) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.text('Delivery time'), findsOneWidget);
      expect(find.byIcon(Icons.schedule), findsOneWidget);
    });

    testWidgets(
      'shows a shimmer placeholder while the estimation time is loading',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(mockCubit, const CheckoutState());
        addTearDown(stub.close);

        // Act
        await pumpApp(tester);

        // Assert
        expect(find.byType(Shimmer), findsOneWidget);
      },
    );

    testWidgets('hides the shimmer once the estimation time is loaded', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          estimationTimeState: BaseState<EstimationTimeEntity>(
            data: CheckoutFixtures.tEstimationTimeEntity,
            isLoading: false,
          ),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(find.byType(Shimmer), findsNothing);
    });

    testWidgets('shows the arrive by text with the estimated delivery time', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(
        mockCubit,
        const CheckoutState(
          estimationTimeState: BaseState<EstimationTimeEntity>(
            data: CheckoutFixtures.tEstimationTimeEntity,
            isLoading: false,
          ),
        ),
      );
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);

      // Assert
      expect(
        find.text('Arrive by ${CheckoutFixtures.tEstimatedDeliveryAt}'),
        findsOneWidget,
      );
    });

    testWidgets(
      'shows the error message when loading the estimation time fails',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(
          mockCubit,
          const CheckoutState(
            estimationTimeState: BaseState<EstimationTimeEntity>(
              errorMessage: 'Failed to get estimation time',
              isLoading: false,
            ),
          ),
        );
        addTearDown(stub.close);

        // Act
        await pumpApp(tester);

        // Assert
        expect(find.text('Failed to get estimation time'), findsOneWidget);
        expect(find.byType(Shimmer), findsNothing);
      },
    );

    testWidgets(
      'shows the arrive by text with an empty time when no data is available',
      (tester) async {
        // Arrange
        stub = CubitStreamStub(
          mockCubit,
          const CheckoutState(
            estimationTimeState: BaseState<EstimationTimeEntity>(
              isLoading: false,
            ),
          ),
        );
        addTearDown(stub.close);

        // Act
        await pumpApp(tester);

        // Assert
        expect(find.text('Arrive by '), findsOneWidget);
      },
    );

    testWidgets('rebuilds when a new estimation time arrives on the stream', (
      tester,
    ) async {
      // Arrange
      stub = CubitStreamStub(mockCubit, const CheckoutState());
      addTearDown(stub.close);

      // Act
      await pumpApp(tester);
      stub.emit(
        const CheckoutState(
          estimationTimeState: BaseState<EstimationTimeEntity>(
            data: EstimationTimeEntity(
              estimatedDeliveryAt: '2025-06-01T10:00:00.000Z',
            ),
            isLoading: false,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Arrive by 2025-06-01T10:00:00.000Z'), findsOneWidget);
      expect(find.byType(Shimmer), findsNothing);
    });
  });
}
