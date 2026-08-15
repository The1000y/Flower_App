import 'package:flower_app/features/auth/data/model/user_dto.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/login_entity.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'data_dto.g.dart';

@JsonSerializable()
class LoginDataDto {
  @JsonKey(name: "accessToken")
  String? accessToken;
  @JsonKey(name: "refreshToken")
  String? refreshToken;
  @JsonKey(name: "expiresIn")
  int? expiresIn;
  @JsonKey(name: "driverStatus")
  String? driverStatus;
  @JsonKey(name: "user")
  UserDto? user;

  LoginDataDto({
    this.accessToken,
    this.refreshToken,
    this.expiresIn,
    this.driverStatus,
    this.user,
  });

  factory LoginDataDto.fromJson(Map<String, dynamic> json) =>
      _$LoginDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$LoginDataDtoToJson(this);
  LoginEntity tologinEntity() {
    return LoginEntity(
      accessToken: accessToken ?? '',
      refreshToken: refreshToken ?? '',
      expiresIn: expiresIn ?? 0,
      driverStatus: driverStatus ?? '',
      user: user!.toUserEntity(),
    );
  }
}
