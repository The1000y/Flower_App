import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/presentation/categories/manager/cubit/categories_cubit.dart';
import 'package:flower_app/features/commerce/presentation/categories/manager/cubit/categories_event.dart';
import 'package:flower_app/features/commerce/presentation/categories/manager/cubit/categories_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_categories_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_product_use_case.dart';

class MockGetCategoriesUseCase extends Mock
    implements GetCategoriesUseCase {}

class MockGetProductUseCase extends Mock
    implements GetProductUseCase {}

void main() {
  late MockGetCategoriesUseCase mockGetCategoriesUseCase;
  late MockGetProductUseCase mockGetProductUseCase;

  late CategoriesCubit categoriesCubit;

  setUp(() {
    mockGetCategoriesUseCase = MockGetCategoriesUseCase();
    mockGetProductUseCase = MockGetProductUseCase();

    categoriesCubit = CategoriesCubit(
      mockGetCategoriesUseCase,
      mockGetProductUseCase,
    );
  });

  tearDown(() {
    categoriesCubit.close();
  });

  group('CategoriesCubit', () {
    blocTest<CategoriesCubit, CategoriesState>(
      'should emit loading then success when GetCategoriesEvent succeeds',
      build: () {
        final categories = <CategoryEntity>[
          CategoryEntity(
            id: 1,
            name: 'Roses',
            iconUrl: 'https://example.com/rose.png',
          ),
        ];

        when(
          () => mockGetCategoriesUseCase.call(),
        ).thenAnswer(
          (_) async => SuccessResponce<List<CategoryEntity>>(
            categories,
          ),
        );

        return categoriesCubit;
      },
      act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
      expect: () => [
        CategoriesState(
          categoriesState: BaseState<List<CategoryEntity>>(
            isLoading: true,
            data: null,
            errorMessage: '',
          ),
        ),
        CategoriesState(
          categoriesState: BaseState<List<CategoryEntity>>(
            isLoading: false,
            data: [
              CategoryEntity(
                id: 1,
                name: 'Roses',
                iconUrl: 'https://example.com/rose.png',
              ),
            ],
            errorMessage: '',
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetCategoriesUseCase.call(),
        ).called(1);
      },
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'should emit loading then error when GetCategoriesEvent fails',
      build: () {
        final exception = Exception('Failed to get categories');

        when(
          () => mockGetCategoriesUseCase.call(),
        ).thenAnswer(
          (_) async => ErrorResponce<List<CategoryEntity>>(
            exception,
          ),
        );

        return categoriesCubit;
      },
      act: (cubit) => cubit.doEvent(GetCategoriesEvent()),
      expect: () => [
        CategoriesState(
          categoriesState: BaseState<List<CategoryEntity>>(
            isLoading: true,
            data: null,
            errorMessage: '',
          ),
        ),
        CategoriesState(
          categoriesState: BaseState<List<CategoryEntity>>(
            isLoading: false,
            data: null,
            errorMessage: Exception('Failed to get categories').toString(),
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetCategoriesUseCase.call(),
        ).called(1);
      },
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'should emit loading then success when GetProductsEvent succeeds',
      build: () {
        final products = <ProductEntity>[
          ProductEntity(
            id: 1,
            name: 'Red Rose',
            imageUrl: 'https://example.com/rose.png',
            currency: 'EGP',
            price: 250,
            originalPrice: 300,
            discountPercentage: 16.67,
            status: 'Available',
          ),
        ];

        when(
          () => mockGetProductUseCase.call(),
        ).thenAnswer(
          (_) async => SuccessResponce<List<ProductEntity>>(
            products,
          ),
        );

        return categoriesCubit;
      },
      act: (cubit) => cubit.doEvent(GetProductsEvent()),
      expect: () => [
        CategoriesState(
          productsState: BaseState<List<ProductEntity>>(
            isLoading: true,
            data: null,
            errorMessage: '',
          ),
        ),
        CategoriesState(
          productsState: BaseState<List<ProductEntity>>(
            isLoading: false,
            data: [
              ProductEntity(
                id: 1,
                name: 'Red Rose',
                imageUrl: 'https://example.com/rose.png',
                currency: 'EGP',
                price: 250,
                originalPrice: 300,
                discountPercentage: 16.67,
                status: 'Available',
              ),
            ],
            errorMessage: '',
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetProductUseCase.call(),
        ).called(1);
      },
    );

    blocTest<CategoriesCubit, CategoriesState>(
      'should emit loading then error when GetProductsEvent fails',
      build: () {
        final exception = Exception('Failed to get products');

        when(
          () => mockGetProductUseCase.call(),
        ).thenAnswer(
          (_) async => ErrorResponce<List<ProductEntity>>(
            exception,
          ),
        );

        return categoriesCubit;
      },
      act: (cubit) => cubit.doEvent(GetProductsEvent()),
      expect: () => [
        CategoriesState(
          productsState: BaseState<List<ProductEntity>>(
            isLoading: true,
            data: null,
            errorMessage: '',
          ),
        ),
        CategoriesState(
          productsState: BaseState<List<ProductEntity>>(
            isLoading: false,
            data: null,
            errorMessage: Exception('Failed to get products').toString(),
          ),
        ),
      ],
      verify: (_) {
        verify(
          () => mockGetProductUseCase.call(),
        ).called(1);
      },
    );
  });
}