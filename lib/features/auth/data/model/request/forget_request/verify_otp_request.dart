// To parse this JSON data, do
//
//     final verifyotprequest = verifyotprequestFromJson(jsonString);

import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'verify_otp_request.g.dart';

VerifyOtpRequest verifyotprequestFromJson(String str) => VerifyOtpRequest.fromJson(json.decode(str));

String verifyotprequestToJson(VerifyOtpRequest data) => json.encode(data.toJson());

@JsonSerializable()
class VerifyOtpRequest {
    @JsonKey(name: "email")
    String? email;
    @JsonKey(name: "otp")
    String? otp;

    VerifyOtpRequest({
        this.email,
        this.otp,
    });

    factory VerifyOtpRequest.fromJson(Map<String, dynamic> json) => _$VerifyOtpRequestFromJson(json);

    Map<String, dynamic> toJson() => _$VerifyOtpRequestToJson(this);
}