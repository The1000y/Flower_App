import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'login_request.g.dart';

LoginRequest loginRequestFromJson(String str) => LoginRequest.fromJson(json.decode(str));

String loginRequestToJson(LoginRequest data) => json.encode(data.toJson());

@JsonSerializable()
class LoginRequest {
    @JsonKey(name: "email")
    String? email;
    @JsonKey(name: "password")
    String? password;

    LoginRequest({
        this.email,
        this.password,
    });

    factory LoginRequest.fromJson(Map<String, dynamic> json) => _$LoginRequestFromJson(json);

    Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}