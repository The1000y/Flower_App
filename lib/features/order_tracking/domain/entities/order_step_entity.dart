import 'package:equatable/equatable.dart';

class OrderStepEntity extends Equatable {
  const OrderStepEntity({required this.title, this.dateTime});
  final String title;
  final DateTime? dateTime;

  @override
  List<Object?> get props => [title, dateTime];
}
