import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_details_response_dto.g.dart';

@JsonSerializable()
class ProductDetailsResponseDto {
  @JsonKey(name: 'data')
  final ProductDetailsDto data;

  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'errorCode')
  final String errorCode;

  ProductDetailsResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  ProductDetailsEntity toDomain() {
    return data.toDomain();
  }

  factory ProductDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ProductDetailsResponseDtoToJson(this);
}