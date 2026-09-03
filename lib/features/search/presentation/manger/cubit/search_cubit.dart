import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import 'search_event.dart';
import 'search_state.dart';

@injectable
class SearchCubit extends Cubit<SearchState> {
  SearchCubit(this._searchProductsUseCase) : super(const SearchState());

  final SearchProductsUseCase _searchProductsUseCase;

  void doEvent(SearchEvent event) {
    switch (event) {
      case SearchProductsEvent():
        searchProducts(event.query);
        break;
    }
  }

  Future<void> searchProducts(String query) async {
    final trimmed = query.trim();
    emit(
      state.copyWith(
        query: trimmed,
        resultState: state.resultState.copyWith(
          isLoading: trimmed.isNotEmpty,
          errorMessage: '',
          data: null,
        ),
      ),
    );

    if (trimmed.isEmpty) {
      return;
    }

    final BaseResponce<List<ProductEntity>> response =
        await _searchProductsUseCase.call(trimmed);
    switch (response) {
      case SuccessResponce<List<ProductEntity>>():
        emit(
          state.copyWith(
            resultState: state.resultState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponce<List<ProductEntity>>():
        emit(
          state.copyWith(
            resultState: state.resultState.copyWith(
              isLoading: false,
              data: null,
              errorMessage: response.errorMessage,
            ),
          ),
        );
        break;
    }
  }
}
