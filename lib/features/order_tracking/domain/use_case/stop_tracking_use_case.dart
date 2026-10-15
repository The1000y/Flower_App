import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class StopTrackingUseCase {
  StopTrackingUseCase(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  Future<void> call(String orderId) {
    return _trackingRepository.stopTracking(orderId);
  }
}
