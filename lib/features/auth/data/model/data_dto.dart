// To parse this JSON data, do
//
//     final datadto = datadtoFromJson(jsonString);

import 'package:flower_app/features/auth/domain/entities/forget_entity/verify_oto_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'data_dto.g.dart';

Datadto datadtoFromJson(String str) => Datadto.fromJson(json.decode(str));

String datadtoToJson(Datadto data) => json.encode(data.toJson());

@JsonSerializable()
class Datadto {
  @JsonKey(name: "resetToken")
  String? resetToken;
  @JsonKey(name: "expiresAtUtc")
  DateTime? expiresAtUtc;

  Datadto({this.resetToken, this.expiresAtUtc});

  factory Datadto.fromJson(Map<String, dynamic> json) =>
      _$DatadtoFromJson(json);

  Map<String, dynamic> toJson() => _$DatadtoToJson(this);

  VerifyOtpEntity toEntity() =>
      VerifyOtpEntity(resetToken: resetToken ??"", expiresAtUtc: expiresAtUtc ?? DateTime.now()); 
}