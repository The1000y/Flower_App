import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/categories/categories_entity.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  @JsonKey(name: 'id')
  final int id;

  @JsonKey(name: 'name')
  final String name;

  @JsonKey(name: 'iconUrl')
  final String iconUrl;

  CategoryDto({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  CategoryEntity toDomain() {
    return CategoryEntity(
      id: id,
      name: name,
      iconUrl: iconUrl,
    );
  }

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);
}