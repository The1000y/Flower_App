import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/use_case/get_best_seller_use_case.dart';
import 'best_seller_event.dart';
import 'best_seller_state.dart';

@injectable
class BestSellerCubit extends Cubit<BestSellerState> {
  final GetBestSellerUseCase _getBestSellerUseCase;

  BestSellerCubit(this._getBestSellerUseCase) : super(const BestSellerState());

  void doEvent(BestSellerEvent event) {
    switch (event) {
      case GetBestSellerEvent():
        getBestSeller();
        break;
      case LoadMoreBestSellerEvent():
        loadMore();
        break;
    }
  }

  Future<void> getBestSeller() async {
    emit(state.copyWith(isLoading: true, errorMessage: '', currentPage: 1, hasMore: true));

    final result = await _getBestSellerUseCase.execute(page: 1);

    switch (result) {
      case SuccessResponce():
        emit(state.copyWith(
          isLoading: false, 
          data: result.data,
          hasMore: result.data.isNotEmpty,
        ));
        break;
      case ErrorResponce():
        emit(state.copyWith(isLoading: false, errorMessage: result.errorMessage));
        break;
    }
  }

  Future<void> loadMore() async {
    if (state.isFetchingMore || !state.hasMore) return;

    emit(state.copyWith(isFetchingMore: true));

    final nextPage = state.currentPage + 1;
    final result = await _getBestSellerUseCase.execute(page: nextPage);

    switch (result) {
      case SuccessResponce():
        final currentList = List<ProductEntity>.from(state.data ?? []);
        currentList.addAll(result.data);
        
        emit(state.copyWith(
          isFetchingMore: false,
          data: currentList,
          currentPage: nextPage,
          hasMore: result.data.isNotEmpty, // Adjust based on your API logic
        ));
        break;
      case ErrorResponce():
        emit(state.copyWith(isFetchingMore: false, errorMessage: result.errorMessage));
        break;
    }
  }
}
