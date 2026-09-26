import 'package:equatable/equatable.dart';

class ChangePasswordEntity extends Equatable {
  final bool? data;
  final bool? isSuccess;
  final String? message;
  final int? errorCode;


  const ChangePasswordEntity({
    this.data,
    this.isSuccess,
    this.message,
    this.errorCode,

  });

  @override
  List<Object?> get props => [
        data,
        isSuccess,
        message,
        errorCode,
      ];
}
