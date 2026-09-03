import 'package:json_annotation/json_annotation.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';

part 'category_dto.g.dart';

@JsonSerializable()
class CategoryDto {
  final int id;
  final String name;
  final String iconUrl;

  CategoryDto({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) => _$CategoryDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryDtoToJson(this);

  CategoryEntity toDomain() => CategoryEntity(
        id: id,
        name: name,
        iconUrl: iconUrl,
      );
}
