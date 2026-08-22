import 'package:json_annotation/json_annotation.dart';

part 'products_request_dto.g.dart';

@JsonSerializable()
class ProductsRequestDto {
  final int? occasionId;
  final int? categoryId;
  final String? keyword;
  final String? sortBy;
  final int? page;
  final int? pageSize;

  ProductsRequestDto({
    this.occasionId,
    this.categoryId,
    this.keyword,
    this.sortBy,
    this.page,
    this.pageSize,
  });

  factory ProductsRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsRequestDtoToJson(this);
}