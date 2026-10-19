import 'package:flower_app/core/constants/enums/order_status.dart';

OrderStatus orderStatusFromApi(String? value) {
  final normalized = (value ?? '')
      .trim()
      .toLowerCase()
      .replaceAll('_', '')
      .replaceAll(' ', '');

  switch (normalized) {
    case 'placed':
    case 'received':
    case 'confirmed':
    case 'pending':
      return OrderStatus.received;
    case 'preparing':
      return OrderStatus.preparing;
    case 'pickedup':
      return OrderStatus.pickedUp;
    case 'outfordelivery':
      return OrderStatus.outForDelivery;
    case 'awaitingdeliveryconfirmation':
      return OrderStatus.awaitingDeliveryConfirmation;
    case 'delivered':
    case 'completed':
      return OrderStatus.delivered;
    case 'cancelled':
    case 'canceled':
      return OrderStatus.cancelled;
    default:
      return OrderStatus.received;
  }
}
