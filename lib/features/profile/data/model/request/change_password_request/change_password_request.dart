import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'change_password_request.g.dart';

ChangePasswordRequest changePasswordRequestFromJson(String str) => ChangePasswordRequest.fromJson(json.decode(str));

String changePasswordRequestToJson(ChangePasswordRequest data) => json.encode(data.toJson());

@JsonSerializable()
class ChangePasswordRequest {
@JsonKey(name: "currentPassword")
final String? currentPassword;
@JsonKey(name: "newPassword")
final String? newPassword;
@JsonKey(name: "confirmNewPassword")
final String? confirmNewPassword;

ChangePasswordRequest({
this.currentPassword,
this.newPassword,
this.confirmNewPassword,
});

factory ChangePasswordRequest.fromJson(Map<String, dynamic> json) => _$ChangePasswordRequestFromJson(json);

Map<String, dynamic> toJson() => _$ChangePasswordRequestToJson(this);
}