import 'package:json_annotation/json_annotation.dart';
import 'nearest_store_dto.dart';

part 'nearest_store_response_dto.g.dart';

@JsonSerializable()
class NearestStoreResponseDto {
  @JsonKey(name: 'data')
  final NearestStoreDto? data;
  @JsonKey(name: 'isSuccess')
  final bool? isSuccess;
  @JsonKey(name: 'message')
  final String? message;

  NearestStoreResponseDto({
    this.data,
    this.isSuccess,
    this.message,
  });

  factory NearestStoreResponseDto.fromJson(Map<String, dynamic> json) =>
      _$NearestStoreResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$NearestStoreResponseDtoToJson(this);
}
