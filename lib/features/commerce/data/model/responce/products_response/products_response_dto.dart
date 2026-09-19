import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'products_response_dto.g.dart';

@JsonSerializable()
class ProductsResponseDto {
  @JsonKey(name: 'value')
  final ProductListDataDto? value;

  @JsonKey(name: 'data')
  final ProductListDataDto? data;

  @JsonKey(name: 'success')
  final bool? isSuccess;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'error')
  final String? errorCode;

  ProductsResponseDto({
    this.value,
    this.data,
    this.isSuccess,
    this.message,
    this.errorCode,
  });

  factory ProductsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductsResponseDtoToJson(this);

  ProductListDataDto get _effectiveData => value ?? data!;

  List<ProductEntity> get products {
    return _effectiveData.items.map((item) => item.toDomain()).toList();
  }

  PaginationEntity get pagination {
    return _effectiveData.pagination?.toDomain() ??
        PaginationEntity(
          page: 1,
          pageSize: 10,
          totalPages: 1,
          totalCount: 0,
          hasNextPage: false,
          hasPreviousPage: false,
        );
  }
}

@JsonSerializable()
class ProductListDataDto {
  @JsonKey(name: 'items')
  final List<ProductDto> items;

  @JsonKey(name: 'pagination')
  final PaginationDto? pagination;

  ProductListDataDto({required this.items, this.pagination});

  factory ProductListDataDto.fromJson(Map<String, dynamic> json) =>
      _$ProductListDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ProductListDataDtoToJson(this);
}
