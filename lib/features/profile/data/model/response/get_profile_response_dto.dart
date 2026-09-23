import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/profile_entity.dart';

part 'get_profile_response_dto.g.dart';

@JsonSerializable()
class GetProfileResponseDto {
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? photoUrl;

  GetProfileResponseDto({
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.photoUrl,
  });

  factory GetProfileResponseDto.fromJson(Map<String, dynamic> json) =>
      _$GetProfileResponseDtoFromJson(json);

  ProfileEntity toDomain() {
    final parts = (fullName ?? '').trim().split(RegExp(r'\s+'));
    final firstName = parts.first.isNotEmpty ? parts.first : '';
    final lastName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

    return ProfileEntity(
      firstName: firstName,
      lastName: lastName,
      email: email ?? '',
      phoneNumber: phone ?? '',
      gender: gender ?? '',
      photoUrl: photoUrl,
    );
  }
}