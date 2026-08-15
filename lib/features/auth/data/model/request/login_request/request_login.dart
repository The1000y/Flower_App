import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
part 'request_login.g.dart';

RequestLogin requestLoginFromJson(String str) => RequestLogin.fromJson(json.decode(str));

String requestLoginToJson(RequestLogin data) => json.encode(data.toJson());

@JsonSerializable()
class RequestLogin {
    @JsonKey(name: "email")
    String? email;
    @JsonKey(name: "password")
    String? password;
   

    RequestLogin({
        this.email,
        this.password,
    });

    factory RequestLogin.fromJson(Map<String, dynamic> json) => _$RequestLoginFromJson(json);

    Map<String, dynamic> toJson() => _$RequestLoginToJson(this);
}
