import 'package:json_annotation/json_annotation.dart';
import '../../../domain/entities/address_entity.dart';
import 'address_dto.dart';

part 'address_list_response_dto.g.dart';

@JsonSerializable()
class AddressListResponseDto {
  @JsonKey(name: 'data')
  final List<AddressDto> data;
  @JsonKey(name: 'isSuccess')
  final bool isSuccess;
  @JsonKey(name: 'message')
  final String message;
  @JsonKey(name: 'errorCode')
  final String errorCode;

  AddressListResponseDto({
    required this.data,
    required this.isSuccess,
    required this.message,
    required this.errorCode,
  });

  List<AddressEntity> toDomain() => data.map((e) => e.toDomain()).toList();

  factory AddressListResponseDto.fromJson(Map<String, dynamic> json) =>
      _$AddressListResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$AddressListResponseDtoToJson(this);
}