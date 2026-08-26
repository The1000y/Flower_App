import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_best_seller_use_case.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/manager/cubit/best_seller_cubit.dart';
import 'package:flower_app/features/commerce/presentation/best_seller/manager/cubit/best_seller_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_cubit_test.mocks.dart';

@GenerateMocks([GetBestSellerUseCase])
void main() {
  provideDummy<BaseResponce<List<ProductEntity>>>(SuccessResponce([]));
  late BestSellerCubit cubit;
  late MockGetBestSellerUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetBestSellerUseCase();
    cubit = BestSellerCubit(mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  final tProducts = [
    ProductEntity(
      id: 1,
      name: 'Test',
      imageUrl: 'url',
      currency: 'USD',
      price: 100.0,
      status: 'active',
    ),
  ];

  test('initial state should be correct', () {
    expect(cubit.state, const BestSellerState());
  });

  blocTest<BestSellerCubit, BestSellerState>(
    'emits [isLoading: true, data: tProducts] when getBestSeller is successful',
    build: () {
      when(mockUseCase.execute(page: anyNamed('page')))
          .thenAnswer((_) async => SuccessResponce(tProducts));
      return cubit;
    },
    act: (cubit) => cubit.getBestSeller(),
    expect: () => [
      const BestSellerState(isLoading: true, errorMessage: '', currentPage: 1, hasMore: true),
      BestSellerState(isLoading: false, data: tProducts, hasMore: true),
    ],
  );

  blocTest<BestSellerCubit, BestSellerState>(
    'emits [isLoading: true, errorMessage: error] when getBestSeller fails',
    build: () {
      when(mockUseCase.execute(page: anyNamed('page')))
          .thenAnswer((_) async => ErrorResponce(Exception('error')));
      return cubit;
    },
    act: (cubit) => cubit.getBestSeller(),
    expect: () => [
      const BestSellerState(isLoading: true, errorMessage: '', currentPage: 1, hasMore: true),
      const BestSellerState(isLoading: false, errorMessage: 'something went wrong, pls try again'), 
    ],
  );

  blocTest<BestSellerCubit, BestSellerState>(
    'emits correct states when loadMore is successful',
    build: () {
      when(mockUseCase.execute(page: 1))
          .thenAnswer((_) async => SuccessResponce(tProducts));
      when(mockUseCase.execute(page: 2))
          .thenAnswer((_) async => SuccessResponce(tProducts));
      return cubit;
    },
    act: (cubit) async {
      await cubit.getBestSeller();
      await cubit.loadMore();
    },
    skip: 2, // Skip getBestSeller states
    expect: () => [
      BestSellerState(isLoading: false, data: tProducts, isFetchingMore: true, hasMore: true),
      BestSellerState(
        isLoading: false,
        data: [...tProducts, ...tProducts],
        isFetchingMore: false,
        currentPage: 2,
        hasMore: true,
      ),
    ],
  );
}
