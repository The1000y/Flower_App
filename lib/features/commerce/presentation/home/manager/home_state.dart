import 'package:equatable/equatable.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';

class HomeState extends Equatable {
  final BaseState<List<HomeEntity>> sectionsState;
  final BaseState<List<CategoryEntity>> categoriesState;
  final BaseState<List<ProductEntity>> bestSellersState;
  final BaseState<List<OccasionEntity>> occasionsState;
  final Map<int, BaseState<List<ProductEntity>>> sectionProductsState;
  final bool hasSectionsUpdate;
  final bool isRefreshing;
  final String refreshError;

  const HomeState({
    this.sectionsState = const BaseState(isLoading: true),
    this.categoriesState = const BaseState(),
    this.bestSellersState = const BaseState(),
    this.occasionsState = const BaseState(),
    this.sectionProductsState = const {},
    this.hasSectionsUpdate = false,
    this.isRefreshing = false,
    this.refreshError = '',
  });

  BaseState<List<ProductEntity>> productsFor(HomeEntity section) =>
      sectionProductsState[section.id] ?? const BaseState();

  HomeState copyWith({
    BaseState<List<HomeEntity>>? sectionsState,
    BaseState<List<CategoryEntity>>? categoriesState,
    BaseState<List<ProductEntity>>? bestSellersState,
    BaseState<List<OccasionEntity>>? occasionsState,
    Map<int, BaseState<List<ProductEntity>>>? sectionProductsState,
    bool? hasSectionsUpdate,
    bool? isRefreshing,
    String? refreshError,
  }) {
    return HomeState(
      sectionsState: sectionsState ?? this.sectionsState,
      categoriesState: categoriesState ?? this.categoriesState,
      bestSellersState: bestSellersState ?? this.bestSellersState,
      occasionsState: occasionsState ?? this.occasionsState,
      sectionProductsState: sectionProductsState ?? this.sectionProductsState,
      hasSectionsUpdate: hasSectionsUpdate ?? this.hasSectionsUpdate,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      refreshError: refreshError ?? this.refreshError,
    );
  }

  @override
  List<Object?> get props => [
        sectionsState,
        categoriesState,
        bestSellersState,
        occasionsState,
        sectionProductsState,
        hasSectionsUpdate,
        isRefreshing,
        refreshError,
      ];
}
