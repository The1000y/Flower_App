import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_request_dto.g.dart';

/// Body of `POST /auth/refresh`.
///
/// The backend validates a single `token` field holding the refresh token;
/// an empty body is rejected with
/// `{"errors":{"Token":["Refresh token is required."]}}`.
@JsonSerializable()
class RefreshTokenRequestDto {
  @JsonKey(name: 'token')
  final String token;

  const RefreshTokenRequestDto({required this.token});

  factory RefreshTokenRequestDto.fromJson(
    Map<String, dynamic> json,
  ) => _$RefreshTokenRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenRequestDtoToJson(this);
}
