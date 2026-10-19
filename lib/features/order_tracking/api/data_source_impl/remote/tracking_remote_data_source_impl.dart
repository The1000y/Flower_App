import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/order_tracking/api/client/traking_api_client.dart';
import 'package:flower_app/features/order_tracking/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/order_tracking/data/model/tracking_dto.dart';
import 'package:flower_app/features/order_tracking/domain/exceptions/tracking_exception.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TrackingRemoteDataSource)
class TrackingRemoteDataSourceImpl implements TrackingRemoteDataSource {
  TrackingRemoteDataSourceImpl(this._client);

  final TrackingApiClient _client;

  @override
  Future<BaseResponce<TrackingDto>> getOrderTracking(String orderId) async {
    try {
      final response = await _client.getOrderTracking(orderId);
      return SuccessResponce<TrackingDto>(response);
    } on DioException catch (e) {
      final mapped = e.error;
      return ErrorResponce<TrackingDto>(
        mapped is TrackingException ? mapped : e,
      );
    } catch (e) {
      return ErrorResponce<TrackingDto>(Exception(e.toString()));
    }
  }

  @override
  Future<BaseResponce<void>> confirmOrderDelivery(String orderId) async {
    try {
      await _client.confirmOrderDelivery(orderId);
      return SuccessResponce<void>(null);
    } on DioException catch (e) {
      final mapped = e.error;
      return ErrorResponce<void>(mapped is TrackingException ? mapped : e);
    } catch (e) {
      return ErrorResponce<void>(Exception(e.toString()));
    }
  }
}
