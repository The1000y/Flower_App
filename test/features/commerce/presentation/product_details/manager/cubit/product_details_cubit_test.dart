import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_product_details_use_case.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_cubit.dart';
import 'package:flower_app/features/commerce/presentation/product_details/manager/cubit/product_details_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_cubit_test.mocks.dart';

@GenerateMocks([GetProductDetailsUseCase])
void main() {
  provideDummy<BaseResponce<ProductDetailsEntity>>(
    ErrorResponce(Exception('dummy')),
  );
  late ProductDetailsCubit cubit;
  late MockGetProductDetailsUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockGetProductDetailsUseCase();
    cubit = ProductDetailsCubit(mockUseCase);
  });

  final tProductEntity = ProductDetailsEntity(
    id: 1,
    name: 'Test',
    imageUrl: '',
    currency: '',
    price: 0,
    status: '',
    images: [],
    description: '',
    includes: [],
    occasionIds: [],
  );

  test('initial state should be ProductDetailsState', () {
    expect(cubit.state, const ProductDetailsState());
  });

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'emits [loading: true, loading: false, data: tProductEntity] when getProductDetails is successful',
    build: () {
      when(mockUseCase.execute(any))
          .thenAnswer((_) async => SuccessResponce(tProductEntity));
      return cubit;
    },
    act: (cubit) => cubit.getProductDetails(1),
    expect: () => [
      const ProductDetailsState(isLoading: true, errorMessage: ''),
      ProductDetailsState(isLoading: false, data: tProductEntity),
    ],
    verify: (_) {
      verify(mockUseCase.execute(1));
    },
  );

  blocTest<ProductDetailsCubit, ProductDetailsState>(
    'emits [loading: true, loading: false, errorMessage: "error"] when getProductDetails fails',
    build: () {
      when(mockUseCase.execute(any))
          .thenAnswer((_) async => ErrorResponce(Exception('error')));
      return cubit;
    },
    act: (cubit) => cubit.getProductDetails(1),
    expect: () => [
      const ProductDetailsState(isLoading: true, errorMessage: ''),
      const ProductDetailsState(isLoading: false, errorMessage: 'something went wrong, pls try again'),
    ],
  );
}
