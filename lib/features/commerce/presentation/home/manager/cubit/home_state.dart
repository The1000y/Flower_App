import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<BestSellerEntity>> bestSellerState;
  final BaseState<List<SectionEntity>> sectionsState;
  final BaseState<List<OccasionEntity>> occasionState;

  const HomeState({
    this.categoriesState = const BaseState(isLoading: true),
    this.bestSellerState = const BaseState(isLoading: true),
    this.sectionsState = const BaseState(isLoading: true),
    this.occasionState = const BaseState(isLoading: true),
  });

  HomeState copyWith({
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<BestSellerEntity>>? bestSellerState,
    BaseState<List<SectionEntity>>? sectionsState,
    BaseState<List<OccasionEntity>>? occasionState,
  }) => HomeState(
    categoriesState: categoriesState ?? this.categoriesState,
    bestSellerState: bestSellerState ?? this.bestSellerState,
    sectionsState: sectionsState ?? this.sectionsState,
    occasionState: occasionState ?? this.occasionState,
  );

  @override
  List<Object?> get props => [
    categoriesState,
    bestSellerState,
    sectionsState,
    occasionState,
  ];
}
