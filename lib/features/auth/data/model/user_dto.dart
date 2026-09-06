import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_dto.g.dart';

@JsonSerializable()
class UserDto {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "fullName")
  String? fullName;
  @JsonKey(name: "email")
  String? email;
  @JsonKey(name: "phoneNumber")
  String? phoneNumber;
  @JsonKey(name: "gender")
  String? gender;
  @JsonKey(name: "role")
  String? role;
  @JsonKey(name: "photoUrl")
  String? photoUrl;
  @JsonKey(name: "status")
  String? status;

  UserDto({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.role,
    this.photoUrl,
    this.status,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
  UserEntity toUserEntity() {
    return UserEntity(
      id: id ?? 0,
      fullName: fullName ?? "",
      email: email ?? "",
      phoneNumber: phoneNumber ?? '',
      gender: gender ?? '',
      role: role ?? "",
      status: status ?? '',
    );
  }
}
