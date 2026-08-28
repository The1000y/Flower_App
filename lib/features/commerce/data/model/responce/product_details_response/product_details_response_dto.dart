import 'package:json_annotation/json_annotation.dart';
import 'product_details_dto.dart';

part 'product_details_response_dto.g.dart';

@JsonSerializable()
class ProductDetailsResponseDto {
  final ProductDetailsDto data;
  final bool isSuccess;
  final String message;
  final String errorCode;

  ProductDetailsResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  factory ProductDetailsResponseDto.fromJson(Map<String, dynamic> json) => _$ProductDetailsResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsResponseDtoToJson(this);
}
