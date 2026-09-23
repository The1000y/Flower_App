import 'package:json_annotation/json_annotation.dart';
part 'reset_password_request_dto.g.dart';


@JsonSerializable()
class ResetPasswordRequestDto {
  @JsonKey(name: 'email')
  final String email;
  @JsonKey(name: 'resetCode')
  final String resetCode;
  @JsonKey(name: 'newPassword')
  final String newPassword;
  const ResetPasswordRequestDto({
    required this.email,
    required this.newPassword,
    required this.resetCode,
  });
   factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
