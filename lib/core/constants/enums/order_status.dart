enum OrderStatus {
  received,
  preparing,
  outForDelivery,
  delivered;

  static OrderStatus fromStatus(String? status) {
    switch ((status ?? '').trim().toLowerCase()) {
      case 'received':
        return OrderStatus.received;
      case 'preparing':
      case 'prepared':
        return OrderStatus.preparing;
      case 'outfor_delivery':
      case 'out_for_delivery':
      case 'out for delivery':
      case 'outfordelivery':
        return OrderStatus.outForDelivery;
      case 'delivered':
        return OrderStatus.delivered;
      default:
        return OrderStatus.received;
    }
  }
}