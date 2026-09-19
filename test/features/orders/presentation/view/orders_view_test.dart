import 'dart:async';
import 'package:flower_app/config/di/di.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flower_app/features/orders/presentation/view/orders_view.dart';
import 'package:flower_app/features/orders/presentation/view/widgets/order_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil_plus/flutter_screenutil_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockOrdersCubit extends Mock implements OrdersCubit {}

void main() {
  late MockOrdersCubit mockOrdersCubit;

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
  });

  setUp(() {
    mockOrdersCubit = MockOrdersCubit();
    getIt.registerSingleton<OrdersCubit>(mockOrdersCubit);

    when(() => mockOrdersCubit.state).thenReturn(OrdersInitial());
    when(() => mockOrdersCubit.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockOrdersCubit.fetchOrders()).thenAnswer((_) async {});
    when(() => mockOrdersCubit.close()).thenAnswer((_) async {});
  });

  Widget createWidgetUnderTest() {
    return ScreenUtilPlusInit(
      designSize: const Size(375, 812),
      child: const MaterialApp(
        home: OrdersView(),
      ),
    );
  }

  group('MyOrdersView', () {
    testWidgets('displays CircularProgressIndicator when state is OrdersLoading',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(OrdersLoading());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsAtLeastNWidgets(1));
    });

    testWidgets('displays active orders when state is OrdersSuccess',
        (tester) async {
      when(() => mockOrdersCubit.state).thenReturn(
        OrdersSuccess(
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

    testWidgets('displays error message when state is OrdersError',
        (tester) async {
      const errorMessage = "Failed to load orders";
      when(() => mockOrdersCubit.state).thenReturn(OrdersError(errorMessage));

      await tester.pumpWidget(createWidgetUnderTest());
      await tester.pump();

      expect(find.text(errorMessage), findsAtLeastNWidgets(1));
    });
  });
}
