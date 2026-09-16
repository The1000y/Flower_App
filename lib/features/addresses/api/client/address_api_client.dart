import 'package:dio/dio.dart';
import 'package:flower_app/core/constants/api_strings/api_strings.dart';
import 'package:flower_app/features/addresses/data/model/request/add_address_request.dart';
import 'package:flower_app/features/addresses/data/model/request/update_address_request_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_list_response_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/address_response.dart';
import 'package:flower_app/features/addresses/data/model/responce/areas_response_dto.dart';
import 'package:flower_app/features/addresses/data/model/responce/nearest_store_response_dto.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

part 'address_api_client.g.dart';

@singleton
@RestApi()
abstract class AddressApiClient {
  @factoryMethod
  factory AddressApiClient(Dio dio) = _AddressApiClient;

  @GET(ApiStrings.areas)
  Future<AreasResponseDto> getAreas();

  @GET(ApiStrings.nearestStore)
  Future<NearestStoreResponseDto> getNearestStore(
    @Query('lat') double lat,
    @Query('lng') double lng,
  );

  @GET(ApiStrings.userAddresses)
  Future<AddressListResponseDto> getAddresses();

  @GET('${ApiStrings.userAddresses}/{addressId}')
  Future<AddressResponse> getAddressById(@Path('addressId') String addressId);

  @POST(ApiStrings.userAddresses)
  Future<AddressResponse> createAddress(@Body() AddAddressRequest request);

  @PATCH('${ApiStrings.userAddresses}/{addressId}/default')
  Future<AddressResponse> setDefaultAddress(
    @Path('addressId') String addressId,
  );

  @PUT('${ApiStrings.userAddresses}/{addressId}')
  Future<AddressResponse> updateAddress(
    @Path('addressId') String addressId,
    @Body() UpdateAddressRequestDto request,
  );

  @DELETE('${ApiStrings.userAddresses}/{addressId}')
  Future<HttpResponse<void>> deleteAddress(
    @Path('addressId') String addressId,
  );
}
