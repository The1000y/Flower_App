import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class StartTrackingUseCase {
  StartTrackingUseCase(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  Stream<BaseResponce<TrackingEntity>> call(String orderId) {
    return _trackingRepository.startTracking(orderId);
  }
}
