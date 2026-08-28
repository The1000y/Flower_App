import 'package:json_annotation/json_annotation.dart';
import 'category_dto.dart';

part 'categories_response_dto.g.dart';

@JsonSerializable()
class CategoriesResponseDto {
  final List<CategoryDto> data;
  final bool isSuccess;
  final String message;
  final String errorCode;

  CategoriesResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) => _$CategoriesResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesResponseDtoToJson(this);
}
