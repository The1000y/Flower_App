import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_cubit.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_event.dart';
import 'package:flower_app/features/commerce/presentation/home/manager/cubit/home_state.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/commerce_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCommerceTestDummies();

  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetBestSellerUseCase mockGetBestSellerUseCase;
  late MockGetHomeSectionsUseCase mockGetSectionsUseCase;
  late MockGetOccasionsUseCase mockGetOccasionsUseCase;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetBestSellerUseCase = MockGetBestSellerUseCase();
    mockGetSectionsUseCase = MockGetHomeSectionsUseCase();
    mockGetOccasionsUseCase = MockGetOccasionsUseCase();
  });

  HomeCubit buildCubit() => HomeCubit(
        mockGetCategoriesUseCase,
        mockGetBestSellerUseCase,
        mockGetSectionsUseCase,
        mockGetOccasionsUseCase,
      );

  group('HomeCubit', () {
    test('initial state is loading for every section', () {
      // Arrange & Act
      final cubit = buildCubit();

      // Assert
      expect(cubit.state, const HomeState());
    });

    group('GetCategoriesEvent', () {
      blocTest<HomeCubit, HomeState>(
        'emits loading then loaded categories when it succeeds',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
        setUp: () {
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessResponce<List<CategoryEntity>>(CommerceFixtures.tCategories),
          );
        },
        expect: () => [
          const HomeState(),
          HomeState(categoriesState: BaseState(data: CommerceFixtures.tCategories)),
        ],
        verify: (_) {
          verify(mockGetCategoriesUseCase.call()).called(1);
          verifyNoMoreInteractions(mockGetCategoriesUseCase);
          verifyNever(mockGetBestSellerUseCase.call());
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits loading then error state when it fails',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
        setUp: () {
          final tError =
              ErrorResponce<List<CategoryEntity>>(Exception('server error'));
          when(mockGetCategoriesUseCase.call()).thenAnswer((_) async => tError);
        },
        expect: () {
          final tError =
              ErrorResponce<List<CategoryEntity>>(Exception('server error'));
          return [
            const HomeState(),
            HomeState(
              categoriesState: BaseState(errorMessage: tError.errorMessage),
            ),
          ];
        },
        verify: (_) => verify(mockGetCategoriesUseCase.call()).called(1),
      );
    });

    group('GetBestSellerEvent', () {
      blocTest<HomeCubit, HomeState>(
        'emits loading then loaded best sellers when it succeeds',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetBestSellerEvent()),
        setUp: () {
          when(mockGetBestSellerUseCase.call()).thenAnswer(
            (_) async =>
                SuccessResponce(CommerceFixtures.tBestSellers),
          );
        },
        expect: () => [
          const HomeState(),
          HomeState(
            bestSellerState: BaseState(data: CommerceFixtures.tBestSellers),
          ),
        ],
        verify: (_) {
          verify(mockGetBestSellerUseCase.call()).called(1);
          verifyNoMoreInteractions(mockGetBestSellerUseCase);
          verifyNever(mockGetCategoriesUseCase.call());
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits loading then error state when it fails',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetBestSellerEvent()),
        setUp: () {
          final tError =
              ErrorResponce<List<BestSellerEntity>>(Exception('network error'));
          when(mockGetBestSellerUseCase.call()).thenAnswer((_) async => tError);
        },
        expect: () {
          final tError =
              ErrorResponce<List<BestSellerEntity>>(Exception('network error'));
          return [
            const HomeState(),
            HomeState(
              bestSellerState: BaseState(errorMessage: tError.errorMessage),
            ),
          ];
        },
        verify: (_) => verify(mockGetBestSellerUseCase.call()).called(1),
      );
    });

    group('GetSectionEvent', () {
      blocTest<HomeCubit, HomeState>(
        'emits sections then lazily loads each section\u2019s data '
        'in order (best sellers first, then categories)',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetSectionEvent()),
        setUp: () {
          when(mockGetSectionsUseCase.call()).thenAnswer(
            (_) async =>
                SuccessResponce(CommerceFixtures.tActiveSortedSections),
          );
          when(mockGetBestSellerUseCase.call()).thenAnswer(
            (_) async => SuccessResponce(CommerceFixtures.tBestSellers),
          );
          when(mockGetCategoriesUseCase.call()).thenAnswer(
            (_) async =>
                SuccessResponce<List<CategoryEntity>>(CommerceFixtures.tCategories),
          );
        },
        expect: () => [
          // Initial state.
          const HomeState(),
          // Sections loaded (already sorted & active via the use case).
          const HomeState(
            sectionsState: BaseState(data: CommerceFixtures.tActiveSortedSections),
          ),
          // Best sellers loaded for the active best-seller section.
          const HomeState(
            bestSellerState: BaseState(data: CommerceFixtures.tBestSellers),
            sectionsState: BaseState(data: CommerceFixtures.tActiveSortedSections),
          ),
          // Categories loaded for the active category section.
          const HomeState(
            categoriesState: BaseState(data: CommerceFixtures.tCategories),
            bestSellerState: BaseState(data: CommerceFixtures.tBestSellers),
            sectionsState: BaseState(data: CommerceFixtures.tActiveSortedSections),
          ),
        ],
        verify: (_) {
          verify(mockGetSectionsUseCase.call()).called(1);
          verify(mockGetBestSellerUseCase.call()).called(1);
          verify(mockGetCategoriesUseCase.call()).called(1);
          // No active occasion section in the fixture data.
          verifyNever(mockGetOccasionsUseCase.call());
        },
      );

      blocTest<HomeCubit, HomeState>(
        'emits loading then error state when fetching sections fails',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetSectionEvent()),
        setUp: () {
          final tError =
              ErrorResponce<List<SectionEntity>>(Exception('server error'));
          when(mockGetSectionsUseCase.call()).thenAnswer((_) async => tError);
        },
        expect: () {
          final tError =
              ErrorResponce<List<SectionEntity>>(Exception('server error'));
          return [
            const HomeState(),
            HomeState(
              sectionsState: BaseState(errorMessage: tError.errorMessage),
            ),
          ];
        },
        verify: (_) {
          verify(mockGetSectionsUseCase.call()).called(1);
          verifyNever(mockGetCategoriesUseCase.call());
          verifyNever(mockGetBestSellerUseCase.call());
        },
      );
    });

    group('GetOccasionEvent', () {
      blocTest<HomeCubit, HomeState>(
        'emits loading then loaded occasions when it succeeds',
        build: buildCubit,
        act: (cubit) => cubit.doEvent(GetOccasionEvent()),
        setUp: () {
          when(mockGetOccasionsUseCase.call()).thenAnswer(
            (_) async => SuccessResponce(CommerceFixtures.tOccasions),
          );
        },
        expect: () => [
          const HomeState(),
          HomeState(occasionState: BaseState(data: CommerceFixtures.tOccasions)),
        ],
        verify: (_) => verify(mockGetOccasionsUseCase.call()).called(1),
      );
    });
  });
}
