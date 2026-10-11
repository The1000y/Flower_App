import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';

sealed class PlaceOrderEvent {}

class PostPlaceOrderEvent extends PlaceOrderEvent {
  final PlaceOrderParam placeOrderParam;
  PostPlaceOrderEvent({required this.placeOrderParam});
}
