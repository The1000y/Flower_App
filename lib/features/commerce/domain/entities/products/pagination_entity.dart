import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

class PaginationEntity {
  final int page;
  final int pageSize;
  final int totalCount;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPreviousPage;

  PaginationEntity({
    required this.page,
    required this.pageSize,
    required this.totalCount,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPreviousPage,
  });}
class PaginatedProducts {
final List<ProductEntity> items;
final PaginationEntity pagination;

PaginatedProducts({required this.items, required this.pagination});}
