import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/use_case/get_active_orders_usecase.dart';
import 'package:flower_app/features/orders/domain/use_case/get_completed_orders_usecase.dart';
import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetActiveOrdersUseCase extends Mock
    implements GetActiveOrdersUseCase {}

class MockGetCompletedOrdersUseCase extends Mock
    implements GetCompletedOrdersUseCase {}

void main() {
  late MockGetActiveOrdersUseCase mockGetActiveOrdersUseCase;
  late MockGetCompletedOrdersUseCase mockGetCompletedOrdersUseCase;
  late OrdersCubit cubit;

  final tActiveOrder = OrderEntity(
    orderName: "Red Roses",
    orderPrice: "600 EGP",
    orderId: "123",
    orderDeliverDate: "20-09-2026",
    isActive: true,
    imageUrl: "https://example.com/rose.png",
  );

  final tCompletedOrder = OrderEntity(
    orderName: "Tulips",
    orderPrice: "400 EGP",
    orderId: "456",
    orderDeliverDate: "15-09-2026",
    isActive: false,
    imageUrl: "https://example.com/tulip.png",
  );

  setUp(() {
    mockGetActiveOrdersUseCase = MockGetActiveOrdersUseCase();
    mockGetCompletedOrdersUseCase = MockGetCompletedOrdersUseCase();
    cubit = OrdersCubit(
      mockGetActiveOrdersUseCase,
      mockGetCompletedOrdersUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should be OrdersInitial', () {
    expect(cubit.state, isA<OrdersInitial>());
  });

  blocTest<OrdersCubit, OrdersState>(
    'emits [OrdersLoading, OrdersSuccess] when fetchOrders succeeds',
    build: () {
      when(() => mockGetActiveOrdersUseCase()).thenAnswer(
        (_) async => [tActiveOrder],
      );
      when(() => mockGetCompletedOrdersUseCase()).thenAnswer(
        (_) async => [tCompletedOrder],
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchOrders(),
    expect: () => [
      isA<OrdersLoading>(),
      isA<OrdersSuccess>()
          .having((s) => s.activeOrders.length, 'activeOrders length', 1)
          .having((s) => s.completedOrders.length, 'completedOrders length', 1),
    ],
    verify: (_) {
      verify(() => mockGetActiveOrdersUseCase()).called(1);
      verify(() => mockGetCompletedOrdersUseCase()).called(1);
    },
  );
}
