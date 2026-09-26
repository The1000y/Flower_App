// To parse this JSON data, do
//
//     final estimationTimeResponse = estimationTimeResponseFromJson(jsonString);

import 'package:flower_app/features/checkout/data/model/responce/estimation_time_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'estimation_time_response.g.dart';

EstimationTimeResponse estimationTimeResponseFromJson(String str) => EstimationTimeResponse.fromJson(json.decode(str));

String estimationTimeResponseToJson(EstimationTimeResponse data) => json.encode(data.toJson());

@JsonSerializable()
class EstimationTimeResponse {
    @JsonKey(name: "success")
    bool? success;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "data")
    EstimationTimeDto? data;
    @JsonKey(name: "error")
    Error? error;

    EstimationTimeResponse({
        this.success,
        this.message,
        this.data,
        this.error,
    });

    factory EstimationTimeResponse.fromJson(Map<String, dynamic> json) => _$EstimationTimeResponseFromJson(json);

    Map<String, dynamic> toJson() => _$EstimationTimeResponseToJson(this);
}



@JsonSerializable()
class Error {
    @JsonKey(name: "code")
    String? code;
    @JsonKey(name: "field")
    String? field;

    Error({
        this.code,
        this.field,
    });

    factory Error.fromJson(Map<String, dynamic> json) => _$ErrorFromJson(json);

    Map<String, dynamic> toJson() => _$ErrorToJson(this);
}
