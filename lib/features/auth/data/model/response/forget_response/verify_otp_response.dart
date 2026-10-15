import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'verify_otp_response.g.dart';

VerifyOtpResponse verifyotpresponseFromJson(String str) =>
    VerifyOtpResponse.fromJson(json.decode(str));

String verifyotpresponseToJson(VerifyOtpResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class VerifyOtpResponse {
  @JsonKey(name: 'isSuccess')
  bool? isSuccess;
  @JsonKey(name: 'errorCode')
  int? errorCode;
  @JsonKey(name: 'message')
  String? message;
  @JsonKey(name: 'data')
  Datadto? data;

  VerifyOtpResponse({this.isSuccess, this.errorCode, this.message, this.data});

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('value')) {
      final value = json['value'];
      final data = value is Map<String, dynamic>
          ? Datadto.fromJson(value)
          : null;
      return VerifyOtpResponse(
        isSuccess: json['isSuccess'] == true,
        errorCode: json['isSuccess'] == true ? 0 : 400,
        message:
            json['error']?.toString() ??
            (json['isSuccess'] == true
                ? 'Operation completed successfully.'
                : 'Invalid OTP or email'),
        data: data,
      );
    }
    if (json.containsKey('resetToken') || json.containsKey('token')) {
      return VerifyOtpResponse(
        isSuccess: true,
        errorCode: 0,
        message: 'Operation completed successfully.',
        data: Datadto.fromJson(json),
      );
    }
    return _$VerifyOtpResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$VerifyOtpResponseToJson(this);
}
