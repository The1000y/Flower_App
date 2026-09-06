import 'package:dio/dio.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasions_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/routing/routes.dart';

part 'commerce_api_client.g.dart';

@singleton
@RestApi()
abstract class CommerceApiClient {
  @factoryMethod
  factory CommerceApiClient(Dio dio) = _CommerceApiClient;

  @GET(Routes.occasion)
  Future<OccasionsResponseDto> getOccasions();
}