import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/api/client/payment_api_client.dart';
import 'package:flower_app/features/payment/data/data_source/remote_data_source.dart';
import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: RemoteDataSource)
class PlaceOrderDataSourceImpl implements RemoteDataSource {
  PaymentApiClient paymentApiClient;

  PlaceOrderDataSourceImpl(this.paymentApiClient);

  @override
  Future<BaseResponce<PlaceOrderDto>> placeOrder({
    required PlaceOrderRequest placeOrderRequest,
  }) async {
    try {
      final response = await paymentApiClient.placeOrder(placeOrderRequest);
      return SuccessResponce<PlaceOrderDto>(response.data ?? PlaceOrderDto());
    } on Exception catch (e) {
      return ErrorResponce(e);
    }
  }
}
