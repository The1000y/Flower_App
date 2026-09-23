import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';
@JsonSerializable()
class LoginResponse {
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "errorCode")
    int? errorCode;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "data")
    LoginDataDto? data;

    LoginResponse({
        this.isSuccess,
        this.errorCode,
        this.message,
        this.data,
    });

    factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);

    Map<String, dynamic> toJson() => _$LoginResponseToJson(this);

}