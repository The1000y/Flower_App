import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/orders/domain/use_case/get_orders_usecase.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_intent.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetOrdersUseCase getOrdersUseCase;

  OrdersCubit(this.getOrdersUseCase) : super(const OrdersState());

  void doIntent(OrdersIntent intent) {
    switch (intent) {
      case FetchOrdersIntent(:final isLoadMore):
        _fetchOrders(isLoadMore: isLoadMore);
      case TrackOrderTappedIntent(:final orderId):
        _trackOrderTapped(orderId);
      case ReorderTappedIntent(:final orderId):
        _reorderTapped(orderId);
      case ResetSideEffectIntent():
        _resetSideEffect();
    }
  }

  Future<void> _fetchOrders({bool isLoadMore = false}) async {
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

    final response = await getOrdersUseCase(page: state.page, limit: 10);

    switch (response) {
      case SuccessResponce(data: final result):
        final active = result.activeOrders;
        final completed = result.completedOrders;

        if (active.isEmpty && completed.isEmpty) {
          emit(
            state.copyWith(
              baseState: OrdersBaseState.success,
              hasReachedMax: true,
            ),
          );
          return;
        }

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

      case ErrorResponce(:final errorMessage):
        emit(
          state.copyWith(
            baseState: OrdersBaseState.error,
            errorMessage: errorMessage,
          ),
        );
    }
  }

  void _trackOrderTapped(String id) {
    emit(state.copyWith(
      sideEffect: OrdersSideEffect.navigateToTrack,
      selectedOrderId: id,
    ));
  }

  void _reorderTapped(String id) {
    emit(state.copyWith(
      sideEffect: OrdersSideEffect.navigateToCart,
      selectedOrderId: id,
    ));
  }

  void _resetSideEffect() {
    emit(state.copyWith(
      sideEffect: OrdersSideEffect.none,
      resetSelectedOrderId: true,
    ));
  }
}
