import 'package:equatable/equatable.dart';
import 'package:flower_app/core/constants/enums/order_status.dart';
import 'package:flower_app/features/order_tracking/domain/entities/driver_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/location_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/order_status_mapper.dart';
import 'package:flower_app/features/order_tracking/domain/entities/user_address_entity.dart';

class TrackingEntity extends Equatable {
  final String? orderId;
  final String? status;
  final bool isLive;
  final DriverEntity? driver;
  final LocationEntity? currentLocation;
  final UserAddressEntity? userAddress;
  final DateTime? estimatedDeliveryAt;
  final bool? awaitingCustomerConfirmation;

  const TrackingEntity({
    this.orderId,
    this.status,
    this.isLive = false,
    this.driver,
    this.currentLocation,
    this.userAddress,
    this.estimatedDeliveryAt,
    this.awaitingCustomerConfirmation,
  });

  OrderStatus get _orderStatus => orderStatusFromApi(status);

  bool get isCancelled => _orderStatus == OrderStatus.cancelled;

  bool get isDelivered => _orderStatus == OrderStatus.delivered;

  bool get isTerminal => isDelivered || isCancelled;

  bool get hasDriver => driver != null;

  bool get hasCurrentLocation => currentLocation != null;

  bool get isLocationStale => currentLocation?.isStale ?? false;

  bool get isAwaitingCustomerConfirmation =>
      awaitingCustomerConfirmation ?? false;

  TrackingEntity copyWith({
    String? status,
    bool? awaitingCustomerConfirmation,
    String? orderId,
    bool? isLive,
    DriverEntity? driver,
    LocationEntity? currentLocation,
    UserAddressEntity? userAddress,
    DateTime? estimatedDeliveryAt,
  }) {
    return TrackingEntity(
      orderId: orderId ?? this.orderId,
      status: status ?? this.status,
      isLive: isLive ?? this.isLive,
      driver: driver ?? this.driver,
      currentLocation: currentLocation ?? this.currentLocation,
      userAddress: userAddress ?? this.userAddress,
      estimatedDeliveryAt: estimatedDeliveryAt ?? this.estimatedDeliveryAt,
      awaitingCustomerConfirmation:
          awaitingCustomerConfirmation ?? this.awaitingCustomerConfirmation,
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    status,
    isLive,
    driver,
    currentLocation,
    userAddress,
    estimatedDeliveryAt,
    awaitingCustomerConfirmation,
  ];
}
