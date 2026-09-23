import 'package:flower_app/features/orders/domain/use_case/get_orders_usecase.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrdersCubit(this.getOrdersUseCase) : super(const OrdersState());

  Future<void> fetchOrders({bool isLoadMore = false}) async {
    if (state.hasReachedMax && isLoadMore) return;

    if (!isLoadMore) {
      emit(
        state.copyWith(
          baseState: OrdersBaseState.loading,
          page: 1,
          hasReachedMax: false,
        ),
      );
    }

    try {
      final orders = await getOrdersUseCase(page: state.page, limit: 10);

      if (orders.isEmpty) {
        emit(
          state.copyWith(
            baseState: OrdersBaseState.success,
            hasReachedMax: true,
          ),
        );
        return;
      }

      final active = orders.where((order) => order.isActive).toList();
      final completed = orders.where((order) => !order.isActive).toList();

      if (isLoadMore) {
        emit(
          state.copyWith(
            baseState: OrdersBaseState.success,
            activeOrders: List.of(state.activeOrders)..addAll(active),
            completedOrders: List.of(state.completedOrders)..addAll(completed),
            page: state.page + 1,
          ),
        );
      } else {
        emit(
          state.copyWith(
            baseState: OrdersBaseState.success,
            activeOrders: active,
            completedOrders: completed,
            page: state.page + 1,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          baseState: OrdersBaseState.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void trackOrderTapped(String id) {
    emit(state.copyWith(
      sideEffect: OrdersSideEffect.navigateToTrack,
      selectedOrderId: id,
    ));
  }

  void reorderTapped(String id) {
    emit(state.copyWith(
      sideEffect: OrdersSideEffect.navigateToCart,
      selectedOrderId: id,
    ));
  }

  void resetSideEffect() {
    emit(state.copyWith(
      sideEffect: OrdersSideEffect.none,
      resetSelectedOrderId: true,
    ));
  }
}
