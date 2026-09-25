import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

enum OrderSuccessAction { navigateToHome, navigateToTrackOrder }

class OrderSuccessState extends Equatable {
  final String? orderId;
  final OrderSuccessAction? action;

  const OrderSuccessState({this.orderId, this.action});

  OrderSuccessState copyWith({String? orderId, OrderSuccessAction? action}) {
    return OrderSuccessState(
      orderId: orderId ?? this.orderId,
      action: action,
    );
  }

  @override
  List<Object?> get props => [orderId, action];
}

class OrderSuccessCubit extends Cubit<OrderSuccessState> {
  OrderSuccessCubit({String? orderId})
      : super(OrderSuccessState(orderId: orderId));

  void onHomeTap() {
    emit(state.copyWith(action: OrderSuccessAction.navigateToHome));
  }

  void onTrackOrderTap() {
    emit(state.copyWith(action: OrderSuccessAction.navigateToTrackOrder));
  }
}