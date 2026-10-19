import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/order_tracking/domain/repo/tracking_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class ConfirmOrderDeliveryUseCase {
  ConfirmOrderDeliveryUseCase(this._trackingRepository);

  final TrackingRepository _trackingRepository;

  Future<BaseResponce<void>> call(String orderId) =>
      _trackingRepository.confirmDelivery(orderId);
}
