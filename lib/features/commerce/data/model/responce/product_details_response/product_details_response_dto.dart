import 'package:json_annotation/json_annotation.dart';
import 'product_details_dto.dart';

part 'product_details_response_dto.g.dart';

@JsonSerializable()
class ProductDetailsResponseDto {
  @JsonKey(name: 'value')
  final ProductDetailsDto? value;

  @JsonKey(name: 'data')
  final ProductDetailsDto? data;

  @JsonKey(name: 'success')
  final bool? isSuccess;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'error')
  final String? errorCode;

  ProductDetailsResponseDto({
    this.value,
    this.data,
    this.isSuccess,
    this.message,
    this.errorCode,
  });

  ProductDetailsDto get effectiveData => value ?? data!;

  factory ProductDetailsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ProductDetailsResponseDtoFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetailsResponseDtoToJson(this);
}
