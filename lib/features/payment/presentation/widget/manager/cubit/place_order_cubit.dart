import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flower_app/features/payment/domain/use_case/place_order_use_case.dart';
import 'package:flower_app/features/payment/presentation/widget/manager/cubit/place_order_event.dart';
import 'package:flower_app/features/payment/presentation/widget/manager/cubit/place_order_state.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class PlaceOrderCubit extends Cubit<PlaceOrderState> {
 final PlaceOrderUseCase _placeOrderUseCase;
  PlaceOrderCubit(this._placeOrderUseCase) : super(PlaceOrderState());

  void doEvent(PlaceOrderEvent event) {
    switch (event) {
      case PostPlaceOrderEvent():
        _placeOrder(event.placeOrderParam);
        break;
    }
  }

  Future<void> _placeOrder(PlaceOrderParam placeOrderParam) async {
    emit(
      state.copyWith(
        placeOrderState: state.placeOrderState.copyWith(isLoading: true),
      ),
    );
    final result = await _placeOrderUseCase.call(placeOrderParam);
    switch (result) {
      case SuccessResponce<PlaceOrderEntity>():
        emit(
          state.copyWith(
            placeOrderState: state.placeOrderState.copyWith(
              data: result.data,
              isLoading: false,
            ),
          ),
        );
      case ErrorResponce<PlaceOrderEntity>():
        emit(
          state.copyWith(
            placeOrderState: state.placeOrderState.copyWith(
              errorMessage: result.errorMessage,
              isLoading: false,
            ),
          ),
        );
    }
  }
}
