// import 'package:dio/dio.dart';
// import 'package:injectable/injectable.dart';
// import 'package:retrofit/error_logger.dart';
// import 'package:retrofit/http.dart';
//
// import '../../data/model/response/orders_response.dart';
// part 'orders_api_client.g.dart';
// @injectable
// @RestApi()
// abstract class OrdersApiClient{
//   @factoryMethod
//   factory OrdersApiClient(Dio dio, {String baseUrl}) = _OrdersApiClient;
//
//   @GET("/api/v1/orders/active")
//   Future<OrdersResponse> getActiveOrders();
//
//   @GET("/api/v1/orders/completed")
//   Future<OrdersResponse> getCompletedOrders();
//
// }
