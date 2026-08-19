import 'dart:convert';

import 'package:flower_app/features/auth/data/model/user_dto.dart';
import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'data_dto.g.dart';

Datadto datadtoFromJson(String str) => Datadto.fromJson(json.decode(str));
String datadtoToJson(Datadto data) => json.encode(data.toJson());

@JsonSerializable()
class Datadto {
  @JsonKey(name: 'resetToken')
  String? resetToken;
  @JsonKey(name: 'expiresAtUtc')
  DateTime? expiresAtUtc;

  Datadto({this.resetToken, this.expiresAtUtc});
  factory Datadto.fromJson(Map<String, dynamic> json) => _$DatadtoFromJson(json);
  Map<String, dynamic> toJson() => _$DatadtoToJson(this);
  VerifyOtpEntity toEntity() => VerifyOtpEntity(resetToken: resetToken ?? '', expiresAtUtc: expiresAtUtc ?? DateTime.now());
}

@JsonSerializable()
class LoginDataDto {
  @JsonKey(name: 'accessToken')
  String? accessToken;
  @JsonKey(name: 'refreshToken')
  String? refreshToken;
  @JsonKey(name: 'expiresIn')
  int? expiresIn;
  @JsonKey(name: 'driverStatus')
  String? driverStatus;
  @JsonKey(name: 'user')
  UserDto? user;

  LoginDataDto({this.accessToken, this.refreshToken, this.expiresIn, this.driverStatus, this.user});
  factory LoginDataDto.fromJson(Map<String, dynamic> json) => _$LoginDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$LoginDataDtoToJson(this);
  LoginEntity toLoginEntity() => LoginEntity(accessToken: accessToken ?? '', refreshToken: refreshToken ?? '', expiresIn: expiresIn ?? 0, driverStatus: driverStatus ?? '', user: user?.toUserEntity());
}
