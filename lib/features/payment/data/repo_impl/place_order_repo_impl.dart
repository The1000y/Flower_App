import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/payment/data/data_source/remote_data_source.dart';
import 'package:flower_app/features/payment/data/model/request/place_order_request.dart';
import 'package:flower_app/features/payment/data/model/response/place_order_dto.dart';
import 'package:flower_app/features/payment/domain/entities/param/place_order_param.dart';
import 'package:flower_app/features/payment/domain/entities/place_order_entity.dart';
import 'package:flower_app/features/payment/domain/repo/place_order_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: PlaceOrderRepo)
class PlaceOrderRepoImpl implements PlaceOrderRepo {
  RemoteDataSource remoteDataSource;

  PlaceOrderRepoImpl({required this.remoteDataSource});
  @override
  Future<BaseResponce<PlaceOrderEntity>> palceOrder({
    required PlaceOrderParam placeOrderParam,
  }) async {
    var response = await remoteDataSource.placeOrder(
      placeOrderRequest: PlaceOrderRequest.fromParam(placeOrderParam),
    );
    switch (response) {
      case SuccessResponce<PlaceOrderDto>():
        return SuccessResponce(response.data.toEntity());

      case ErrorResponce<PlaceOrderDto>():
        return ErrorResponce(response.error);
    }
  }
}
