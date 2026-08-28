import 'package:dio/dio.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../constante/api_endpoints.dart';

part 'commerce_api_client.g.dart';

@singleton
@RestApi()
abstract class CommerceApiClient {
  @factoryMethod
  factory CommerceApiClient(Dio dio) = _CommerceApiClient;

  @GET(ApiEndpoints.occasion)
  Future<OccasionsResponseDto> getOccasions();
}