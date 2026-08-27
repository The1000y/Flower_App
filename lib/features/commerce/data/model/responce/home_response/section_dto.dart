// To parse this JSON data, do
//
//     final sectionDto = sectionDtoFromJson(jsonString);

import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'section_dto.g.dart';

SectionType? _stringToSectionType(String? type) {
  if (type == null) return null;
  switch (type.toLowerCase()) {
    case 'bestseller':
      return SectionType.bestSeller;
    case 'category':
    case 'categories':
      return SectionType.category;
    case 'occasion':
    case 'occasions':
      return SectionType.occasion;
    default:
      return null;
  }
}

SectionDto sectionDtoFromJson(String str) => SectionDto.fromJson(json.decode(str));

String sectionDtoToJson(SectionDto data) => json.encode(data.toJson());

@JsonSerializable()
class SectionDto {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "type")
    String? type;
    @JsonKey(name: "index")
    int? index;
    @JsonKey(name: "isActive")
    bool? isActive;
    @JsonKey(name: "title")
    String? title;
    @JsonKey(name: "occasionId")
    dynamic occasionId;
    @JsonKey(name: "categoryId")
    dynamic categoryId;

    SectionDto({
        this.id,
        this.type,
        this.index,
        this.isActive,
        this.title,
        this.occasionId,
        this.categoryId,
    });

    factory SectionDto.fromJson(Map<String, dynamic> json) => _$SectionDtoFromJson(json);

    Map<String, dynamic> toJson() => _$SectionDtoToJson(this);

    SectionEntity toDomain() => SectionEntity(
        id: id??0,
        type: _stringToSectionType(type) ?? SectionType.category,
        index: index??0,
        isActive: isActive??false,
        title: title??'',
        occasionId: (occasionId is int) ? occasionId : null,
        categoryId: (categoryId is int) ? categoryId : null,
    );
}
