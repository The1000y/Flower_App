
import 'package:flower_app/features/auth/data/model/data_dto.dart';
import 'package:flower_app/features/auth/data/model/user_dto.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response_login.g.dart';
@JsonSerializable()
class ResponseLogin {
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "errorCode")
    int? errorCode;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "data")
    LoginDataDto? data;

    ResponseLogin({
        this.isSuccess,
        this.errorCode,
        this.message,
        this.data,
    });

    factory ResponseLogin.fromJson(Map<String, dynamic> json) => _$ResponseLoginFromJson(json);

    Map<String, dynamic> toJson() => _$ResponseLoginToJson(this);

   
}
