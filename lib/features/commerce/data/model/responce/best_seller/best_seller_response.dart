// To parse this JSON data, do
//
//     final bestSellerResponse = bestSellerResponseFromJson(jsonString);

import 'package:flower_app/features/commerce/data/model/responce/best_seller/item_Dto.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'best_seller_response.g.dart';

BestSellerResponse bestSellerResponseFromJson(String str) => BestSellerResponse.fromJson(json.decode(str));

String bestSellerResponseToJson(BestSellerResponse data) => json.encode(data.toJson());

@JsonSerializable()
class BestSellerResponse {
    @JsonKey(name: "data")
    Data? data;
    @JsonKey(name: "isSuccess")
    bool? isSuccess;
    @JsonKey(name: "message")
    String? message;
    @JsonKey(name: "errorCode")
    String? errorCode;

    BestSellerResponse({
        this.data,
        this.isSuccess,
        this.message,
        this.errorCode,
    });

    factory BestSellerResponse.fromJson(Map<String, dynamic> json) => _$BestSellerResponseFromJson(json);

    Map<String, dynamic> toJson() => _$BestSellerResponseToJson(this);
}

@JsonSerializable()
class Data {
    @JsonKey(name: "items")
    List<ItemDto>? items;
    @JsonKey(name: "pagination")
    Pagination? pagination;

    Data({
        this.items,
        this.pagination,
    });

    factory Data.fromJson(Map<String, dynamic> json) => _$DataFromJson(json);

    Map<String, dynamic> toJson() => _$DataToJson(this);
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
