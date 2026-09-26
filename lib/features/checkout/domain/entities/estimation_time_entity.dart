import 'package:equatable/equatable.dart';

class EstimationTimeEntity extends Equatable {
 final String estimatedDeliveryAt;

 const EstimationTimeEntity({
    required this.estimatedDeliveryAt,
  });

  @override
  List<Object?> get props => [estimatedDeliveryAt];
}
