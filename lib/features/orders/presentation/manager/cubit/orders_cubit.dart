import 'package:flower_app/features/orders/domain/use_case/get_active_orders_usecase.dart';
import 'package:flower_app/features/orders/domain/use_case/get_completed_orders_usecase.dart';
import 'package:flower_app/features/orders/presentation/manager/orders_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class OrdersCubit extends Cubit<OrdersState> {
  final GetActiveOrdersUseCase getActiveOrdersUseCase;
  final GetCompletedOrdersUseCase getCompletedOrdersUseCase;

  OrdersCubit(this.getActiveOrdersUseCase, this.getCompletedOrdersUseCase)
    : super(OrdersInitial());

  fetchOrders() async {
    emit(OrdersLoading());
    final active = await getActiveOrdersUseCase();
    final completed = await getCompletedOrdersUseCase();
    emit(OrdersSuccess(activeOrders: active, completedOrders: completed));
  }
}
