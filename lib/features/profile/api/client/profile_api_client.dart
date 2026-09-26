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
      @Query(ApiStrings.fullNameKey) String fullName,
      @Query(ApiStrings.emailKey) String email,
      @Query(ApiStrings.phoneKey) String phone,
      @Query(ApiStrings.genderKey) String gender,
      @Part(name: ApiStrings.photoKey) MultipartFile? photo,
      );
}