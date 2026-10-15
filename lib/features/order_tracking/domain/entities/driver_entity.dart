import 'package:equatable/equatable.dart';

class DriverEntity extends Equatable {
  final String? driverId;
  final String? name;
  final String? photoUrl;
  final String? phone;

  const DriverEntity({this.driverId, this.name, this.photoUrl, this.phone});

  @override
  List<Object?> get props => [driverId, name, photoUrl, phone];
}
