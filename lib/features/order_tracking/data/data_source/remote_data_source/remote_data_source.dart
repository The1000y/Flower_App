import 'package:flower_app/config/base/base_responce.dart';

import '../../model/tracking_dto.dart';

abstract interface class TrackingRemoteDataSource {
  Future<BaseResponce<TrackingDto>> getOrderTracking(String orderId);
}
