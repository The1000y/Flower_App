import 'package:json_annotation/json_annotation.dart';

part 'best_seller_request_dto.g.dart';

@JsonSerializable()
class BestSellerRequestDto {
  final int? page;
  final int? pageSize;

  BestSellerRequestDto({
    this.page,
    this.pageSize,
  });

  factory BestSellerRequestDto.fromJson(Map<String, dynamic> json) =>
      _$BestSellerRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BestSellerRequestDtoToJson(this);
}