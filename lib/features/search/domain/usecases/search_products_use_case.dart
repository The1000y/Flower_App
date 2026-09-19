import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:injectable/injectable.dart';

@injectable
class SearchProductsUseCase {
  final CommerceRepo repo;

  SearchProductsUseCase(this.repo);

  Future<BaseResponce<PaginatedProducts>> call(
    String query, {
    int page = 1,
    int pageSize = 8,
  }) async {
    final response = await repo.getProducts();
    switch (response) {
      case SuccessResponce<List<ProductEntity>>():
        final filtered = response.data
            .where(
              (product) => product.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();

        final totalPages = pageSize <= 0 ? 0 : (filtered.length / pageSize).ceil();
        final start = (page - 1) * pageSize;
        final end = (start + pageSize).clamp(0, filtered.length).toInt();

        final items = start >= filtered.length || start >= end
            ? <ProductEntity>[]
            : filtered.sublist(start, end);

        return SuccessResponce(
          PaginatedProducts(
            items: items,
            pagination: PaginationEntity(
              page: page,
              pageSize: pageSize,
              totalCount: filtered.length,
              totalPages: totalPages,
              hasNextPage: page < totalPages,
              hasPreviousPage: page > 1,
            ),
          ),
        );
      case ErrorResponce<List<ProductEntity>>():
        return ErrorResponce(response.error);
    }
  }
}