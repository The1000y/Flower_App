import 'package:equatable/equatable.dart';

class OrderStepEntity extends Equatable {
  final String title;
  final DateTime? dateTime;

  const OrderStepEntity({required this.title, this.dateTime});

  @override
  List<Object?> get props => [title, dateTime];
}
