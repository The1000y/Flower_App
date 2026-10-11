import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/features/trakingOrder/data/model/tracking_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'traking_api_client.g.dart';

@singleton
@RestApi()
abstract class TrackingApiClient {
  @factoryMethod
  factory TrackingApiClient(Dio dio) = _TrackingApiClient;

  @GET("${ApiStrings.orderTraking}/{orderId}/tracking")
  Future<TrackingDto> getOrderTracking(@Path('orderId') String orderId);
}
