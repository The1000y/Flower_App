import 'package:json_annotation/json_annotation.dart';
part 'reset_password_request_dto.g.dart';

@JsonSerializable()
class ResetPasswordRequestDto {
  @JsonKey(name: 'resetToken')
  final String resetToken;
  @JsonKey(name: 'newPassword')
  final String newPassword;
  @JsonKey(name: 'confirmPassword')
  final String confirmPassword;

  const ResetPasswordRequestDto({
    required this.resetToken,
    required this.newPassword,
    required this.confirmPassword,
  });

  factory ResetPasswordRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ResetPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ResetPasswordRequestDtoToJson(this);
}
