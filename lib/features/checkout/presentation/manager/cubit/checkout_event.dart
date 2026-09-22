import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';

sealed class CheckoutEvent {}

class GetCheckoutEvent extends CheckoutEvent {}

class GetEstimationTimeEvent extends CheckoutEvent {
  final String addressId;
  GetEstimationTimeEvent({required this.addressId});
}

class SelectPaymentMethodEvent extends CheckoutEvent {
  final CheckoutPaymentMethod paymentMethod;

  SelectPaymentMethodEvent({required this.paymentMethod});
}
class ToggleGiftEvent extends CheckoutEvent{
  final bool isGift;
  ToggleGiftEvent({required this.isGift});
}
class ChangeGiftRecipientNameEvent  extends CheckoutEvent{
  final String name;
  ChangeGiftRecipientNameEvent({required this.name});
}
class ChangeGiftRecipientPhoneEvent extends CheckoutEvent{
  final String phone;
  ChangeGiftRecipientPhoneEvent({required this.phone});
}


