import 'package:json_annotation/json_annotation.dart';

part 'refresh_token_response_dto.g.dart';

/// Response of `POST /auth/refresh`.
///
/// Verified against the live gateway, which answers with a flat body:
/// `{"accessToken":"<jwt>","refreshToken":"<new>","expiresAt":"<ISO-8601>"}`.
///
/// The gateway **rotates** the refresh token on every call, so a successful
/// refresh must persist [refreshToken] as well as [accessToken]; keeping the
/// old value would make the next refresh fail.
@JsonSerializable()
class RefreshTokenResponseDto {
  @JsonKey(name: 'accessToken')
  final String? accessToken;

  @JsonKey(name: 'refreshToken')
  final String? refreshToken;

  @JsonKey(name: 'expiresAt')
  final DateTime? expiresAt;

  const RefreshTokenResponseDto({
    this.accessToken,
    this.refreshToken,
    this.expiresAt,
  });

  /// A refresh only counts as successful when a usable access token came back.
  bool get isSuccessful =>
      accessToken != null && accessToken!.isNotEmpty;

  factory RefreshTokenResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$RefreshTokenResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RefreshTokenResponseDtoToJson(this);
}
