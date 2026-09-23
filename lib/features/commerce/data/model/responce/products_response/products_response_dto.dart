import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response_dto.g.dart';

@JsonSerializable()
class ProductsResponseDto {
  @JsonKey(name: 'data')
  final ProductListDataDto data;

  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'errorCode')
  final String errorCode;

  ProductsResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseDtoToJson(this);

  List<ProductEntity> get products {
    return data.items.map((item) => item.toDomain()).toList();
  }

  PaginationEntity get pagination {
    return data.pagination.toDomain();
  }
}

@JsonSerializable()
class ProductListDataDto {
  @JsonKey(name: 'items')
  final List<ProductDto> items;

  @JsonKey(name: 'pagination')
  final PaginationDto pagination;

  ProductListDataDto({
    required this.items,
    required this.pagination,
  });

  factory ProductListDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProductListDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListDataDtoToJson(this);
}