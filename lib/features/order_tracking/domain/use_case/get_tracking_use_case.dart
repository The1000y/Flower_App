import 'package:flower_app/config/base/base_responce.dart';
import 'package:injectable/injectable.dart';

import '../entities/tracking_entity.dart';
import '../repo/tracking_repository.dart';

@injectable
class GetTrackingUseCase {
  GetTrackingUseCase(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  Future<BaseResponce<TrackingEntity>> call(String orderId) {
    return _trackingRepository.getTracking(orderId);
  }
}
