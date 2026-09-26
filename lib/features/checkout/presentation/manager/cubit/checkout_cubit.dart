import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:flower_app/features/checkout/domain/use_cases/estimation_time_use_case.dart';
import 'package:flower_app/features/checkout/domain/use_cases/get_checkout_use_case.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final GetCheckoutUseCase _getCheckoutUseCase;
  final EstimationTimeUseCase _estimationTimeUseCase;
  CheckoutCubit(this._getCheckoutUseCase, this._estimationTimeUseCase)
    : super(CheckoutState());

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case GetCheckoutEvent():
        await _getCheckout();
        break;
      case GetEstimationTimeEvent():
        await _getEstimationTime(addressId: event.addressId);
        break;
      case SelectPaymentMethodEvent():
        _selectedPaymentMethod(event.paymentMethod);
        break;
      case ToggleGiftEvent():
        emit(state.copyWith(isGift: event.isGift));
        break;
      case ChangeGiftRecipientNameEvent():
        emit(state.copyWith(giftRecipientName: event.name));
      case ChangeGiftRecipientPhoneEvent():
        emit(state.copyWith(giftRecipientPhone: event.phone));
    }
  }

  Future<void> _getCheckout() async {
    emit(state.copyWith(checkoutDetailsState: BaseState(isLoading: true)));
    final result = await _getCheckoutUseCase.call();
    switch (result) {
      case SuccessResponce<CheckoutDetailsEntity>():
        emit(
          state.copyWith(
            estimationTimeState: BaseState<EstimationTimeEntity>(
              data: EstimationTimeEntity(
                estimatedDeliveryAt: result.data.estimatedDeliveryAt,
              ),
            ),
            checkoutDetailsState: BaseState<CheckoutDetailsEntity>(
              data: result.data,
              isLoading: false,
            ),
          ),
        );
      case ErrorResponce<CheckoutDetailsEntity>():
        emit(
          state.copyWith(
            checkoutDetailsState: BaseState(
              errorMessage: result.errorMessage,
              isLoading: false,
            ),
          ),
        );
    }
  }

  Future<void> _getEstimationTime({required String addressId}) async {
    emit(state.copyWith(estimationTimeState: BaseState(isLoading: true)));
    var result = await _estimationTimeUseCase.call(addressId: addressId);
    switch (result) {
      case SuccessResponce<EstimationTimeEntity>():
        return emit(
          state.copyWith(
            estimationTimeState: BaseState(data: result.data, isLoading: false),
          ),
        );
      case ErrorResponce<EstimationTimeEntity>():
        return emit(
          state.copyWith(
            estimationTimeState: BaseState(
              errorMessage: result.errorMessage,
              isLoading: false,
            ),
          ),
        );
    }
  }

  void _selectedPaymentMethod(String paymentMethod) =>
      emit(state.copyWith(selectedPaymentMethod: paymentMethod));
}
