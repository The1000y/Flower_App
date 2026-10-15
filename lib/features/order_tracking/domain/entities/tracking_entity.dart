import 'package:equatable/equatable.dart';
import 'package:flower_app/features/order_tracking/domain/entities/driver_entity.dart';
import 'package:flower_app/features/order_tracking/domain/entities/location_entity.dart';
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

  bool get isCancelled => _normalizedStatus == 'cancelled';

  bool get isDelivered => _normalizedStatus == 'delivered';

  bool get isTerminal => isDelivered || isCancelled;

  bool get hasDriver => driver != null;

  bool get hasCurrentLocation => currentLocation != null;

  bool get isLocationStale => currentLocation?.isStale ?? false;

  bool get isAwaitingCustomerConfirmation =>
      awaitingCustomerConfirmation ?? false;

  String get _normalizedStatus => (status ?? '').trim().toLowerCase();

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
