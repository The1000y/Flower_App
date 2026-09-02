
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:json_annotation/json_annotation.dart';
part 'product_Dto.g.dart';
@JsonSerializable()
class ProductDto {
    @JsonKey(name: "id")
    int? id;
    @JsonKey(name: "name")
    String? name;
    @JsonKey(name: "imageUrl")
    String? imageUrl;
    @JsonKey(name: "currency")
    String? currency;
    @JsonKey(name: "price")
    int? price;
    @JsonKey(name: "originalPrice")
    int? originalPrice;
    @JsonKey(name: "discountPercentage")
    int? discountPercentage;
    @JsonKey(name: "status")
    String? status;

    ProductDto({
        this.id,
        this.name,
        this.imageUrl,
        this.currency,
        this.price,
        this.originalPrice,
        this.discountPercentage,
        this.status,
    });

    factory ProductDto.fromJson(Map<String, dynamic> json) => _$ProductDtoFromJson(json);

    Map<String, dynamic> toJson() => _$ProductDtoToJson(this);

    BestSellerEntity toDomain (){
      return BestSellerEntity(
        id: id??0,
        name: name??'',
        imageUrl: imageUrl??'',
        currency: currency??'',
        price: price??0,
        originalPrice: originalPrice??0,
        discountPercentage: discountPercentage??0,
        status: status??'',
      );
    }
}
