import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
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
  provideDummy<BaseResponce<List<ProductEntity>>>(
    SuccessResponce<List<ProductEntity>>(const []),
  );

  late SearchCubit cubit;
  late MockSearchProductsUseCase mockSearchProductsUseCase;

  setUp(() {
    mockSearchProductsUseCase = MockSearchProductsUseCase();
    cubit = SearchCubit(mockSearchProductsUseCase);
  });

  final tProducts = [
    ProductEntity(
      id: 1,
      name: 'Red Roses Bouquet',
      imageUrl: 'https://example.com/rose.png',
      currency: 'EGP',
      price: 600,
      status: 'InStock',
    ),
  ];

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
      when(mockSearchProductsUseCase.call('rose'))
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));
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
      ),
    ],
    verify: (_) {
      verify(mockSearchProductsUseCase.call('rose')).called(1);
    },
  );

  blocTest<SearchCubit, SearchState>(
    'emits [isLoading: true, errorMessage] when searchProducts fails',
    build: () {
      when(mockSearchProductsUseCase.call('rose'))
          .thenAnswer((_) async => ErrorResponce<List<ProductEntity>>(Exception('Search failed')));
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
      verify(mockSearchProductsUseCase.call('rose')).called(1);
    },
  );
}
