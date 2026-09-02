import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/address_entity.dart';
import 'address_dto.dart';

part 'address_response_dto.g.dart';

@JsonSerializable()
class AddressResponseDto {
  @JsonKey(name: 'data')
  final AddressDto data;
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'errorCode')
  final String errorCode;

  AddressResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  AddressEntity toDomain() => data.toDomain();

  factory AddressResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddressResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressResponseDtoToJson(this);
}