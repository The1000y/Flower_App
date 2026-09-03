
import '../../../../../../config/base/base_state.dart';
import '../../../../domain/entities/product_details/product_details_entity.dart';

class ProductDetailsState extends BaseState<ProductDetailsEntity> {
  const ProductDetailsState({super.isLoading, super.errorMessage, super.data});

  @override
  ProductDetailsState copyWith({
    bool? isLoading,
    String? errorMessage,
    ProductDetailsEntity? data,
  }) {
    return ProductDetailsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
