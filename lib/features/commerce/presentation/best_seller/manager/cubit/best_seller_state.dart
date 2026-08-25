import '../../../../../../config/base/base_state.dart';
import '../../../../domain/entities/products/product_entity.dart';

class BestSellerState extends BaseState<List<ProductEntity>> {
  final bool isFetchingMore;
  final bool hasMore;
  final int currentPage;

  const BestSellerState({
    super.isLoading,
    super.errorMessage,
    super.data,
    this.isFetchingMore = false,
    this.hasMore = true,
    this.currentPage = 1,
  });

  @override
  BestSellerState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<ProductEntity>? data,
    bool? isFetchingMore,
    bool? hasMore,
    int? currentPage,
  }) {
    return BestSellerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
    );
  }

  @override
  List<Object?> get props =>
      [isLoading, errorMessage, data, isFetchingMore, hasMore, currentPage];
}
