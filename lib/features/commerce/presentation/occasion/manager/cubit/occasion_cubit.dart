import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_occasions_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_products_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'occasion_event.dart';
import 'occasion_state.dart';

@injectable
class OccasionCubit extends Cubit<OccasionState> {
  final GetOccasionsUseCase _getOccasionsUseCase;
  final GetProductsUseCase _getProductsUseCase;

  OccasionCubit(this._getOccasionsUseCase, this._getProductsUseCase)
      : super(const OccasionState());

  void handle(OccasionEvent event) {
    switch (event) {
      case LoadOccasions():
        _loadOccasions();
      case LoadProductsForOccasion():
        _loadProducts(event.occasionId);
      case LoadMoreProducts():
        _loadMore();
    }
  }

  Future<void> _loadOccasions() async {
    emit(state.copyWith(
      occasionsState: state.occasionsState.copyWith(isLoading: true, errorMessage: ''),
    ));

    final response = await _getOccasionsUseCase.execute();

    switch (response) {
      case SuccessResponce():
        emit(state.copyWith(
          occasionsState: state.occasionsState.copyWith(isLoading: false, data: response.data),
        ));
        if (response.data.isNotEmpty) {
          handle(LoadProductsForOccasion(response.data.first.id));
        }
      case ErrorResponce():
        emit(state.copyWith(
          occasionsState: state.occasionsState.copyWith(isLoading: false, errorMessage: response.errorMessage),
        ));
    }
  }

  Future<void> _loadProducts(int occasionId, {int page = 1}) async {
    if (page == 1) {
      // Reset pagination and switch the active occasion immediately, so a
      // load-more triggered during this load can't read the previous
      // occasion's stale pagination/hasNextPage.
      emit(state.copyWith(
        productsState: state.productsState.copyWith(isLoading: true, errorMessage: '', data: []),
        pagination: null,
        currentOccasionId: occasionId,
      ));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    final response = await _getProductsUseCase.execute(occasionId, page: page);

    // The user may have switched occasions while this request was in
    // flight — drop the response instead of appending it to the wrong list.
    if (state.currentOccasionId != occasionId) return;

    switch (response) {
      case SuccessResponce():
        final items = page == 1
            ? response.data.items
            : [...(state.productsState.data ?? const <ProductEntity>[]), ...response.data.items];
        emit(state.copyWith(
          productsState: state.productsState.copyWith(isLoading: false, data: items),
          isLoadingMore: false,
          pagination: response.data.pagination,
        ));
      case ErrorResponce():
        emit(state.copyWith(
          productsState: state.productsState.copyWith(isLoading: false, errorMessage: response.errorMessage),
          isLoadingMore: false,
        ));
    }
  }

  void _loadMore() {
    if (state.currentOccasionId != 0 &&
        !state.productsState.isLoading &&
        !state.isLoadingMore &&
        state.pagination?.hasNextPage == true) {
      _loadProducts(state.currentOccasionId, page: state.pagination!.page + 1);
    }
  }
}