
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';

part 'occasions_response_dto.g.dart';

@JsonSerializable()
class OccasionsResponseDto {
  @JsonKey(name: 'data')
  final List<OccasionDto> data;

  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'errorCode')
  final String errorCode;

  OccasionsResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  List<OccasionEntity> toDomain() {
    return data.map((item) => item.toDomain()).toList();
  }

  factory OccasionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$OccasionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$OccasionsResponseDtoToJson(this);
}