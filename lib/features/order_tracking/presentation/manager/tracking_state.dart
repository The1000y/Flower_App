import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';

class TrackingState extends Equatable {
  final BaseState<TrackingEntity> trackingState;
  final String? orderId;
  final bool isWaitingForDriver;

  const TrackingState({
    this.trackingState = const BaseState<TrackingEntity>(),
    this.orderId,
    this.isWaitingForDriver = false,
  });

  TrackingState copyWith({
    BaseState<TrackingEntity>? trackingState,
    String? orderId,
    bool? isWaitingForDriver,
  }) {
    return TrackingState(
      trackingState: trackingState ?? this.trackingState,
      orderId: orderId ?? this.orderId,
      isWaitingForDriver: isWaitingForDriver ?? this.isWaitingForDriver,
    );
  }

  @override
  List<Object?> get props => [trackingState, orderId, isWaitingForDriver];
}
