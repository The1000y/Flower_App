import 'package:flower_app/core/constants/enums/order_status.dart';

OrderStatus orderStatusFromApi(String? value) {
  final normalized = (value ?? '').trim().toLowerCase().replaceAll('_', '').replaceAll(' ', '');

  switch (normalized) {
    case 'received':
    case 'confirmed':
    case 'placed':
    case 'pending':
      return OrderStatus.received;
    case 'preparing':
    case 'processing':
      return OrderStatus.preparing;
    case 'outfordelivery':
    case 'shipping':
      return OrderStatus.outForDelivery;
    case 'delivered':
    case 'completed':
      return OrderStatus.delivered;
    default:
      return OrderStatus.received;
  }
}
