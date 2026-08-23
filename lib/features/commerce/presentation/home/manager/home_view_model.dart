import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/bestSeller/product_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/home_section_type.dart';
import 'package:flower_app/features/commerce/domain/use_case/check_section_update_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_best_seller_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_home_sections_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_occasions_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_section_products_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/refresh_sections_use_case.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

@injectable
class HomeViewModel extends Cubit<HomeState> {
  final GetHomeSections _getHomeSections;
  final GetCategories _getCategories;
  final GetBestSeller _getBestSeller;
  final GetOccasions _getOccasions;
  final GetSectionProducts _getSectionProducts;
  final CheckSectionsUpdate _checkSectionsUpdate;
  final RefreshSections _refreshSections;

  HomeViewModel(
    this._getHomeSections,
    this._getCategories,
    this._getBestSeller,
    this._getOccasions,
    this._getSectionProducts,
    this._checkSectionsUpdate,
    this._refreshSections,
  ) : super(const HomeState());

  Future<void> handle(HomeIntent intent) async {
    switch (intent) {
      case LoadHome():
        await _loadHome();

      case CheckForSectionsUpdate():
        await _checkForSectionsUpdate();

      case RefreshHomePressed():
        await _refreshHome();
    }
  }

  Future<void> _loadHome() async {
    emit(
      state.copyWith(
        sectionsState: const BaseState(isLoading: true),
        hasSectionsUpdate: false,
      ),
    );

    try {
      final sections = await _getHomeSections.call();

      emit(state.copyWith(sectionsState: BaseState(data: sections)));
    } on ErrorResponce catch (error) {
      emit(
        state.copyWith(
          sectionsState: BaseState(errorMessage: error.errorMessage),
        ),
      );
      return;
    }

    await _loadRequiredSectionData();

    await _checkForSectionsUpdate();
  }

  Future<void> _checkForSectionsUpdate() async {
    final bool hasUpdate;

    try {
      hasUpdate = await _checkSectionsUpdate.call();
    } on ErrorResponce {
      return;
    }

    if (hasUpdate && !state.hasSectionsUpdate) {
      emit(state.copyWith(hasSectionsUpdate: true));
    }
  }

  Future<void> _refreshHome() async {
    if (state.isRefreshing) return;

    emit(state.copyWith(isRefreshing: true, refreshError: ''));

    try {
      final sections = await _refreshSections.call();

      emit(
        state.copyWith(
          sectionsState: BaseState(data: sections),
          hasSectionsUpdate: false,
        ),
      );

      await _loadRequiredSectionData(forceReload: true);
    } on ErrorResponce catch (error) {
      emit(state.copyWith(refreshError: error.errorMessage));
    } finally {
      if (!isClosed) {
        emit(state.copyWith(isRefreshing: false));
      }
    }
  }

  Future<void> _loadRequiredSectionData({bool forceReload = false}) async {
    final activeSections = (state.sectionsState.data ?? const <HomeEntity>[])
        .activeSorted;

    if (activeSections.isEmpty) return;

    final loads = <Future<void>>[
      if (activeSections.requiresCategories &&
          (forceReload || state.categoriesState.data == null))
        _loadCategories(),
      if (activeSections.requiresBestSellers &&
          (forceReload || state.bestSellersState.data == null))
        _loadBestSellers(),
      if (activeSections.requiresOccasions &&
          (forceReload || state.occasionsState.data == null))
        _loadOccasions(),
      for (final section in activeSections.productsCarouselSections)
        if (forceReload || state.productsFor(section).data == null)
          _loadSectionProducts(section),
    ];

    await Future.wait(loads);
  }

  Future<void> _loadCategories() async {
    emit(state.copyWith(categoriesState: const BaseState(isLoading: true)));

    try {
      final categories = await _getCategories.call();

      emit(state.copyWith(categoriesState: BaseState(data: categories)));
    } on ErrorResponce catch (error) {
      emit(
        state.copyWith(
          categoriesState: BaseState(errorMessage: error.errorMessage),
        ),
      );
    }
  }

  Future<void> _loadBestSellers() async {
    emit(state.copyWith(bestSellersState: const BaseState(isLoading: true)));

    try {
      final bestSellers = await _getBestSeller.call();

      emit(state.copyWith(bestSellersState: BaseState(data: bestSellers)));
    } on ErrorResponce catch (error) {
      emit(
        state.copyWith(
          bestSellersState: BaseState(errorMessage: error.errorMessage),
        ),
      );
    }
  }

  Future<void> _loadOccasions() async {
    emit(state.copyWith(occasionsState: const BaseState(isLoading: true)));

    try {
      final occasions = await _getOccasions.call();

      emit(state.copyWith(occasionsState: BaseState(data: occasions)));
    } on ErrorResponce catch (error) {
      emit(
        state.copyWith(
          occasionsState: BaseState(errorMessage: error.errorMessage),
        ),
      );
    }
  }

  Future<void> _loadSectionProducts(HomeEntity section) async {
    final loadingState = {
      ...state.sectionProductsState,
      section.id: const BaseState<List<BestSellerEntity>>(isLoading: true),
    };

    emit(state.copyWith(sectionProductsState: loadingState));

    try {
      final products = await _getSectionProducts.call(
        occasionId: section.occasionId,
        categoryId: section.categoryId,
      );

      emit(
        state.copyWith(
          sectionProductsState: {
            ...state.sectionProductsState,
            section.id: BaseState<List<BestSellerEntity>>(data: products),
          },
        ),
      );
    } on ErrorResponce catch (error) {
      emit(
        state.copyWith(
          sectionProductsState: {
            ...state.sectionProductsState,
            section.id: BaseState<List<BestSellerEntity>>(
              errorMessage: error.errorMessage,
            ),
          },
        ),
      );
    }
  }
}
