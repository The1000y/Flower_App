import 'package:equatable/equatable.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

import '../../../../../../config/base/base_state.dart';
import '../../../../domain/entities/categories/categories_entity.dart';

class CategoriesState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<ProductEntity>> productsState;

  const CategoriesState({
    this.categoriesState = const BaseState<List<CategoryEntity>>(),
    this.productsState = const BaseState<List<ProductEntity>>(),
  });

  CategoriesState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<ProductEntity>>? productsState,
  }) {
    return CategoriesState(
      categoriesState: categoriesState ?? this.categoriesState,
      productsState: productsState ?? this.productsState,
    );
  }

  @override
  List<Object?> get props => [categoriesState, productsState];
}
