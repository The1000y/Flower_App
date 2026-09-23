import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';
import 'package:flower_app/features/orders/domain/use_case/get_orders_usecase.dart';
import 'package:flower_app/features/orders/presentation/manager/cubit/orders_cubit.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOrdersUseCase extends Mock implements GetOrdersUseCase {}

void main() {
  late MockGetOrdersUseCase mockGetOrdersUseCase;
  late OrdersCubit cubit;

  const tActiveOrder = OrderEntity(
    orderName: "Red Roses",
    orderPrice: "600 EGP",
    orderId: "123",
    orderDeliverDate: "20-09-2026",
    isActive: true,
    imageUrl: "https://example.com/rose.png",
  );

  const tCompletedOrder = OrderEntity(
    orderName: "Tulips",
    orderPrice: "400 EGP",
    orderId: "456",
    orderDeliverDate: "15-09-2026",
    isActive: false,
    imageUrl: "https://example.com/tulip.png",
  );

  setUp(() {
    mockGetOrdersUseCase = MockGetOrdersUseCase();
    cubit = OrdersCubit(mockGetOrdersUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  test('initial state should have initial baseState', () {
    expect(cubit.state.baseState, OrdersBaseState.initial);
  });

  blocTest<OrdersCubit, OrdersState>(
    'emits loading and success states when fetchOrders succeeds on first page',
    build: () {
      when(() => mockGetOrdersUseCase(page: 1, limit: 10)).thenAnswer(
        (_) async => [tActiveOrder, tCompletedOrder],
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchOrders(),
    expect: () => [
      const OrdersState(baseState: OrdersBaseState.loading, page: 1, hasReachedMax: false),
      const OrdersState(
        baseState: OrdersBaseState.success,
        page: 2,
        activeOrders: [tActiveOrder],
        completedOrders: [tCompletedOrder],
      ),
    ],
    verify: (_) {
      verify(() => mockGetOrdersUseCase(page: 1, limit: 10)).called(1);
    },
  );

  blocTest<OrdersCubit, OrdersState>(
    'emits appended list on successful loadMore',
    build: () {
      when(() => mockGetOrdersUseCase(page: 2, limit: 10)).thenAnswer(
        (_) async => [tActiveOrder],
      );
      return cubit;
    },
    seed: () => const OrdersState(
      baseState: OrdersBaseState.success,
      page: 2,
      activeOrders: [tActiveOrder],
      completedOrders: [tCompletedOrder],
    ),
    act: (cubit) => cubit.fetchOrders(isLoadMore: true),
    expect: () => [
      const OrdersState(
        baseState: OrdersBaseState.success,
        page: 3,
        activeOrders: [tActiveOrder, tActiveOrder],
        completedOrders: [tCompletedOrder],
      ),
    ],
    verify: (_) {
      verify(() => mockGetOrdersUseCase(page: 2, limit: 10)).called(1);
    },
  );

  blocTest<OrdersCubit, OrdersState>(
    'emits error state on failure',
    build: () {
      when(() => mockGetOrdersUseCase(page: 1, limit: 10)).thenThrow(
        Exception('Network Error'),
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchOrders(),
    expect: () => [
      const OrdersState(baseState: OrdersBaseState.loading, page: 1),
      const OrdersState(
        baseState: OrdersBaseState.error,
        errorMessage: 'Exception: Network Error',
        page: 1,
      ),
    ],
  );

  blocTest<OrdersCubit, OrdersState>(
    'sets hasReachedMax when API returns empty list',
    build: () {
      when(() => mockGetOrdersUseCase(page: 1, limit: 10)).thenAnswer(
        (_) async => [],
      );
      return cubit;
    },
    act: (cubit) => cubit.fetchOrders(),
    expect: () => [
      const OrdersState(baseState: OrdersBaseState.loading, page: 1),
      const OrdersState(
        baseState: OrdersBaseState.success,
        page: 1,
        hasReachedMax: true,
      ),
    ],
  );
}
