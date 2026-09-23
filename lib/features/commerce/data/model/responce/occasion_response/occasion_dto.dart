import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';

part 'occasion_dto.g.dart';

@JsonSerializable()
class OccasionDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'imageUrl')
  final String imageUrl;

  OccasionDto({
    required this.id,
    required this.name,
    required this.imageUrl,
  });

  OccasionEntity toDomain() {
    return OccasionEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
    );
  }

  factory OccasionDto.fromJson(Map<String, dynamic> json) =>
      _$OccasionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionDtoToJson(this);
}