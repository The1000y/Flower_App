import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'profile_api_client.g.dart';

@singleton
@RestApi()
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(ApiStrings.getProfile)
  Future<GetProfileResponseDto> getProfile();

  @PUT(ApiStrings.updateProfile)
  @MultiPart()
  Future<void> updateProfile(
      @Query('FullName') String fullName,
      @Query('Email') String email,
      @Query('Phone') String phone,
      @Query('Gender') String gender,
      @Part(name: 'Photo') MultipartFile? photo,
      );
}