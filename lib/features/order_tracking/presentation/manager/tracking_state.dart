import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/order_tracking/domain/entities/tracking_entity.dart';

class TrackingState extends Equatable {
  final BaseState<TrackingEntity> trackingState;
  final String? orderId;
  final bool isWaitingForDriver;
  final bool isConfirmingDelivery;
  final String confirmDeliveryError;

  const TrackingState({
    this.trackingState = const BaseState<TrackingEntity>(),
    this.orderId,
    this.isWaitingForDriver = false,
    this.isConfirmingDelivery = false,
    this.confirmDeliveryError = '',
  });

  TrackingState copyWith({
    BaseState<TrackingEntity>? trackingState,
    String? orderId,
    bool? isWaitingForDriver,
    bool? isConfirmingDelivery,
    String? confirmDeliveryError,
  }) {
    return TrackingState(
      trackingState: trackingState ?? this.trackingState,
      orderId: orderId ?? this.orderId,
      isWaitingForDriver: isWaitingForDriver ?? this.isWaitingForDriver,
      isConfirmingDelivery: isConfirmingDelivery ?? this.isConfirmingDelivery,
      confirmDeliveryError: confirmDeliveryError ?? this.confirmDeliveryError,
    );
  }

  @override
  List<Object?> get props => [
    trackingState,
    orderId,
    isWaitingForDriver,
    isConfirmingDelivery,
    confirmDeliveryError,
  ];
}
