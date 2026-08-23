import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;

  const HomeState({
    this.categoriesState = const BaseState(isLoading: true),
  });

  HomeState copyWith(BaseState<List<CategoryEntity>> categoriesState) =>
      HomeState(categoriesState: categoriesState);

  @override
  List<Object?> get props => [categoriesState];
}
