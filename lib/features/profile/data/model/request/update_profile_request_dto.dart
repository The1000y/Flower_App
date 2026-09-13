import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/profile_entity.dart';

part 'update_profile_request_dto.g.dart';

@JsonSerializable()
class UpdateProfileRequestDto {
  final String fullName;
  final String email;
  final String phoneNumber;
  final String gender;
  final String? photoUrl;

  UpdateProfileRequestDto({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.gender,
    this.photoUrl,
  });

  factory UpdateProfileRequestDto.fromDomain(ProfileEntity entity) {
    return UpdateProfileRequestDto(
      fullName: '${entity.firstName} ${entity.lastName}'.trim(),
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      gender: entity.gender,
      photoUrl: entity.photoUrl,
    );
  }

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}