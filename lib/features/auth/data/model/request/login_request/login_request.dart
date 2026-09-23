import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'login_request.g.dart';

LoginRequest loginRequestFromJson(String str) =>
    LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'password')
  String? password;
  @JsonKey(name: 'deviceId')
  String? deviceId;
  @JsonKey(name: 'fcmToken')
  String? fcmToken;

  LoginRequest({
    this.email,
    this.password,
    this.deviceId,
    this.fcmToken,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
