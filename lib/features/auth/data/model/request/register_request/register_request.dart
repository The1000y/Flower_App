import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: "fullName")
  final String? fullName;
  @JsonKey(name: "email")
  final String? email;
  @JsonKey(name: "phoneNumber")
  final String? phoneNumber;
  @JsonKey(name: "gender")
  final int? gender;
  @JsonKey(name: "password")
  final String? password;
  @JsonKey(name: "confirmPassword")
  final String? confirmPassword;

  RegisterRequest({
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.password,
    this.confirmPassword,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => _$RegisterRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
  RegisterRequestEntity toregisterentityrequest(){
    return RegisterRequestEntity(fullName: fullName??"", email: email??"", phoneNumber: phoneNumber??"", gender: gender??0, password: password??"", confirmPassword: confirmPassword??"");


  }
}