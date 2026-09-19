import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/register_entity/register_entity.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;
  @JsonKey(name: 'errorCode')
  final int? errorCode;
  @JsonKey(name: 'message')
  final String? message;
  @JsonKey(name: 'data')
  final bool? data;

  RegisterResponse({this.isSuccess, this.errorCode, this.message, this.data});

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('id') && !json.containsKey('data')) {
      final isSuccess = json['isSuccess'] == true;
      return RegisterResponse(
        isSuccess: isSuccess,
        errorCode: isSuccess ? 200 : (json['errorCode'] as num?)?.toInt(),
        message: isSuccess
            ? 'Registration successful'
            : json['error']?.toString() ?? json['message']?.toString(),
        data: isSuccess,
      );
    }
    return _$RegisterResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$RegisterResponseToJson(this);

  RegisterEntity toRegisterEntity() {
    return RegisterEntity(
      isSuccess: isSuccess ?? false,
      errorCode: errorCode ?? 0,
      message: message ?? 'entity null',
      data: data ?? false,
    );
  }
}
