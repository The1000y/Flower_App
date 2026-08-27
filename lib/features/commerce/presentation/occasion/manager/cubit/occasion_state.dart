import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';
import '../../../../domain/entities/products/pagination_entity.dart';
import '../../../../domain/entities/products/product_entity.dart';

class OccasionState extends Equatable {
  final BaseState<List<OccasionEntity>> occasionsState;
  final BaseState<List<ProductEntity>> productsState;
  final bool isLoadingMore;
  final PaginationEntity? pagination;
  final int currentOccasionId;

  const OccasionState({
    this.occasionsState = const BaseState<List<OccasionEntity>>(data: []),
    this.productsState = const BaseState<List<ProductEntity>>(data: []),
    this.isLoadingMore = false,
    this.pagination,
    this.currentOccasionId = 0,
  });

  OccasionState copyWith({
    BaseState<List<OccasionEntity>>? occasionsState,
    BaseState<List<ProductEntity>>? productsState,
    bool? isLoadingMore,
    PaginationEntity? pagination,
    int? currentOccasionId,
  }) {
    return OccasionState(
      occasionsState: occasionsState ?? this.occasionsState,
      productsState: productsState ?? this.productsState,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pagination: pagination ?? this.pagination,
      currentOccasionId: currentOccasionId ?? this.currentOccasionId,
    );
  }

  @override
  List<Object?> get props => [
    occasionsState,
    productsState,
    isLoadingMore,
    pagination,
    currentOccasionId,
  ];
}