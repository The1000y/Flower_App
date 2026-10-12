import 'package:injectable/injectable.dart';

import '../repo/tracking_repository.dart';

@injectable
class StopTrackingUseCase {
  StopTrackingUseCase(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  Future<void> call(String orderId) {
    return _trackingRepository.stopTracking(orderId);
  }
}
