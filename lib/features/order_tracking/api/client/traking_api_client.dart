import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/core/constants/app_strings/app_strings.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../data/model/tracking_dto.dart';

part 'traking_api_client.g.dart';

@singleton
@RestApi()
abstract class TrackingApiClient {
  @factoryMethod
  factory TrackingApiClient(Dio dio) = _TrackingApiClient;

  @GET(ApiStrings.orderTracking)
  Future<TrackingDto> getOrderTracking(
    @Path(AppStrings.orderId) String orderId,
  );
}
