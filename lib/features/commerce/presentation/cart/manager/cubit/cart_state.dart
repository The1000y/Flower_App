  import 'package:equatable/equatable.dart';

  import '../../../../domain/entities/cart/cart_entity.dart';

  class CartState extends Equatable {
    final bool isLoading;
    final String errorMessage;
    final CartEntity? data;
    final bool addToCartSuccess;
    final Set<int> loadingProductIds;

    const CartState({
      this.isLoading = false,
      this.errorMessage = '',
      this.data,
      this.addToCartSuccess = false,
      this.loadingProductIds = const {},
    });

    CartEntity get cart =>
        data ??
        CartEntity(items: const [], subtotal: 0, total: 0, hasChanges: false);

    bool isProductLoading(int productId) => loadingProductIds.contains(productId);

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

    @override
    List<Object?> get props => [
      isLoading,
      errorMessage,
      data,
      addToCartSuccess,
      loadingProductIds,
    ];
  }
