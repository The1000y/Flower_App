import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/home/section_entity.dart';

part 'home_section_dto.g.dart';

@JsonSerializable()
class HomeSectionDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'type')
  final String type;

  @JsonKey(name: 'index')
  final int index;

  @JsonKey(name: 'isActive')
  final bool isActive;

  @JsonKey(name: 'title')
  final String? title;

  @JsonKey(name: 'occasionId')
  final int? occasionId;

  @JsonKey(name: 'categoryId')
  final int? categoryId;

  HomeSectionDto({
    required this.id,
    required this.type,
    required this.index,
    required this.isActive,
    this.title,
    this.occasionId,
    this.categoryId,
  });

  SectionEntity toDomain() {
    return SectionEntity(
      id: id,
      type: type,
      index: index,
      isActive: isActive,
      title: title ?? '',
      occasionId: occasionId,
      categoryId: categoryId,
    );
  }

  factory HomeSectionDto.fromJson(Map<String, dynamic> json) =>
      _$HomeSectionDtoFromJson(json);

  Map<String, dynamic> toJson() => _$HomeSectionDtoToJson(this);
}