import 'package:equatable/equatable.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';
import '../../../../domain/entities/products/product_entity.dart';

class OccasionState extends Equatable {
  final bool isLoadingOccasions;
  final String occasionsError;
  final List<OccasionEntity> occasions;

  final bool isLoadingProducts;
  final String productsError;
  final List<ProductEntity> products;

  const OccasionState({
    this.isLoadingOccasions = false,
    this.occasionsError = '',
    this.occasions = const [],
    this.isLoadingProducts = false,
    this.productsError = '',
    this.products = const [],
  });

  OccasionState copyWith({
    bool? isLoadingOccasions,
    String? occasionsError,
    List<OccasionEntity>? occasions,
    bool? isLoadingProducts,
    String? productsError,
    List<ProductEntity>? products,
  }) {
    return OccasionState(
      isLoadingOccasions: isLoadingOccasions ?? this.isLoadingOccasions,
      occasionsError: occasionsError ?? this.occasionsError,
      occasions: occasions ?? this.occasions,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      productsError: productsError ?? this.productsError,
      products: products ?? this.products,
    );
  }

  @override
  List<Object?> get props => [
    isLoadingOccasions,
    occasionsError,
    occasions,
    isLoadingProducts,
    productsError,
    products,
  ];
}