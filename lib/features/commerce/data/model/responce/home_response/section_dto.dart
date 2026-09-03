// To parse this JSON data, do
//
//     final sectionDto = sectionDtoFromJson(jsonString);

import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'section_dto.g.dart';

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
        type: type??'',
        index: index??0,
        isActive: isActive??false,
        title: title??'',
        occasionId: occasionId?? 0,
        categoryId: categoryId??0,
    );
}
