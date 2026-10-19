import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:flower_app/features/order_tracking/api/interceptor/tracking_error_interceptor.dart';
import 'package:flower_app/features/order_tracking/data/model/tracking_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'traking_api_client.g.dart';

@singleton
@RestApi()
abstract class TrackingApiClient {
  factory TrackingApiClient(Dio dio) = _TrackingApiClient;
  @factoryMethod
  static TrackingApiClient create(Dio appDio) {
    final trackingDio = Dio(appDio.options)
      ..httpClientAdapter = appDio.httpClientAdapter
      ..transformer = appDio.transformer
      ..interceptors.addAll(appDio.interceptors)
      ..interceptors.add(
        TrackingErrorInterceptor(),
      ); // last: runs after auth refresh
    return TrackingApiClient(trackingDio);
  }

  @GET(ApiStrings.orderTracking)
  Future<TrackingDto> getOrderTracking(
    @Path(AppStrings.orderId) String orderId,
  );

  @POST(ApiStrings.confirmOrderDelivery)
  Future<void> confirmOrderDelivery(@Path(AppStrings.orderId) String orderId);
}
