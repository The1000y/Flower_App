import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_item_dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'best_seller_response.g.dart';

BestsellersResponseDto bestsellersResponseDtoFromJson(String str) => BestsellersResponseDto.fromJson(json.decode(str));

String bestsellersResponseDtoToJson(BestsellersResponseDto data) => json.encode(data.toJson());

@JsonSerializable()
class BestsellersResponseDto {
    @JsonKey(name: "data")
    BestSellerDataDto? data;
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "errorCode")
    String? errorCode;

    BestsellersResponseDto({
        this.data,
        this.isSuccess,
        this.message,
        this.errorCode,
    });

    factory BestsellersResponseDto.fromJson(Map<String, dynamic> json) => _$BestsellersResponseDtoFromJson(json);

    Map<String, dynamic> toJson() => _$BestsellersResponseDtoToJson(this);
}

@JsonSerializable()
class Pagination {
    @JsonKey(name: "page")
    int? page;
    @JsonKey(name: "pageSize")
    int? pageSize;
    @JsonKey(name: "totalCount")
    int? totalCount;
    @JsonKey(name: "totalPages")
    int? totalPages;
    @JsonKey(name: "hasNextPage")
    bool? hasNextPage;
    @JsonKey(name: "hasPreviousPage")
    bool? hasPreviousPage;

    Pagination({
        this.page,
        this.pageSize,
        this.totalCount,
        this.totalPages,
        this.hasNextPage,
        this.hasPreviousPage,
    });

    factory Pagination.fromJson(Map<String, dynamic> json) => _$PaginationFromJson(json);

    Map<String, dynamic> toJson() => _$PaginationToJson(this);
}
