import 'package:flower_app/config/base/base_responce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../domain/entities/occasion/occasion_entity.dart';
import '../../../../domain/entities/products/product_entity.dart';
import '../../../../domain/use_case/get_occasions_use_case.dart';
import '../../../../domain/use_case/get_products_use_case.dart';
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
    }
  }

  Future<void> _loadOccasions() async {
    emit(state.copyWith(isLoadingOccasions: true, occasionsError: ''));

    final result = await _getOccasionsUseCase.execute();

    switch (result) {
      case SuccessResponce<List<OccasionEntity>>():
        emit(state.copyWith(isLoadingOccasions: false, occasions: result.data));
        if (result.data.isNotEmpty) {
          handle(LoadProductsForOccasion(result.data.first.id));
        }
      case ErrorResponce<List<OccasionEntity>>():
        emit(state.copyWith(isLoadingOccasions: false, occasionsError: result.errorMessage));
    }
  }

  Future<void> _loadProducts(int occasionId) async {
    emit(state.copyWith(isLoadingProducts: true, productsError: ''));

    final result = await _getProductsUseCase.execute(occasionId);

    switch (result) {
      case SuccessResponce<List<ProductEntity>>():
        emit(state.copyWith(isLoadingProducts: false, products: result.data));
      case ErrorResponce<List<ProductEntity>>():
        emit(state.copyWith(isLoadingProducts: false, productsError: result.errorMessage));
    }
  }
}