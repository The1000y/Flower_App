import 'package:equatable/equatable.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

class PaginationEntity extends Equatable {
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
  });

  @override
  List<Object> get props => [
    page,
    pageSize,
    totalCount,
    totalPages,
    hasNextPage,
    hasPreviousPage,
  ];
}

class PaginatedProducts extends Equatable {
  final List<ProductEntity> items;
  final PaginationEntity pagination;

  PaginatedProducts({required this.items,
    required this.pagination});
  @override
  List<Object> get props => [items, pagination];
}
