// To parse this JSON data, do
//
//     final verifyotpresponse = verifyotpresponseFromJson(jsonString);

import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'verify_otp_response.g.dart';

VerifyOtpResponse verifyotpresponseFromJson(String str) => VerifyOtpResponse.fromJson(json.decode(str));

String verifyotpresponseToJson(VerifyOtpResponse data) => json.encode(data.toJson());

@JsonSerializable()
class VerifyOtpResponse {
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "errorCode")
    int? errorCode;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "data")
    Datadto? data;

    VerifyOtpResponse({
        this.isSuccess,
        this.errorCode,
        this.message,
        this.data,
    });

    factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => _$VerifyOtpResponseFromJson(json);

    Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}