import 'package:json_annotation/json_annotation.dart';
part 'forgot_password_response_dto.g.dart';


@JsonSerializable()

class ForgotPasswordResponseDto {
@JsonKey(
  name:'data'
)
final String data;
@JsonKey(
  name:'message'
)
final String message;
@JsonKey(
  name:'errorCode'
)
final String errorCode;
@JsonKey(
  name:'isSuccess'
)
final String isSuccess;

  ForgotPasswordResponseDto({required this.data, required this.message, required this.errorCode, required this.isSuccess});
  factory ForgotPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ForgotPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ForgotPasswordResponseDtoToJson(this);
}

