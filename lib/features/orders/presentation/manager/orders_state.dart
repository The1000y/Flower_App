import 'dart:collection';
import 'package:equatable/equatable.dart';
import 'package:flower_app/features/orders/domain/entities/my_orders_entity.dart';

enum OrdersBaseState { initial, loading, success, error }
enum OrdersSideEffect { none, navigateToTrack, navigateToCart }

class OrdersState extends Equatable {
  final OrdersBaseState baseState;
  final OrdersSideEffect sideEffect;
  final String errorMessage;
  final int page;
  final bool hasReachedMax;
  final String? selectedOrderId;
  final List<OrderEntity> activeOrders;
  final List<OrderEntity> completedOrders;

  const OrdersState({
    this.baseState = OrdersBaseState.initial,
    this.sideEffect = OrdersSideEffect.none,
    this.errorMessage = '',
    this.page = 1,
    this.hasReachedMax = false,
    this.activeOrders = const [],
    this.completedOrders = const [],
    this.selectedOrderId,

  });

  OrdersState copyWith({
    OrdersBaseState? baseState,
    OrdersSideEffect? sideEffect,
    String? selectedOrderId,
    bool resetSelectedOrderId = false,
    String? errorMessage,
    int? page,
    bool? hasReachedMax,
    List<OrderEntity>? activeOrders,
    List<OrderEntity>? completedOrders,
  }) {
    return OrdersState(
      baseState: baseState ?? this.baseState,
      sideEffect: sideEffect ?? this.sideEffect,
      errorMessage: errorMessage ?? this.errorMessage,
      page: page ?? this.page,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedOrderId: resetSelectedOrderId ? null : (selectedOrderId ?? this.selectedOrderId),
      activeOrders: activeOrders != null ? UnmodifiableListView(activeOrders) : this.activeOrders,
      completedOrders: completedOrders != null ? UnmodifiableListView(completedOrders) : this.completedOrders,
    );
  }

  @override
  List<Object?> get props => [
        baseState,
        sideEffect,
        errorMessage,
        page,
        hasReachedMax,
        activeOrders,
        completedOrders,
        selectedOrderId,
      ];
}
