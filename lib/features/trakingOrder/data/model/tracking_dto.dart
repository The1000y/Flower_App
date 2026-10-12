import 'package:flower_app/features/trakingOrder/domain/entities/driver_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/location_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/tracking_entity.dart';
import 'package:flower_app/features/trakingOrder/domain/entities/user_address_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'tracking_dto.g.dart';

@JsonSerializable()
class TrackingDto {
  @JsonKey(name: 'data')
  final TrackingDataDto? data;
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'messageLocalized')
  final String? messageLocalized;
  @JsonKey(name: 'statusCode')
  final String? statusCode;

  TrackingDto({
    this.data,
    this.isSuccess,
    this.message,
    this.messageLocalized,
    this.statusCode,
  });

  factory TrackingDto.fromJson(Map<String, dynamic> json) =>
      _$TrackingDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDtoToJson(this);

  TrackingEntity? toEntity() => data?.toEntity();
}

@JsonSerializable()
class TrackingDataDto {
  @JsonKey(name: 'orderId')
  final String? orderId;
  @JsonKey(name: 'status')
  final String? status;
  @JsonKey(name: 'isLive')
  final bool? isLive;
  @JsonKey(name: 'driver')
  final DriverDto? driver;
  @JsonKey(name: 'currentLocation')
  final CurrentLocationDto? currentLocation;
  @JsonKey(name: 'userAddress')
  final UserAddressDto? userAddress;
  @JsonKey(name: 'estimatedDeliveryAt')
  final DateTime? estimatedDeliveryAt;
  @JsonKey(name: 'awaitingCustomerConfirmation')
  final bool? awaitingCustomerConfirmation;

  TrackingDataDto({
    this.orderId,
    this.status,
    this.isLive,
    this.driver,
    this.currentLocation,
    this.userAddress,
    this.estimatedDeliveryAt,
    this.awaitingCustomerConfirmation,
  });

  factory TrackingDataDto.fromJson(Map<String, dynamic> json) =>
      _$TrackingDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingDataDtoToJson(this);

  TrackingEntity toEntity() => TrackingEntity(
    orderId: orderId,
    status: status,
    isLive: isLive ?? false,
    driver: driver?.toEntity(),
    currentLocation: currentLocation?.toEntity(),
    userAddress: userAddress?.toEntity(),
    estimatedDeliveryAt: estimatedDeliveryAt,
    awaitingCustomerConfirmation: awaitingCustomerConfirmation,
  );
}

@JsonSerializable()
class DriverDto {
  @JsonKey(name: 'driverId')
  final String? driverId;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'photoUrl')
  final String? photoUrl;
  @JsonKey(name: 'phone')
  final String? phone;

  DriverDto({this.driverId, this.name, this.photoUrl, this.phone});

  factory DriverDto.fromJson(Map<String, dynamic> json) =>
      _$DriverDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DriverDtoToJson(this);

  DriverEntity toEntity() => DriverEntity(
    driverId: driverId,
    name: name,
    photoUrl: photoUrl,
    phone: phone,
  );
}

@JsonSerializable()
class CurrentLocationDto {
  @JsonKey(name: 'lat')
  final double? lat;
  @JsonKey(name: 'lng')
  final double? lng;
  @JsonKey(name: 'recordedAt')
  final DateTime? recordedAt;
  @JsonKey(name: 'isStale')
  final bool? isStale;

  CurrentLocationDto({this.lat, this.lng, this.recordedAt, this.isStale});

  factory CurrentLocationDto.fromJson(Map<String, dynamic> json) =>
      _$CurrentLocationDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CurrentLocationDtoToJson(this);

  LocationEntity toEntity() => LocationEntity(
    lat: lat,
    lng: lng,
    recordedAt: recordedAt,
    isStale: isStale,
  );
}

@JsonSerializable()
class UserAddressDto {
  @JsonKey(name: 'lat')
  final double? lat;
  @JsonKey(name: 'lng')
  final double? lng;
  @JsonKey(name: 'addressLine')
  final String? addressLine;

  UserAddressDto({this.lat, this.lng, this.addressLine});

  factory UserAddressDto.fromJson(Map<String, dynamic> json) =>
      _$UserAddressDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserAddressDtoToJson(this);

  UserAddressEntity toEntity() =>
      UserAddressEntity(lat: lat, lng: lng, addressLine: addressLine);
}
