import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';

import '../../../data/data_source/remote_data_source/remote_data_source.dart';
import '../../../data/model/tracking_dto.dart';
import '../../client/traking_api_client.dart';

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
      return ErrorResponce<TrackingDto>(e);
    } catch (e) {
      return ErrorResponce<TrackingDto>(Exception(e.toString()));
    }
  }
}
