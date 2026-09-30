import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';

import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_response.dart';

import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'payment_api_client.g.dart';

@singleton
@RestApi()
abstract class PaymentApiClient {
  @factoryMethod
  factory PaymentApiClient(Dio dio) = _PaymentApiClient;

   @POST(ApiStrings.placeOrder)
  Future<PlaceOrderResponse> placeOrder(@Body() PlaceOrderRequest placeOrderRequest);
  
}
