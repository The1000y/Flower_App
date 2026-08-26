import 'package:flower_app/config/base/base_responce.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/use_case/get_product_details_use_case.dart';
import 'product_details_event.dart';
import 'product_details_state.dart';

@injectable
class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  final GetProductDetailsUseCase _getProductDetailsUseCase;

  ProductDetailsCubit(this._getProductDetailsUseCase)
      : super(const ProductDetailsState());

  void doEvent(ProductDetailsEvent event) {
    switch (event) {
      case GetProductDetailsEvent():
        getProductDetails(event.productId);
        break;
    }
  }

  Future<void> getProductDetails(int productId) async {
    emit(state.copyWith(isLoading: true, errorMessage: ''));

    final result = await _getProductDetailsUseCase.execute(productId);

    switch (result) {
      case SuccessResponce():
        emit(state.copyWith(isLoading: false, data: result.data));
        break;
      case ErrorResponce():
        emit(state.copyWith(isLoading: false, errorMessage: result.errorMessage));
        break;
    }
  }
}
