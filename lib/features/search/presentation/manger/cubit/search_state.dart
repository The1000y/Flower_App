import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

class SearchState extends Equatable {
  final BaseState<List<ProductEntity>> resultState;
  final String query;
  final bool isLoadingMore;
  final PaginationEntity? pagination;

  const SearchState({
    this.resultState = const BaseState<List<ProductEntity>>(),
    this.query = '',
    this.isLoadingMore = false,
    this.pagination,
  });

  SearchState copyWith({
    BaseState<List<ProductEntity>>? resultState,
    String? query,
    bool? isLoadingMore,
    PaginationEntity? pagination,
  }) {
    return SearchState(
      resultState: resultState ?? this.resultState,
      query: query ?? this.query,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [resultState, query, isLoadingMore, pagination];
}