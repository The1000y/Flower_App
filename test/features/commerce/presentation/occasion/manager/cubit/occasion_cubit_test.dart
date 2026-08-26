import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_occasions_use_case.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_products_use_case.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_cubit.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_event.dart';
import 'package:flower_app/features/commerce/presentation/occasion/manager/cubit/occasion_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGetOccasionsUseCase extends Mock implements GetOccasionsUseCase {}
class MockGetProductsUseCase extends Mock implements GetProductsUseCase {}

void main() {
  late MockGetOccasionsUseCase mockGetOccasionsUseCase;
  late MockGetProductsUseCase mockGetProductsUseCase;
  late OccasionCubit occasionCubit;

  setUp(() {
    mockGetOccasionsUseCase = MockGetOccasionsUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    occasionCubit = OccasionCubit(mockGetOccasionsUseCase, mockGetProductsUseCase);
  });

  tearDown(() {
    occasionCubit.close();
  });

  group('OccasionCubit', () {
    final tOccasions = [
      OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'url'),
    ];
    final tPaginatedProducts = PaginatedProducts(
      items: [],
      pagination: PaginationEntity(
        page: 1,
        pageSize: 10,
        totalCount: 0,
        totalPages: 0,
        hasNextPage: false,
        hasPreviousPage: false,
      ),
    );

    blocTest<OccasionCubit, OccasionState>(
      'emits loading and success states when LoadOccasions succeeds',
      build: () {
        when(() => mockGetOccasionsUseCase.execute()).thenAnswer((_) async => tOccasions);
        when(() => mockGetProductsUseCase.execute(1, page: 1)).thenAnswer((_) async => tPaginatedProducts);
        return occasionCubit;
      },
      act: (cubit) => cubit.handle(LoadOccasions()),
      expect: () => [
        const OccasionState(isLoadingOccasions: true, occasionsError: ''),
        OccasionState(
          isLoadingOccasions: false,
          occasions: tOccasions,
          isLoadingProducts: false,
          productsError: '',
          products: [],
        ),
        OccasionState(
          isLoadingOccasions: false,
          occasions: tOccasions,
          isLoadingProducts: true,
          productsError: '',
          products: [],
        ),
        OccasionState(
          isLoadingOccasions: false,
          occasions: tOccasions,
          isLoadingProducts: false,
          isLoadingMore: false,
          products: [],
          pagination: tPaginatedProducts.pagination,
          currentOccasionId: 1,
        ),
      ],
    );
  });
}
