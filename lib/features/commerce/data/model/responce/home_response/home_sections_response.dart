// To parse this JSON data, do
//
//     final homeSectionsResponse = homeSectionsResponseFromJson(jsonString);

import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'home_sections_response.g.dart';

HomeSectionsResponse homeSectionsResponseFromJson(String str) => HomeSectionsResponse.fromJson(json.decode(str));

String homeSectionsResponseToJson(HomeSectionsResponse data) => json.encode(data.toJson());

@JsonSerializable()
class HomeSectionsResponse {
    @JsonKey(name: "data")
    List<SectionDto>? data;
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "errorCode")
    String? errorCode;

    HomeSectionsResponse({
        this.data,
        this.isSuccess,
        this.message,
        this.errorCode,
    });

    factory HomeSectionsResponse.fromJson(Map<String, dynamic> json) => _$HomeSectionsResponseFromJson(json);

    Map<String, dynamic> toJson() => _$HomeSectionsResponseToJson(this);
}

