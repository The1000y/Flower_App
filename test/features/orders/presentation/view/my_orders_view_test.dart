import 'dart:async';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/config/routing/routes.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_intent.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flower_app/features/orders/presentation/view/my_orders_view.dart';
import 'package:flower_app/features/orders/presentation/view/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersCubit extends Mock implements OrdersCubit {}

void main() {
  late MockOrdersCubit mockOrdersCubit;
  late StreamController<OrdersState> stateController;

  final tActiveOrder = OrderEntity(
    orderName: "Red Roses",
    orderPrice: "600 EGP",
    orderId: "123456",
    orderDeliverDate: "",
    isActive: true,
    imageUrl: "https://example.com/rose.png",
  );

  final tCompletedOrder = OrderEntity(
    orderName: "Pink Lilies",
    orderPrice: "450 EGP",
    orderId: "654321",
    orderDeliverDate: "20 Sep",
    isActive: false,
    imageUrl: "https://example.com/lily.png",
  );

  setUpAll(() {
    getIt.allowReassignment = true;
    registerFallbackValue(const FetchOrdersIntent());
    registerFallbackValue(const TrackOrderTappedIntent(''));
    registerFallbackValue(const ReorderTappedIntent(''));
    registerFallbackValue(const ResetSideEffectIntent());
  });

  setUp(() {
    mockOrdersCubit = MockOrdersCubit();
    stateController = StreamController<OrdersState>.broadcast();

    getIt.registerSingleton<OrdersCubit>(mockOrdersCubit);

    when(() => mockOrdersCubit.state).thenReturn(const OrdersState(baseState: OrdersBaseState.initial));
    when(() => mockOrdersCubit.stream).thenAnswer((_) => stateController.stream);
    when(() => mockOrdersCubit.doIntent(any())).thenAnswer((_) async {});
    when(() => mockOrdersCubit.close()).thenAnswer((_) async => stateController.close());
  });

  tearDown(() {
    stateController.close();
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: MaterialApp(
        routes: {
          Routes.trackOrder: (context) => const Scaffold(body: Text('Track Order View')),
          Routes.cart: (context) => const Scaffold(body: Text('Cart View')),
        },
        home: BlocProvider<OrdersCubit>.value(
          value: mockOrdersCubit,
          child: const MyOrdersView(),
        ),
      ),
    );
  }

  group('MyOrdersView', () {
    testWidgets('displays CircularProgressIndicator when state is loading',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(const OrdersState(baseState: OrdersBaseState.loading));

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('displays active orders when state is success',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(
        OrdersState(
          baseState: OrdersBaseState.success,
          activeOrders: [tActiveOrder],
          completedOrders: [tCompletedOrder],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(AppStrings.myOrdersTitle), findsOneWidget);
      expect(find.text(AppStrings.tabActive), findsOneWidget);
      expect(find.text(AppStrings.tabCompleted), findsOneWidget);
      expect(find.byType(OrderCardWidget), findsAtLeastNWidgets(1));
      expect(find.text("Red Roses"), findsOneWidget);
    });

    testWidgets('displays error message when state is error',
        (tester) async {
      const errorMessage = "Failed to load orders";
      when(() => mockOrdersCubit.state).thenReturn(const OrdersState(baseState: OrdersBaseState.error, errorMessage: errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsAtLeastNWidgets(1));
    });

    testWidgets('dispatches FetchOrdersIntent(isLoadMore: true) on scrolling to bottom',
        (tester) async {
      final fifteenOrders = List.generate(
        15,
        (index) => OrderEntity(
          orderName: "Order $index",
          orderPrice: "100 EGP",
          orderId: "ORD-$index",
          orderDeliverDate: "2026-09-25",
          isActive: true,
          imageUrl: "https://example.com/flower.png",
        ),
      );

      when(() => mockOrdersCubit.state).thenReturn(
        OrdersState(
          baseState: OrdersBaseState.success,
          activeOrders: fifteenOrders,
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      await tester.drag(find.byType(ListView).first, const Offset(0, -2000));
      await tester.pump();

      verify(() => mockOrdersCubit.doIntent(const FetchOrdersIntent(isLoadMore: true))).called(greaterThan(0));
    });

    testWidgets('dispatches TrackOrderTappedIntent when track order button is tapped',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(
        OrdersState(
          baseState: OrdersBaseState.success,
          activeOrders: [tActiveOrder],
        ),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      final trackButton = find.text(AppStrings.trackOrder);
      expect(trackButton, findsOneWidget);
      await tester.tap(trackButton);
      await tester.pump();

      verify(() => mockOrdersCubit.doIntent(TrackOrderTappedIntent(tActiveOrder.orderId))).called(1);
    });

    testWidgets('navigates to trackOrder and dispatches ResetSideEffectIntent on navigateToTrack side effect',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(
        const OrdersState(baseState: OrdersBaseState.success),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      stateController.add(
        const OrdersState(
          baseState: OrdersBaseState.success,
          sideEffect: OrdersSideEffect.navigateToTrack,
          selectedOrderId: "123456",
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Track Order View'), findsOneWidget);
      verify(() => mockOrdersCubit.doIntent(const ResetSideEffectIntent())).called(1);
    });

    testWidgets('navigates to cart and dispatches ResetSideEffectIntent on navigateToCart side effect',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(
        const OrdersState(baseState: OrdersBaseState.success),
      );

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pumpAndSettle();

      stateController.add(
        const OrdersState(
          baseState: OrdersBaseState.success,
          sideEffect: OrdersSideEffect.navigateToCart,
          selectedOrderId: "654321",
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Cart View'), findsOneWidget);
      verify(() => mockOrdersCubit.doIntent(const ResetSideEffectIntent())).called(1);
    });
  });
}
