import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/search/domain/usecases/search_products_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'search_products_use_case_test.mocks.dart';

@GenerateMocks([CommerceRepo])
void main() {
  provideDummy<BaseResponce<List<ProductEntity>>>(
    SuccessResponce<List<ProductEntity>>(const []),
  );

  late MockCommerceRepo mockCommerceRepo;
  late SearchProductsUseCase useCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    useCase = SearchProductsUseCase(mockCommerceRepo);
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
  ];

  group('SearchProductsUseCase', () {
    test('should return matching products when query matches by name', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('rose');

      expect(result, isA<SuccessResponce<PaginatedProducts>>());
      final data = (result as SuccessResponce<PaginatedProducts>).data;
      expect(data.items.length, equals(2));
      expect(data.items[0].name, equals('Red Roses Bouquet'));
      expect(data.items[1].name, equals('Rose Gold Vase'));
      expect(data.pagination.hasNextPage, isFalse);
      verify(mockCommerceRepo.getProducts()).called(1);
    });

    test('should be case-insensitive when filtering products', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('TULIP');

      expect(result, isA<SuccessResponce<PaginatedProducts>>());
      final data = (result as SuccessResponce<PaginatedProducts>).data;
      expect(data.items.length, equals(1));
      expect(data.items.first.name, equals('White Tulip Arrangement'));
    });

    test('should match partial substrings in product name', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('Tul');

      expect(result, isA<SuccessResponce<PaginatedProducts>>());
      final data = (result as SuccessResponce<PaginatedProducts>).data;
      expect(data.items.length, equals(1));
      expect(data.items.first.name, equals('White Tulip Arrangement'));
    });

    test('should return empty list when no products match', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('sunflower');

      expect(result, isA<SuccessResponce<PaginatedProducts>>());
      final data = (result as SuccessResponce<PaginatedProducts>).data;
      expect(data.items, isEmpty);
      expect(data.pagination.totalCount, equals(0));
      expect(data.pagination.hasNextPage, isFalse);
    });

    test('should return all products when query matches every name', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('e');

      expect(result, isA<SuccessResponce<PaginatedProducts>>());
      final data = (result as SuccessResponce<PaginatedProducts>).data;
      expect(data.items.length, equals(4));
      expect(data.pagination.totalCount, equals(4));
      expect(data.pagination.hasNextPage, isFalse);
    });

    test('should return ErrorResponce when CommerceRepo.getProducts fails', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => ErrorResponce<List<ProductEntity>>(Exception('Fetch failed')));

      final result = await useCase.call('rose');

      expect(result, isA<ErrorResponce<PaginatedProducts>>());
      verify(mockCommerceRepo.getProducts()).called(1);
    });

    test('should paginate results using page and pageSize', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final pageOne = await useCase.call('e', page: 1, pageSize: 2);
      final pageOneData = (pageOne as SuccessResponce<PaginatedProducts>).data;
      expect(pageOneData.items.length, equals(2));
      expect(pageOneData.items.map((e) => e.name),
          containsAll(['Red Roses Bouquet', 'White Tulip Arrangement']));
      expect(pageOneData.pagination.page, equals(1));
      expect(pageOneData.pagination.pageSize, equals(2));
      expect(pageOneData.pagination.totalCount, equals(4));
      expect(pageOneData.pagination.totalPages, equals(2));
      expect(pageOneData.pagination.hasNextPage, isTrue);
      expect(pageOneData.pagination.hasPreviousPage, isFalse);

      final pageTwo = await useCase.call('e', page: 2, pageSize: 2);
      final pageTwoData = (pageTwo as SuccessResponce<PaginatedProducts>).data;
      expect(pageTwoData.items.length, equals(2));
      expect(pageTwoData.items.map((e) => e.name),
          containsAll(['Rose Gold Vase', 'Birthday Cake']));
      expect(pageTwoData.pagination.page, equals(2));
      expect(pageTwoData.pagination.hasNextPage, isFalse);
      expect(pageTwoData.pagination.hasPreviousPage, isTrue);
    });

    test('should return empty items when requesting a page beyond the last', () async {
      when(mockCommerceRepo.getProducts())
          .thenAnswer((_) async => SuccessResponce<List<ProductEntity>>(tProducts));

      final result = await useCase.call('rose');

      expect(result, isA<SuccessResponce<PaginatedProducts>>());
      final data = (result as SuccessResponce<PaginatedProducts>).data;
      expect(data.pagination.totalPages, equals(1));

      final beyondLast = await useCase.call('rose', page: 3, pageSize: 2);
      final beyondLastData =
          (beyondLast as SuccessResponce<PaginatedProducts>).data;
      expect(beyondLastData.items, isEmpty);
      expect(beyondLastData.pagination.hasNextPage, isFalse);
    });
  });
}