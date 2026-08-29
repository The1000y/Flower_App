import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_sections_response_dto.g.dart';

@JsonSerializable()
class HomeSectionsResponseDto {
  @JsonKey(name: 'data')
  final List<HomeSectionDto> data;

  @JsonKey(name: 'isSuccess')
  final bool isSuccess;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'errorCode')
  final String errorCode;

  HomeSectionsResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  List<HomeEntity> toDomain() {
    return data.map((item) => item.toDomain()).toList();
  }

  factory HomeSectionsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$HomeSectionsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$HomeSectionsResponseDtoToJson(this);
}