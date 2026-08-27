import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/config/base/base_state.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
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

  final tOccasions = [
    OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'url'),
  ];

  final tProduct = ProductEntity(
    id: 1,
    name: 'Red Rose',
    imageUrl: 'https://example.com/rose.png',
    currency: 'EGP',
    price: 250,
    status: 'Available',
  );

  final tPaginationPage1HasNext = PaginationEntity(
    page: 1,
    pageSize: 10,
    totalCount: 20,
    totalPages: 2,
    hasNextPage: true,
    hasPreviousPage: false,
  );

  final tPaginationPage1NoNext = PaginationEntity(
    page: 1,
    pageSize: 10,
    totalCount: 1,
    totalPages: 1,
    hasNextPage: false,
    hasPreviousPage: false,
  );

  final tPaginationPage2NoNext = PaginationEntity(
    page: 2,
    pageSize: 10,
    totalCount: 20,
    totalPages: 2,
    hasNextPage: false,
    hasPreviousPage: true,
  );

  final tPaginatedProductsPage1 = PaginatedProducts(
    items: [tProduct],
    pagination: tPaginationPage1NoNext,
  );

  setUp(() {
    mockGetOccasionsUseCase = MockGetOccasionsUseCase();
    mockGetProductsUseCase = MockGetProductsUseCase();
    occasionCubit = OccasionCubit(mockGetOccasionsUseCase, mockGetProductsUseCase);
  });

  tearDown(() {
    occasionCubit.close();
  });

  group('LoadOccasions', () {
    blocTest<OccasionCubit, OccasionState>(
      'emits occasions then auto-loads products for the first occasion on success',
      build: () {
        when(() => mockGetOccasionsUseCase.execute())
            .thenAnswer((_) async => SuccessResponce<List<OccasionEntity>>(tOccasions));
        when(() => mockGetProductsUseCase.execute(1, page: 1))
            .thenAnswer((_) async => SuccessResponce<PaginatedProducts>(tPaginatedProductsPage1));
        return occasionCubit;
      },
      act: (cubit) => cubit.handle(LoadOccasions()),
      expect: () => [
        isA<OccasionState>()
            .having((s) => s.occasionsState.isLoading, 'occasions loading', true),
        isA<OccasionState>()
            .having((s) => s.occasionsState.isLoading, 'occasions loading', false)
            .having((s) => s.occasionsState.data, 'occasions data', tOccasions),
        isA<OccasionState>()
            .having((s) => s.productsState.isLoading, 'products loading', true)
            .having((s) => s.currentOccasionId, 'current occasion', 1),
        isA<OccasionState>()
            .having((s) => s.productsState.isLoading, 'products loading', false)
            .having((s) => s.productsState.data, 'products data', [tProduct])
            .having((s) => s.pagination, 'pagination', tPaginationPage1NoNext)
            .having((s) => s.currentOccasionId, 'current occasion', 1),
      ],
      verify: (_) {
        verify(() => mockGetOccasionsUseCase.execute()).called(1);
        verify(() => mockGetProductsUseCase.execute(1, page: 1)).called(1);
      },
    );

    blocTest<OccasionCubit, OccasionState>(
      'emits an error state when getOccasions fails',
      build: () {
        final exception = Exception('Failed to get occasions');
        when(() => mockGetOccasionsUseCase.execute())
            .thenAnswer((_) async => ErrorResponce<List<OccasionEntity>>(exception));
        return occasionCubit;
      },
      act: (cubit) => cubit.handle(LoadOccasions()),
      expect: () => [
        isA<OccasionState>()
            .having((s) => s.occasionsState.isLoading, 'occasions loading', true),
        isA<OccasionState>()
            .having((s) => s.occasionsState.isLoading, 'occasions loading', false)
            .having((s) => s.occasionsState.errorMessage.isNotEmpty, 'has error', true),
      ],
      verify: (_) {
        verify(() => mockGetOccasionsUseCase.execute()).called(1);
        verifyNever(() => mockGetProductsUseCase.execute(any(), page: any(named: 'page')));
      },
    );
  });

  group('LoadProductsForOccasion', () {
    blocTest<OccasionCubit, OccasionState>(
      'emits products for the requested occasion on success',
      build: () {
        when(() => mockGetProductsUseCase.execute(5, page: 1))
            .thenAnswer((_) async => SuccessResponce<PaginatedProducts>(tPaginatedProductsPage1));
        return occasionCubit;
      },
      act: (cubit) => cubit.handle(LoadProductsForOccasion(5)),
      expect: () => [
        isA<OccasionState>()
            .having((s) => s.productsState.isLoading, 'products loading', true)
            .having((s) => s.currentOccasionId, 'current occasion', 5),
        isA<OccasionState>()
            .having((s) => s.productsState.isLoading, 'products loading', false)
            .having((s) => s.productsState.data, 'products data', [tProduct])
            .having((s) => s.currentOccasionId, 'current occasion', 5),
      ],
    );

    blocTest<OccasionCubit, OccasionState>(
      'emits an error state when getProducts fails',
      build: () {
        final exception = Exception('Failed to get products');
        when(() => mockGetProductsUseCase.execute(5, page: 1))
            .thenAnswer((_) async => ErrorResponce<PaginatedProducts>(exception));
        return occasionCubit;
      },
      act: (cubit) => cubit.handle(LoadProductsForOccasion(5)),
      expect: () => [
        isA<OccasionState>()
            .having((s) => s.productsState.isLoading, 'products loading', true),
        isA<OccasionState>()
            .having((s) => s.productsState.isLoading, 'products loading', false)
            .having((s) => s.productsState.errorMessage.isNotEmpty, 'has error', true),
      ],
    );

    test(
      'discards a stale response when the occasion changes before it resolves',
          () async {
        final completer = Completer<BaseResponce<PaginatedProducts>>();
        when(() => mockGetProductsUseCase.execute(1, page: 1))
            .thenAnswer((_) => completer.future);
        when(() => mockGetProductsUseCase.execute(2, page: 1)).thenAnswer(
              (_) async => SuccessResponce<PaginatedProducts>(tPaginatedProductsPage1),
        );

        occasionCubit.handle(LoadProductsForOccasion(1));
        await Future<void>.delayed(Duration.zero);

        occasionCubit.handle(LoadProductsForOccasion(2));
        await Future<void>.delayed(Duration.zero);

        // The occasion-1 request resolves after occasion 2 is already active
        // — its response must be dropped, not appended/applied.
        completer.complete(SuccessResponce<PaginatedProducts>(
          PaginatedProducts(items: [], pagination: tPaginationPage1NoNext),
        ));
        await Future<void>.delayed(Duration.zero);

        expect(occasionCubit.state.currentOccasionId, 2);
        expect(occasionCubit.state.productsState.data, [tProduct]);
      },
    );
  });

  group('LoadMoreProducts', () {
    blocTest<OccasionCubit, OccasionState>(
      'appends the next page to the existing products and advances pagination',
      seed: () => OccasionState(
        productsState: BaseState<List<ProductEntity>>(data: [tProduct]),
        pagination: tPaginationPage1HasNext,
        currentOccasionId: 1,
      ),
      build: () {
        when(() => mockGetProductsUseCase.execute(1, page: 2)).thenAnswer(
              (_) async => SuccessResponce<PaginatedProducts>(
            PaginatedProducts(items: [tProduct], pagination: tPaginationPage2NoNext),
          ),
        );
        return occasionCubit;
      },
      act: (cubit) => cubit.handle(LoadMoreProducts()),
      expect: () => [
        isA<OccasionState>()
            .having((s) => s.isLoadingMore, 'loading more', true),
        isA<OccasionState>()
            .having((s) => s.isLoadingMore, 'loading more', false)
            .having((s) => s.productsState.data, 'products data', [tProduct, tProduct])
            .having((s) => s.pagination, 'pagination', tPaginationPage2NoNext),
      ],
      verify: (_) {
        verify(() => mockGetProductsUseCase.execute(1, page: 2)).called(1);
      },
    );

    blocTest<OccasionCubit, OccasionState>(
      'does nothing when there is no next page',
      seed: () => OccasionState(
        productsState: BaseState<List<ProductEntity>>(data: [tProduct]),
        pagination: tPaginationPage1NoNext,
        currentOccasionId: 1,
      ),
      build: () => occasionCubit,
      act: (cubit) => cubit.handle(LoadMoreProducts()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetProductsUseCase.execute(any(), page: any(named: 'page')));
      },
    );

    blocTest<OccasionCubit, OccasionState>(
      'does nothing when no occasion has been selected yet (initial state)',
      build: () => occasionCubit,
      act: (cubit) => cubit.handle(LoadMoreProducts()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockGetProductsUseCase.execute(any(), page: any(named: 'page')));
      },
    );
  });
}