import 'package:flower_app/features/commerce/data/model/responce/best_seller/best_seller_response.dart';
import 'package:flower_app/features/commerce/domain/entities/bestSeller/product_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'best_seller_item_dto.g.dart';

@JsonSerializable()
class BestSellerDataDto {
  @JsonKey(name: "items")
  List<ItemDto>? items;
  @JsonKey(name: "pagination")
  Pagination? pagination;

  BestSellerDataDto({this.items, this.pagination});

  factory BestSellerDataDto.fromJson(Map<String, dynamic> json) =>
      _$BestSellerDataDtoFromJson(json);

  Map<String, dynamic> toJson() => _$BestSellerDataDtoToJson(this);
}

@JsonSerializable()
class ItemDto {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "name")
  String? name;
  @JsonKey(name: "imageUrl")
  String? imageUrl;
  @JsonKey(name: "currency")
  String? currency;
  @JsonKey(name: "price")
  double? price;
  @JsonKey(name: "originalPrice")
  int? originalPrice;
  @JsonKey(name: "discountPercentage")
  int? discountPercentage;
  @JsonKey(name: "status")
  String? status;

  ItemDto({
    this.id,
    this.name,
    this.imageUrl,
    this.currency,
    this.price,
    this.originalPrice,
    this.discountPercentage,
    this.status,
  });

  factory ItemDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ItemDtoToJson(this);

  BestSellerEntity toDomain() {
    return BestSellerEntity(
      id: id ?? 0,
      name: name ?? '',
      imageUrl: imageUrl ?? '',
      currency: currency ?? '',
      price: price ?? 0,
      status: status ?? '',
    );
  }
}
