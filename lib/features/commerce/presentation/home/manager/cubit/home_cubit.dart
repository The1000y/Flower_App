import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flower_app/config/base/base_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  HomeCubit(this.getCategoriesUseCase)
      : super(const HomeState());

  Future<void> doEvent(HomeEvent event) async {
    if (event is GetCategoriesEvent) {
      await _fetchCategories();
    }
  }

  Future<void> _fetchCategories() async {
    emit(const HomeState(categoriesState: BaseState(isLoading: true)));

    final result = await getCategoriesUseCase.call();

    switch (result) {
      case SuccessResponce<List<CategoryEntity>>():
        emit(HomeState(categoriesState: BaseState(data: result.data , isLoading: false)));
      case ErrorResponce<List<CategoryEntity>>():
        emit(HomeState(
          categoriesState: BaseState(errorMessage: result.errorMessage , isLoading: false),
        ));
    }
  }
}
