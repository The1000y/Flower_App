import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'categories_response_dto.g.dart';

@JsonSerializable()
class CategoriesResponseDto {
  @JsonKey(name: 'data')
  final List<CategoryDto> data;

  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'errorCode')
  final String errorCode;

  CategoriesResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  List<CategoryEntity> toDomain() {
    return data.map((item) => item.toDomain()).toList();
  }

  factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CategoriesResponseDtoToJson(this);
}