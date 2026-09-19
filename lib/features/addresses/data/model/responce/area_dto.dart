import 'package:json_annotation/json_annotation.dart';

part 'area_dto.g.dart';

@JsonSerializable()
class AreaDto {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;
  @JsonKey(name: 'cities')
  final List<CityItemDto>? cities;

  const AreaDto({this.id, this.name, this.cities});

  factory AreaDto.fromJson(Map<String, dynamic> json) =>
      _$AreaDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AreaDtoToJson(this);
}

@JsonSerializable()
class CityItemDto {
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'name')
  final String? name;

  const CityItemDto({this.id, this.name});

  factory CityItemDto.fromJson(Map<String, dynamic> json) =>
      _$CityItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CityItemDtoToJson(this);
}
