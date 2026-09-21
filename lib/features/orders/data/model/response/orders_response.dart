// To parse this JSON data, do
//
//     final ordersResponse = ordersResponseFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';


part 'orders_response.g.dart';



@JsonSerializable()
class OrdersResponse {
  @JsonKey(name: "message")
  final String message;
  @JsonKey(name: "data")
  final List<OrderDto> data;

  OrdersResponse({
    required this.message,
    required this.data,
  });

  factory OrdersResponse.fromJson(Map<String, dynamic> json) => _$OrdersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersResponseToJson(this);
}

@JsonSerializable()
class OrderDto {
  @JsonKey(name: "order_id")
  final String orderId;
  @JsonKey(name: "order_title")
  final String orderTitle;
  @JsonKey(name: "total_price")
  final String totalPrice;
  @JsonKey(name: "delivery_date")
  final String deliveryDate;
  @JsonKey(name: "is_active")
  final bool isActive;
  @JsonKey(name: "cover_image")
  final String coverImage;

  OrderDto({
    required this.orderId,
    required this.orderTitle,
    required this.totalPrice,
    required this.deliveryDate,
    required this.isActive,
    required this.coverImage,
  });

  factory OrderDto.fromJson(Map<String, dynamic> json) => _$OrderDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}
