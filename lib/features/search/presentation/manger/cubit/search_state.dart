import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

class SearchState extends Equatable {
  final BaseState<List<ProductEntity>> resultState;
  final String query;

  const SearchState({
    this.resultState = const BaseState<List<ProductEntity>>(),
    this.query = '',
  });

  SearchState copyWith({
    BaseState<List<ProductEntity>>? resultState,
    String? query,
  }) {
    return SearchState(
      resultState: resultState ?? this.resultState,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [resultState, query];
}
