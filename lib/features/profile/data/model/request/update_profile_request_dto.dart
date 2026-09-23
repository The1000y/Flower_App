import 'dart:io';

import 'package:dio/dio.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../domain/entities/profile_entity.dart';

part 'update_profile_request_dto.g.dart';

@JsonSerializable(createFactory: false)
class UpdateProfileRequestDto {
  @JsonKey(name: 'FullName')
  final String fullName;

  @JsonKey(name: 'Email')
  final String email;

  @JsonKey(name: 'Phone')
  final String phone;

  @JsonKey(name: 'Gender')
  final String gender;

  // Sent as the multipart "Photo" part, not as a query parameter
  @JsonKey(includeToJson: false)
  final MultipartFile? photo;

  UpdateProfileRequestDto({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.gender,
    this.photo,
  });

  factory UpdateProfileRequestDto.fromDomain(ProfileEntity entity) {
    return UpdateProfileRequestDto(
      fullName: '${entity.firstName} ${entity.lastName}'.trim(),
      email: entity.email,
      phone: entity.phoneNumber,
      gender: entity.gender,
      photo: _toMultipart(entity.photoUrl),
    );
  }

  // Upload only a newly picked local file; a server photo means "unchanged".
  static MultipartFile? _toMultipart(String? path) {
    if (path == null || path.isEmpty || !File(path).existsSync()) return null;
    return MultipartFile.fromFileSync(
      path,
      filename: path.split(RegExp(r'[\\/]')).last,
    );
  }

  Map<String, dynamic> toJson() => _$UpdateProfileRequestDtoToJson(this);
}