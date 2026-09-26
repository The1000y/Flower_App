import 'package:json_annotation/json_annotation.dart';

part 'forgot_password_request_dto.g.dart';

@JsonSerializable()
class ForgotPasswordRequestDto {
  @JsonKey(name: 'email')
  final String email;

  const ForgotPasswordRequestDto({
    required this.email,
  });

  factory ForgotPasswordRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ForgotPasswordRequestDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ForgotPasswordRequestDtoToJson(this);
}