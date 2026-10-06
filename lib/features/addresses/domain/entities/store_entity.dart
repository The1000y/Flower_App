import 'package:equatable/equatable.dart';

class StoreEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final String phoneNumber;
  final double latitude;
  final double longitude;
  final String openingTime;
  final String closingTime;

  const StoreEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.phoneNumber,
    required this.latitude,
    required this.longitude,
    required this.openingTime,
    required this.closingTime,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        address,
        phoneNumber,
        latitude,
        longitude,
        openingTime,
        closingTime,
      ];
}
