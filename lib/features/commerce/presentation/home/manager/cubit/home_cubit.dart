import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_best_seller_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_home_sections_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_occasions_use_case.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:flower_app/config/base/base_state.dart';

@injectable
class HomeCubit extends Cubit<HomeState> {
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetBestSellerUseCase _getBestSellerUseCase;
  final GetHomeSectionsUseCase _getSectionUseCase;
  final GetOccasionsUseCase _getOccasionsUseCase;

  HomeCubit(
    this._getCategoriesUseCase,
    this._getBestSellerUseCase,
    this._getSectionUseCase,
    this._getOccasionsUseCase,
  ) : super(const HomeState());

  Future<void> doEvent(HomeEvent event) async {
    switch (event) {
      case GetCategoriesEvent():
        await _fetchCategories();
        break;
      case GetBestSellerEvent():
        await _fetchBestSeller();
        break;
      case GetSectionEvent():
        await _fetchHomeSections();
        break;
      case GetOccasionEvent():
        await _fetchOccasions();
        break;
    }
  }

  Future<void> _fetchCategories() async {
    emit(
      state.copyWith(
        categoriesState: const BaseState<List<CategoryEntity>>(isLoading: true),
        bestSellerState: null,
        sectionsState: null,
      ),
    );

    final result = await _getCategoriesUseCase.call();

    switch (result) {
      case SuccessResponce<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: BaseState(data: result.data, isLoading: false),
            bestSellerState: null,
            sectionsState: null,
          ),
        );
      case ErrorResponce<List<CategoryEntity>>():
        emit(
          state.copyWith(
            categoriesState: BaseState(
              errorMessage: result.errorMessage,
              isLoading: false,
            ),
            bestSellerState: null,
            sectionsState: null,
          ),
        );
    }
  }

  Future<void> _fetchBestSeller() async {
    emit(
      state.copyWith(
        categoriesState: null,
        sectionsState: null,
        bestSellerState: BaseState(isLoading: true),
      ),
    );

    final result = await _getBestSellerUseCase.call();

    switch (result) {
      case SuccessResponce<List<BestSellerEntity>>():
        emit(
          state.copyWith(
            categoriesState: null,
            sectionsState: null,
            bestSellerState: BaseState(data: result.data, isLoading: false),
          ),
        );
      case ErrorResponce<List<BestSellerEntity>>():
        emit(
          state.copyWith(
            categoriesState: null,
            sectionsState: null,
            bestSellerState: BaseState(
              errorMessage: result.errorMessage,
              isLoading: false,
            ),
          ),
        );
    }
  }

  Future<void> _fetchHomeSections() async {
    emit(
      state.copyWith(
        sectionsState: BaseState(isLoading: true),
        bestSellerState: null,
        categoriesState: null,
        occasionState: null,
      ),
    );
    final result = await _getSectionUseCase.call();

    switch (result) {
      case SuccessResponce<List<SectionEntity>>():
        final sections = result.data;  
      
        // sections.sort(
        //   (SectionEntity a, SectionEntity b) => a.index.compareTo(b.index),
        // );
        // final activeSections = sections
        //     .where((element) => element.isActive == true)
        //     .toList();

        emit(
          state.copyWith(
            sectionsState: BaseState(data: sections, isLoading: false),
            bestSellerState: null,
            categoriesState: null,
          ),
        );
        for (final section in sections) {
          switch (section.type) {
            case SectionType.category:
              await _fetchCategories();
              break;

            case SectionType.bestSeller:
              await _fetchBestSeller();
              break;

            case SectionType.occasion:
              await _fetchOccasions();
              break;
          }
        }
        break;

      case ErrorResponce<List<SectionEntity>>():
        emit(
          state.copyWith(
            sectionsState: BaseState(
              errorMessage: result.errorMessage,
              isLoading: false,
            ),
            bestSellerState: null,
            categoriesState: null,
          ),
        );
    }
  }

  Future<void> _fetchOccasions() async {
    emit(state.copyWith(occasionState: BaseState(isLoading: true)));

    final result = await _getOccasionsUseCase.call();
    switch (result) {
      case SuccessResponce<List<OccasionEntity>>():
        emit(state.copyWith(occasionState: BaseState(data: result.data, isLoading: false)));
      case ErrorResponce<List<OccasionEntity>>():
        emit(state.copyWith(occasionState: BaseState(errorMessage: result.errorMessage, isLoading: false)));
    }
  }
}
