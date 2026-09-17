import '../../../../../../config/base/base_state.dart';
import '../../../../domain/entities/best_sellers/best_seller_entity.dart';

class BestsellerState extends BaseState<List<BestSellerEntity>> {
  const BestsellerState({super.isLoading, super.errorMessage, super.data});

  @override
  BestsellerState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<BestSellerEntity>? data,
  }) {
    return BestsellerState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      data: data ?? this.data,
    );
  }
}
