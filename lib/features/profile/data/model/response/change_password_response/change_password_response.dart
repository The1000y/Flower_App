import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'change_password_response.g.dart';

ChangePasswordResponse changePasswordResponseFromJson(String str) => ChangePasswordResponse.fromJson(json.decode(str));

String changePasswordResponseToJson(ChangePasswordResponse data) => json.encode(data.toJson());

@JsonSerializable()
class ChangePasswordResponse {
  @JsonKey(name: "data")
  final bool? data;
  @JsonKey(name: "isSuccess")
  final bool? isSuccess;
  @JsonKey(name: "message")
  final String? message;
  @JsonKey(name: "errorCode")
  final int? errorCode;

  ChangePasswordResponse({
    this.data,
    this.isSuccess,
    this.message,
    this.errorCode,
  });

  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) => _$ChangePasswordResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ChangePasswordResponseToJson(this);
}