// To parse this JSON data, do
//
//     final estimationTimeDto = estimationTimeDtoFromJson(jsonString);

import 'package:flower_app/features/checkout/domain/entities/estimation_time_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'estimation_time_dto.g.dart';

EstimationTimeDto estimationTimeDtoFromJson(String str) =>
    EstimationTimeDto.fromJson(json.decode(str));

String estimationTimeDtoToJson(EstimationTimeDto data) =>
    json.encode(data.toJson());

@JsonSerializable()
class EstimationTimeDto {
  @JsonKey(name: "estimatedDeliveryAt")
  String? estimatedDeliveryAt;

  EstimationTimeDto({this.estimatedDeliveryAt});

  factory EstimationTimeDto.fromJson(Map<String, dynamic> json) =>
      _$EstimationTimeDtoFromJson(json);

  Map<String, dynamic> toJson() => _$EstimationTimeDtoToJson(this);

  EstimationTimeEntity toEntity() =>
      EstimationTimeEntity(estimatedDeliveryAt: estimatedDeliveryAt ?? '');
}
