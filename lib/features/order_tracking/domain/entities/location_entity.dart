import 'package:equatable/equatable.dart';

class LocationEntity extends Equatable {
  final double? lat;
  final double? lng;
  final DateTime? recordedAt;
  final bool? isStale;

  const LocationEntity({this.lat, this.lng, this.recordedAt, this.isStale});

  @override
  List<Object?> get props => [lat, lng, recordedAt, isStale];
}
