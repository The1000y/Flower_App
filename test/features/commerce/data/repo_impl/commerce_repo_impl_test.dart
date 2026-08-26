import 'package:flower_app/features/commerce/data/repo_impl/commerce_repo_impl.dart'
    show CommerceRepoImpl;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/item_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';

class MockCommerceLocalDataSource extends Mock
    implements CommerceLocalDataSource {}

void main() {
  late MockCommerceLocalDataSource mockLocalDataSource;
  late CommerceRepoImpl commerceRepo;

  setUp(() {
    mockLocalDataSource = MockCommerceLocalDataSource();
    commerceRepo = CommerceRepoImpl(localDataSource: mockLocalDataSource);
  });

  group('getCategories', () {
    test(
      'should return SuccessResponce with mapped categories when local data source succeeds',
      () async {
        final categoryDto = CategoryDto(
          id: 1,
          name: 'Roses',
          iconUrl: 'https://example.com/rose.png',
        );

        when(() => mockLocalDataSource.getCategories()).thenAnswer(
          (_) async => SuccessResponce<List<CategoryDto>>([categoryDto]),
        );

        final result = await commerceRepo.getCategories();

        expect(result, isA<SuccessResponce<List<CategoryEntity>>>());

        final success = result as SuccessResponce<List<CategoryEntity>>;

        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.name, 'Roses');
        expect(success.data.first.iconUrl, 'https://example.com/rose.png');

        verify(() => mockLocalDataSource.getCategories()).called(1);
      },
    );

    test('should throw ErrorResponce when local data source fails', () async {
      final exception = Exception('Failed to get categories');

      when(() => mockLocalDataSource.getCategories()).thenAnswer(
        (_) async => ErrorResponce<List<CategoryDto>>(exception),
      );

      expect(
        () => commerceRepo.getCategories(),
        throwsA(isA<ErrorResponce<dynamic>>()),
      );

      verify(() => mockLocalDataSource.getCategories()).called(1);
    });
  });

  group('getBestSeller', () {
    test(
      'should return SuccessResponce with mapped best sellers',
      () async {
        final itemDto = ItemDto(
          id: 1,
          name: 'Red Rose Bouquet',
          imageUrl: 'https://example.com/rose.png',
          currency: 'SAR',
          price: 150,
          originalPrice: 200,
          discountPercentage: 25,
          status: 'available',
        );

        when(() => mockLocalDataSource.getBestSellers()).thenAnswer(
          (_) async => SuccessResponce<List<ItemDto>>([itemDto]),
        );

        final result = await commerceRepo.getBestSeller();

        expect(result, isA<SuccessResponce<List<BestSellerEntity>>>());

        final success = result as SuccessResponce<List<BestSellerEntity>>;

        expect(success.data.length, 1);
        expect(success.data.first.id, 1);
        expect(success.data.first.name, 'Red Rose Bouquet');

        verify(() => mockLocalDataSource.getBestSellers()).called(1);
      },
    );
  });
}
