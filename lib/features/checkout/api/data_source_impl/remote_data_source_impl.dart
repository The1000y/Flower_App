import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/checkout/api/client/checkout_api_client.dart';
import 'package:flower_app/features/checkout/data/data_source/remote_data_source.dart';
import 'package:flower_app/features/checkout/data/model/responce/checkout_details_dto.dart';
import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoteDataSource)
class RemoteDataSourceImpl implements RemoteDataSource {
  CheckoutApiClient checkoutApiClient;

  RemoteDataSourceImpl(this.checkoutApiClient);
  @override
  Future<BaseResponce<CheckoutDetailsDto>> getCheckoutDetails() async {
    try {
      final responce = await checkoutApiClient.getCheckoutDetails();
      return SuccessResponce<CheckoutDetailsDto>(responce.data ?? CheckoutDetailsDto());
    } on Exception catch (e) {
      return ErrorResponce<CheckoutDetailsDto>(e);
    }
  }

  @override
  Future<BaseResponce<EstimationTimeDto>> getEstimationTime({
    required String addressId,
  }) async {
    try {
      var responce = await checkoutApiClient.getEstimationTime(addressId);
      return SuccessResponce<EstimationTimeDto>(
        responce.data ?? EstimationTimeDto(),
      );
    } on Exception catch (e) {
      return ErrorResponce<EstimationTimeDto>(e);
    }
  }
}
