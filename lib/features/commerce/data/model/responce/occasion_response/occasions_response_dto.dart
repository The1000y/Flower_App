import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';

part 'occasions_response_dto.g.dart';

@JsonSerializable()
class OccasionDataDto {
  @JsonKey(name: 'items')
  final List<OccasionDto> items;

  OccasionDataDto({required this.items});
  factory OccasionDataDto.fromJson(Map<String, dynamic> json) =>
      _$OccasionDataDtoFromJson(json);
  Map<String, dynamic> toJson() => _$OccasionDataDtoToJson(this);
}

@JsonSerializable()
class OccasionsResponseDto {
  @JsonKey(name: 'data')
  final OccasionDataDto data;

  @JsonKey(name: 'success')
  final bool? isSuccess;

  @JsonKey(name: 'message')
  final String? message;

  @JsonKey(name: 'error')
  final String? errorCode;

  OccasionsResponseDto({
    required this.data,
    this.isSuccess,
    this.message,
    this.errorCode,
  });

  List<OccasionEntity> toDomain() {
    return data.items.map((item) => item.toDomain()).toList();
  }

  factory OccasionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OccasionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$OccasionsResponseDtoToJson(this);
}
