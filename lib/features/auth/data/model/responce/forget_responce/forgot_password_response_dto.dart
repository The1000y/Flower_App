import 'package:flower_app/features/auth/domain/entities/forget_entity/forget_password_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'forgot_password_response_dto.g.dart';

@JsonSerializable()
class ForgotPasswordResponseDto {
  @JsonKey(name: 'data')
  final bool data;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'errorCode')
  final int errorCode;
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  ForgotPasswordResponseDto({
    required this.data,
    required this.message,
    required this.errorCode,
    required this.isSuccess,
  });
  ForgetPasswordEntity toDomain() {
    return ForgetPasswordEntity(isSuccess: isSuccess, message: message);
  }

  factory ForgotPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordResponseDtoToJson(this);
}
