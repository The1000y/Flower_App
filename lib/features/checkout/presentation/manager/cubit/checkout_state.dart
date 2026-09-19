import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';

class CheckoutState extends Equatable {
  final BaseState<CheckoutDetailsEntity> checkoutDetailsState;
  const CheckoutState({
    this.checkoutDetailsState = const BaseState(isLoading: true),
  });

  CheckoutState copyWith({
    BaseState<CheckoutDetailsEntity>? checkoutDetailsState,
  }) {
    return CheckoutState(
      checkoutDetailsState: checkoutDetailsState ?? this.checkoutDetailsState,
    );
  }

  @override
  List<Object?> get props => [checkoutDetailsState];
}
