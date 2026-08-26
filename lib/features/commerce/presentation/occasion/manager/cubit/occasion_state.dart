import 'package:equatable/equatable.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';
import '../../../../domain/entities/products/pagination_entity.dart';
import '../../../../domain/entities/products/product_entity.dart';

class OccasionState extends Equatable {
  final bool isLoadingOccasions;
  final String occasionsError;
  final List<OccasionEntity> occasions;

  final bool isLoadingProducts;
  final bool isLoadingMore;
  final String productsError;
  final List<ProductEntity> products;
  final PaginationEntity? pagination;
  final int currentOccasionId;

  const OccasionState({
    this.isLoadingOccasions = false,
    this.occasionsError = '',
    this.occasions = const [],
    this.isLoadingProducts = false,
    this.isLoadingMore = false,
    this.productsError = '',
    this.products = const [],
    this.pagination,
    this.currentOccasionId = 0,
  });

  OccasionState copyWith({
    bool? isLoadingOccasions,
    String? occasionsError,
    List<OccasionEntity>? occasions,
    bool? isLoadingProducts,
    bool? isLoadingMore,
    String? productsError,
    List<ProductEntity>? products,
    PaginationEntity? pagination,
    int? currentOccasionId,
  }) {
    return OccasionState(
      isLoadingOccasions: isLoadingOccasions ?? this.isLoadingOccasions,
      occasionsError: occasionsError ?? this.occasionsError,
      occasions: occasions ?? this.occasions,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      productsError: productsError ?? this.productsError,
      products: products ?? this.products,
      pagination: pagination ?? this.pagination,
      currentOccasionId: currentOccasionId ?? this.currentOccasionId,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingOccasions,
    occasionsError,
    occasions,
    isLoadingProducts,
    isLoadingMore,
    productsError,
    products,
    pagination,
    currentOccasionId,
  ];
}