import 'package:flower_app/features/auth/domain/entities/forget_entity/reset_passsword_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'reset_password_response_dto.g.dart';


@JsonSerializable()
class ResetPasswordResponseDto {
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
final bool isSuccess;

ResetPassswordEntity toDomain() {
    return ResetPassswordEntity(isSuccess: isSuccess, message: message);
  }
  ResetPasswordResponseDto({required this.data, required this.message, required this.errorCode, required this.isSuccess});
  factory ResetPasswordResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordResponseDtoToJson(this);
}