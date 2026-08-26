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
    emit(state.copyWith(isLoadingOccasions: true, occasionsError: ''));
    try {
      final occasions = await _getOccasionsUseCase.execute();
      emit(state.copyWith(isLoadingOccasions: false, occasions: occasions));
      if (occasions.isNotEmpty) {
        handle(LoadProductsForOccasion(occasions.first.id));
      }
    } catch (error) {
      emit(state.copyWith(isLoadingOccasions: false, occasionsError: error.toString()));
    }
  }

  Future<void> _loadProducts(int occasionId, {int page = 1}) async {
    if (page == 1) {
      emit(state.copyWith(isLoadingProducts: true, productsError: '', products: []));
    } else {
      emit(state.copyWith(isLoadingMore: true));
    }

    try {
      final result = await _getProductsUseCase.execute(occasionId, page: page);
      emit(state.copyWith(
        isLoadingProducts: false,
        isLoadingMore: false,
        products: page == 1 ? result.items : [...state.products, ...result.items],
        pagination: result.pagination,
        currentOccasionId: occasionId,
      ));
    } catch (error) {
      emit(state.copyWith(isLoadingProducts: false, isLoadingMore: false, productsError: error.toString()));
    }
  }

  void _loadMore() {
    if (state.pagination?.hasNextPage == true && !state.isLoadingMore) {
      _loadProducts(state.currentOccasionId, page: state.pagination!.page + 1);
    }
  }
}