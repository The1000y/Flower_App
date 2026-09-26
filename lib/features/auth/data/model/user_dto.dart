import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'user_dto.g.dart';

String? userIdFromJson(dynamic value) => value?.toString();

@JsonSerializable()
class UserDto {
  @JsonKey(name: 'id', fromJson: userIdFromJson)
  String? id;
  @JsonKey(name: 'fullName')
  String? fullName;
  @JsonKey(name: 'email')
  String? email;
  @JsonKey(name: 'phoneNumber')
  String? phoneNumber;
  @JsonKey(name: 'gender')
  String? gender;
  @JsonKey(name: 'role')
  String? role;
  @JsonKey(name: 'photoUrl')
  String? photoUrl;
  @JsonKey(name: 'status')
  String? status;
  @JsonKey(name: 'isActive')
  bool? isActive;

  UserDto({
    this.id,
    this.fullName,
    this.email,
    this.phoneNumber,
    this.gender,
    this.role,
    this.photoUrl,
    this.status,
    this.isActive,
  });

  factory UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  Map<String, dynamic> toJson() => _$UserDtoToJson(this);

  UserEntity toUserEntity() {
    return UserEntity(
      id: id ?? '',
      fullName: fullName ?? '',
      email: email ?? '',
      phoneNumber: phoneNumber ?? '',
      gender: gender ?? '',
      role: role ?? '',
      status: status ?? (isActive == true ? 'Active' : ''),
    );
  }
}
