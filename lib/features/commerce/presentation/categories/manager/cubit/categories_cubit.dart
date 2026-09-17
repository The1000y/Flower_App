import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../config/base/base_responce.dart';
import '../../../../domain/entities/categories/categories_entity.dart';
import '../../../../domain/entities/products/product_entity.dart';
import '../../../../domain/use_case/get_categories_use_case.dart';
import '../../../../domain/use_case/get_product_use_case.dart';
import 'categories_event.dart';
import 'categories_state.dart';
@injectable

class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this.getCategoriesUseCase, this.getProductsUseCase)
    : super(CategoriesState());

  final GetCategoriesUseCase getCategoriesUseCase;
  final GetProductUseCase getProductsUseCase;

  void doEvent(CategoriesEvent event) {
    switch (event) {
      case GetCategoriesEvent():
        _getCategories();
        break;
      case GetProductsEvent():
        _getProducts();
        break;
    }
  }

  void _getCategories() async {
    emit(
      state.copyWith(
        categoriesState: state.categoriesState.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );
    final BaseResponce<List<CategoryEntity>> response =
        await getCategoriesUseCase.call();
    switch (response) {
      case SuccessResponce<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: state.categoriesState.copyWith(
              isLoading: false,
              data: response.data,
              errorMessage: '',
            ),
          ),
        );
        break;
      case ErrorResponce<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: state.categoriesState.copyWith(
              isLoading: false,
              data: null,
              errorMessage: response.error.toString(),
            ),
          ),
        );
    }
  }

  void _getProducts() async {
    emit(
      state.copyWith(
        productsState: state.productsState.copyWith(
          isLoading: true,
          data: null,
          errorMessage: '',
        ),
      ),
    );
    final BaseResponce<List<ProductEntity>> response = await getProductsUseCase
        .call();
    switch (response) {
      case SuccessResponce<List<ProductEntity>>():
        emit(
          state.copyWith(
            productsState: state.productsState.copyWith(
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
            productsState: state.productsState.copyWith(
              isLoading: false,
              data: null,
              errorMessage: response.error.toString(),
            ),
          ),
        );
    }
  }
}
