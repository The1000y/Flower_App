import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/model/response/orders_response.dart';

part 'orders_api_client.g.dart';

@singleton
@RestApi()
abstract class OrdersApiClient {
  @factoryMethod
  factory OrdersApiClient(Dio dio) = _OrdersApiClient;

  @GET(ApiStrings.ordersEndpoint)
  Future<OrdersResponse> getOrders(
    @Query("page") int page,
    @Query("limit") int limit,
  );
}