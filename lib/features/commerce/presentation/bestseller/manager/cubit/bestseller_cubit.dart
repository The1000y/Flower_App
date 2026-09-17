import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/use_case/get_best_seller_use_case.dart';
import 'bestseller_event.dart';
import 'bestseller_state.dart';

@injectable
class BestsellerCubit extends Cubit<BestsellerState> {
  final GetBestSellerUseCase _getBestSellerUseCase;

  BestsellerCubit(this._getBestSellerUseCase) : super(const BestsellerState());

  void doEvent(BestsellerEvent event) {
    switch (event) {
      case GetBestsellerListEvent():
        getBestsellerList();
        break;
    }
  }

  Future<void> getBestsellerList() async {
    emit(state.copyWith(
      isLoading: true,
      errorMessage: '',
    ));

    final result = await _getBestSellerUseCase.call();

    switch (result) {
      case SuccessResponce<List<BestSellerEntity>>():
        emit(state.copyWith(
          isLoading: false,
          data: result.data,
        ));
        break;
      case ErrorResponce<List<BestSellerEntity>>():
        emit(state.copyWith(isLoading: false, errorMessage: result.errorMessage));
        break;
    }
  }
}
