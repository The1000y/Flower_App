import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/checkout/domain/entities/checkout_details_entity.dart';
import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';

class CheckoutState extends Equatable {
  final BaseState<CheckoutDetailsEntity> checkoutDetailsState;
  final BaseState<EstimationTimeEntity> estimationTimeState;
  final String selectedPaymentMethod;
  final bool isGift;
  final String giftRecipientName;
  final String giftRecipientPhone;

  const CheckoutState({
    this.giftRecipientName = '',
    this.giftRecipientPhone = '',
    this.selectedPaymentMethod = '', 
    this.estimationTimeState = const BaseState(isLoading: true),
    this.checkoutDetailsState = const BaseState(isLoading: true),
    this.isGift = false,
  });

  CheckoutState copyWith({
    String? giftRecipientName,
    String? giftRecipientPhone,
    BaseState<EstimationTimeEntity>? estimationTimeState,
    BaseState<CheckoutDetailsEntity>? checkoutDetailsState,
    String? selectedPaymentMethod,
    bool? isGift,
  }) {
    return CheckoutState(
      giftRecipientName: giftRecipientName ?? this.giftRecipientName,
      giftRecipientPhone: giftRecipientPhone ?? this.giftRecipientPhone,
      estimationTimeState: estimationTimeState ?? this.estimationTimeState,
      checkoutDetailsState: checkoutDetailsState ?? this.checkoutDetailsState,
      selectedPaymentMethod:
          selectedPaymentMethod ?? this.selectedPaymentMethod,
      isGift: isGift ?? this.isGift,
    );
  }

  @override
  List<Object?> get props => [
    checkoutDetailsState,
    estimationTimeState,
    selectedPaymentMethod,
    isGift,
    giftRecipientName,
    giftRecipientPhone,
  ];
}
