import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: CommerceRepo)
class CommerceRepoImpl implements CommerceRepo {
  final CommerceLocalDataSource localDataSource;
  final CommerceRemoteDataSource remoteDataSource;

  CommerceRepoImpl(this.localDataSource, this.remoteDataSource);

  @override
  Future<BaseResponce<List<CategoryEntity>>> getCategories() async {
    final response = await remoteDataSource.getCategories();
    switch (response) {
      case SuccessResponce<List<CategoryDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<CategoryDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<BestSellerEntity>>> getBestSeller() async {
    // For Best Seller, we fetch regular products from the remote catalog
    final response = await remoteDataSource.getProducts(pageSize: 10);
    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        final data = response.data.products.map((element) {
          return BestSellerEntity(id: element.id , name: element.name , imageUrl: element.imageUrl , currency: element.currency , price: element.price.toInt() , originalPrice: element.originalPrice?.toInt() ?? 0, discountPercentage: element.discountPercentage?.toInt() ?? 0, status: element.status );
        }).toList();
        return SuccessResponce<List<BestSellerEntity>>(data);

      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<SectionEntity>>> getSection() async {
    final response = await remoteDataSource.getSections();
    switch (response) {
      case SuccessResponce<List<SectionDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<SectionDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<OccasionEntity>>> getOccasions() async {
    final response = await remoteDataSource.getOccasions();
    switch (response) {
      case SuccessResponce<List<OccasionDto>>():
        return SuccessResponce(response.data.map((e) => e.toDomain()).toList());
      case ErrorResponce<List<OccasionDto>>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<List<ProductEntity>>> getProducts() async {
    final response = await remoteDataSource.getProducts();
    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return SuccessResponce(response.data.products);
      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce(response.error);
    }
  }

  @override
  Future<BaseResponce<PaginatedProducts>> getOccasionsProducts(String occasionId, {int page = 1}) async {
    final response = await remoteDataSource.getProducts(occasionId: occasionId.toString(), page: page);
    switch (response) {
      case SuccessResponce<ProductsResponseDto>():
        return SuccessResponce(PaginatedProducts(
          items: response.data.products,
          pagination: response.data.pagination,
        ));
      case ErrorResponce<ProductsResponseDto>():
        return ErrorResponce(response.error);
    }
  }
}


