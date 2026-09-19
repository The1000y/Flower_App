import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/use_cases/get_checkout_use_case.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_event.dart';
import 'package:flower_app/features/checkout/presentation/manager/cubit/checkout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class CheckoutCubit extends Cubit<CheckoutState> {
  final GetCheckoutUseCase _getCheckoutUseCase;
  CheckoutCubit(this._getCheckoutUseCase) : super(CheckoutState());

  Future<void> doEvent(CheckoutEvent event) async {
    switch (event) {
      case GetCheckoutEvent():
        await _getCheckout();
        break;
    }
  }

  Future<void> _getCheckout() async {
    emit(state.copyWith(checkoutDetailsState: BaseState(isLoading: true)));
    final result = await _getCheckoutUseCase.call();
    switch (result) {
      case SuccessResponce<CheckoutDetailsEntity>():
        emit(
          state.copyWith(
            checkoutDetailsState: BaseState(
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
}
