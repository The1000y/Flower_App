  import 'package:flower_app/features/checkout/presentation/manager/checkout_payment_method.dart';

  class PlaceOrderParam {
    final String addressId;
    final CheckoutPaymentMethod paymentMethod;
    final String? notes;
    final bool isGift;
    final String? giftRecipientName;
    final String? giftRecipientPhone;

    const PlaceOrderParam({
      required this.addressId,
      required this.paymentMethod,
      this.notes,
      this.isGift = false,
      this.giftRecipientName,
      this.giftRecipientPhone,
    });
  }