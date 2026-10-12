import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';

class TrackingState extends Equatable {
  final BaseState<TrackingEntity> trackingState;
  final String? orderId;

  const TrackingState({
    this.trackingState = const BaseState<TrackingEntity>(),
    this.orderId,
  });

  TrackingState copyWith({
    BaseState<TrackingEntity>? trackingState,
    String? orderId,
  }) {
    return TrackingState(
      trackingState: trackingState ?? this.trackingState,
      orderId: orderId ?? this.orderId,
    );
  }

  @override
  List<Object?> get props => [trackingState, orderId];
}
