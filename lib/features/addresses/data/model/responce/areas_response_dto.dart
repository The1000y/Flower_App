import 'package:json_annotation/json_annotation.dart';
import 'area_dto.dart';

part 'areas_response_dto.g.dart';

@JsonSerializable()
class AreasResponseDto {
  @JsonKey(name: 'data')
  final List<AreaDto>? data;
  @JsonKey(name: 'success')
  final bool? isSuccess;
  @JsonKey(name: 'message')
  final String? message;

  AreasResponseDto({
    this.data,
    this.isSuccess,
    this.message,
  });

  factory AreasResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AreasResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AreasResponseDtoToJson(this);
}