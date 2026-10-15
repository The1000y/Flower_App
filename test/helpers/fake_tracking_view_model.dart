import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/get_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/start_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/domain/use_case/stop_tracking_use_case.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_state.dart';
import 'package:flower_app/features/order_tracking/presentation/manager/tracking_view_model.dart';

import '../features/trakingOrder/tracking_mocks.dart';

class FakeTrackingViewModel extends TrackingViewModel {
  FakeTrackingViewModel()
    : super(
        GetTrackingUseCase(MockTrackingRepository()),
        StartTrackingUseCase(MockTrackingRepository()),
        StopTrackingUseCase(MockTrackingRepository()),
      );

  void emitLoading() {
    emit(const TrackingState(trackingState: BaseState<TrackingEntity>(isLoading: true)));
  }

  void emitTracking(TrackingEntity entity) {
    emit(TrackingState(trackingState: BaseState<TrackingEntity>(data: entity)));
  }

  void emitError(String message) {
    emit(
      TrackingState(
        trackingState: BaseState<TrackingEntity>(errorMessage: message),
      ),
    );
  }
}
