import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/errors/hadel_error_exception.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
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
        _searchProducts(event.query);
        break;
      case LoadMoreSearchEvent():
        _loadMore();
        break;
    }
  }

  Future<void> _searchProducts(String query) async {
    final trimmed = query.trim();
    emit(
      state.copyWith(
        query: trimmed,
        resultState: state.resultState.copyWith(
          isLoading: trimmed.isNotEmpty,
          errorMessage: '',
          data: null,
        ),
        pagination: null,
        isLoadingMore: false,
      ),
    );

    if (trimmed.isEmpty) {
      return;
    }

    await _fetchProducts(trimmed, page: 1);
  }

  void _loadMore() {
    if (state.query.trim().isEmpty ||
        state.resultState.isLoading ||
        state.isLoadingMore ||
        state.pagination?.hasNextPage != true) {
      return;
    }
    _fetchProducts(state.query, page: state.pagination!.page + 1);
  }

  Future<void> _fetchProducts(String query, {required int page}) async {
    if (page > 1) {
      emit(state.copyWith(isLoadingMore: true));
    }

    BaseResponce<PaginatedProducts> response;
    try {
      response = await _searchProductsUseCase.call(query, page: page);
    } catch (e) {
      emit(
        state.copyWith(
          resultState: state.resultState.copyWith(
            isLoading: false,
            data: null,
            errorMessage: HandelErrorException().handelErrorexception(
              e is Exception ? e : Exception(e.toString()),
            ),
          ),
          isLoadingMore: false,
        ),
      );
      return;
    }
    switch (response) {
      case SuccessResponce<PaginatedProducts>():
        final items = page == 1
            ? response.data.items
            : [
                ...(state.resultState.data ?? const <ProductEntity>[]),
                ...response.data.items,
              ];
        emit(
          state.copyWith(
            resultState: state.resultState.copyWith(
              isLoading: false,
              data: items,
              errorMessage: '',
            ),
            isLoadingMore: false,
            pagination: response.data.pagination,
          ),
        );
        break;
      case ErrorResponce<PaginatedProducts>():
        emit(
          state.copyWith(
            resultState: state.resultState.copyWith(
              isLoading: false,
              data: null,
              errorMessage: response.errorMessage,
            ),
            isLoadingMore: false,
          ),
        );
        break;
    }
  }
}