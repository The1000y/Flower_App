import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTrackingUseCase {
  GetTrackingUseCase(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  Future<BaseResponce<TrackingEntity>> call(String orderId) {
    return _trackingRepository.getTracking(orderId);
  }
}
