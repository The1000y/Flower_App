import 'package:flower_app/config/base/base_state.dart';

import '../../../../domain/entities/cart/cart_entity.dart';

class CartState extends BaseState<CartEntity> {
  final bool addToCartSuccess;
  final Set<int> loadingProductIds;

  const CartState({
    super.isLoading,
    super.errorMessage,
    super.data,
    this.addToCartSuccess = false,
    this.loadingProductIds = const {},
  });

  CartEntity get cart =>
      data ??
      CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false);

  bool isProductLoading(int productId) => loadingProductIds.contains(productId);

  @override
  CartState copyWith({
    bool? isLoading,
    String? errorMessage,
    CartEntity? data,
    bool? addToCartSuccess,
    Set<int>? loadingProductIds,
  }) {
    return CartState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      addToCartSuccess: addToCartSuccess ?? this.addToCartSuccess,
      loadingProductIds: loadingProductIds ?? this.loadingProductIds,
    );
  }
}
