import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_cubit.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_event.dart';
import 'package:flower_app/features/search/presentation/manger/cubit/search_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_cubit_test.mocks.dart';

@GenerateMocks([SearchProductsUseCase])
void main() {
  provideDummy<BaseResponce<PaginatedProducts>>(
    SuccessResponce<PaginatedProducts>(
      PaginatedProducts(
        items: const [],
        pagination: PaginationEntity(
          page: 1,
          pageSize: 8,
          totalCount: 0,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      ),
    ),
  );

  late SearchCubit cubit;
  late MockSearchProductsUseCase mockSearchProductsUseCase;

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    cubit = SearchCubit(mockSearchProductsUseCase);
  });

  final tProducts = [
    const ProductEntity(
      id: "1",
      name: 'Red Roses Bouquet',
      imageUrl: 'https://example.com/rose.png',
      currency: 'EGP',
      price: 600,
      status: 'InStock',
    ),
    const ProductEntity(
      id: "2",
      name: 'White Tulip Arrangement',
      imageUrl: 'https://example.com/tulip.png',
      currency: 'EGP',
      price: 500,
      status: 'InStock',
    ),
  ];

  PaginatedProducts paginated(
    List<ProductEntity> items, {
    int page = 1,
    int totalCount = 2,
  }) {
    final totalPages = (totalCount / 2).ceil();
    return PaginatedProducts(
      items: items,
      pagination: PaginationEntity(
        page: page,
        pageSize: 2,
        totalCount: totalCount,
        totalPages: totalPages,
        hasNextPage: page < totalPages,
        hasPreviousPage: page > 1,
      ),
    );
  }

  test('initial state should be SearchState() with default values', () {
    expect(cubit.state, equals(const SearchState()));
  });

  blocTest<SearchCubit, SearchState>(
    'should not call SearchProductsUseCase when query is empty or whitespace',
    build: () => cubit,
    act: (cubit) => cubit.doEvent(SearchProductsEvent('   ')),
    expect: () => [
      const SearchState(
        query: '',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: '',
          data: null,
        ),
      ),
    ],
    verify: (_) {
      verifyZeroInteractions(mockSearchProductsUseCase);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'emits [isLoading: true, data: tProducts] when searchProducts succeeds',
    build: () {
      when(mockSearchProductsUseCase.call('rose', page: 1)).thenAnswer(
        (_) async => SuccessResponce<PaginatedProducts>(
          paginated(tProducts, page: 1, totalCount: 2),
        ),
      );
      return cubit;
    },
    act: (cubit) => cubit.doEvent(SearchProductsEvent('rose')),
    expect: () => [
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: '',
          data: tProducts,
        ),
        pagination: paginated(tProducts, page: 1, totalCount: 2).pagination,
      ),
    ],
    verify: (_) {
      verify(mockSearchProductsUseCase.call('rose', page: 1)).called(1);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'emits [isLoading: true, errorMessage] when searchProducts fails',
    build: () {
      when(mockSearchProductsUseCase.call('rose', page: 1)).thenAnswer(
        (_) async =>
            ErrorResponce<PaginatedProducts>(Exception('Search failed')),
      );
      return cubit;
    },
    act: (cubit) => cubit.doEvent(SearchProductsEvent('rose')),
    expect: () => [
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: 'something went wrong, pls try again',
          data: null,
        ),
      ),
    ],
    verify: (_) {
      verify(mockSearchProductsUseCase.call('rose', page: 1)).called(1);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'emits error message when SearchProductsUseCase throws an exception',
    build: () {
      when(mockSearchProductsUseCase.call('rose', page: 1))
          .thenThrow(Exception('boom'));
      return cubit;
    },
    act: (cubit) => cubit.doEvent(SearchProductsEvent('rose')),
    expect: () => [
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: 'something went wrong, pls try again',
          data: null,
        ),
      ),
    ],
    verify: (_) {
      verify(mockSearchProductsUseCase.call('rose', page: 1)).called(1);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'loads next page and appends items when LoadMoreSearchEvent is dispatched',
    build: () {
      when(mockSearchProductsUseCase.call('rose', page: 1)).thenAnswer(
        (_) async => SuccessResponce<PaginatedProducts>(
          paginated([tProducts[0], tProducts[1]], page: 1, totalCount: 4),
        ),
      );
      when(mockSearchProductsUseCase.call('rose', page: 2)).thenAnswer(
        (_) async => SuccessResponce<PaginatedProducts>(
          paginated(
            [
              const ProductEntity(
                id: "3",
                name: 'Rose Gold Vase',
                imageUrl: 'https://example.com/vase.png',
                currency: 'EGP',
                price: 350,
                status: 'InStock',
              ),
              const ProductEntity(
                id: "4",
                name: 'Birthday Cake',
                imageUrl: 'https://example.com/cake.png',
                currency: 'EGP',
                price: 200,
                status: 'InStock',
              ),
            ],
            page: 2,
            totalCount: 4,
          ),
        ),
      );
      return cubit;
    },
    act: (cubit) async {
      cubit.doEvent(SearchProductsEvent('rose'));
      await Future<void>.delayed(Duration.zero);
      cubit.doEvent(LoadMoreSearchEvent());
    },
    expect: () => [
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: '',
          data: [tProducts[0], tProducts[1]],
        ),
        pagination: paginated([tProducts[0], tProducts[1]], page: 1, totalCount: 4)
            .pagination,
      ),
      SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: '',
          data: [tProducts[0], tProducts[1]],
        ),
        isLoadingMore: true,
        pagination: paginated([tProducts[0], tProducts[1]], page: 1, totalCount: 4)
            .pagination,
      ),
      SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: '',
          data: [
            tProducts[0],
            tProducts[1],
            const ProductEntity(
              id: "3",
              name: 'Rose Gold Vase',
              imageUrl: 'https://example.com/vase.png',
              currency: 'EGP',
              price: 350,
              status: 'InStock',
            ),
            const ProductEntity(
              id: "4",
              name: 'Birthday Cake',
              imageUrl: 'https://example.com/cake.png',
              currency: 'EGP',
              price: 200,
              status: 'InStock',
            ),
          ],
        ),
        pagination: paginated(
          const [],
          page: 2,
          totalCount: 4,
        ).pagination,
      ),
    ],
    verify: (_) {
      verify(mockSearchProductsUseCase.call('rose', page: 1)).called(1);
      verify(mockSearchProductsUseCase.call('rose', page: 2)).called(1);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'does not load next page when there is no next page',
    build: () {
      when(mockSearchProductsUseCase.call('rose', page: 1)).thenAnswer(
        (_) async => SuccessResponce<PaginatedProducts>(
          paginated(tProducts, page: 1, totalCount: 2),
        ),
      );
      return cubit;
    },
    act: (cubit) async {
      cubit.doEvent(SearchProductsEvent('rose'));
      await Future<void>.delayed(Duration.zero);
      cubit.doEvent(LoadMoreSearchEvent());
    },
    expect: () => [
      const SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: true,
          errorMessage: '',
          data: null,
        ),
      ),
      SearchState(
        query: 'rose',
        resultState: BaseState<List<ProductEntity>>(
          isLoading: false,
          errorMessage: '',
          data: tProducts,
        ),
        pagination: paginated(tProducts, page: 1, totalCount: 2).pagination,
      ),
    ],
    verify: (_) {
      verify(mockSearchProductsUseCase.call('rose', page: 1)).called(1);
      verifyNever(mockSearchProductsUseCase.call('rose', page: 2));
    },
  );
}