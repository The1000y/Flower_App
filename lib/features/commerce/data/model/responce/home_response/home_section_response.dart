
import 'package:flower_app/features/commerce/data/model/responce/home_response/home_section_data_dto.dart';
import 'package:json_annotation/json_annotation.dart';

part 'home_section_response.g.dart';
@JsonSerializable()
class HomeSectionsResponseDto {
    @JsonKey(name: "data")
    List<HomeSectionDto>? dataSection;
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "errorCode")
    String? errorCode;

    HomeSectionsResponseDto({
        this.dataSection,
        this.isSuccess,
        this.message,
        this.errorCode,
    });

    factory HomeSectionsResponseDto.fromJson(Map<String, dynamic> json) => _$HomeSectionsResponseDtoFromJson(json);

    Map<String, dynamic> toJson() => _$HomeSectionsResponseDtoToJson(this);
}
