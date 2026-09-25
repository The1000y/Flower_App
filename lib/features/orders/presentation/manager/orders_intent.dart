import 'package:equatable/equatable.dart';

sealed class OrdersIntent extends Equatable {
  const OrdersIntent();

  @override
  List<Object?> get props => [];
}

class FetchOrdersIntent extends OrdersIntent {
  final bool isLoadMore;
  const FetchOrdersIntent({this.isLoadMore = false});

  @override
  List<Object?> get props => [isLoadMore];
}

class TrackOrderTappedIntent extends OrdersIntent {
  final String orderId;
  const TrackOrderTappedIntent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ReorderTappedIntent extends OrdersIntent {
  final String orderId;
  const ReorderTappedIntent(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class ResetSideEffectIntent extends OrdersIntent {
  const ResetSideEffectIntent();
}
