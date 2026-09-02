import 'package:flutter_test/flutter_test.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/model/responce/best_seller/product_Dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/home_response/section_dto.dart';
import 'package:flower_app/features/commerce/data/repo_impl/commerce_repo_impl.dart';
import 'package:flower_app/features/commerce/domain/entities/best_sellers/best_seller_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/home/section_entity.dart';
import 'package:mockito/mockito.dart';

import '../../fixtures/commerce_fixtures.dart';
import '../../mocks/mocks.mocks.dart';
import '../../mocks/test_dummies.dart';

void main() {
  registerCommerceTestDummies();

  late MockCommerceLocalDataSource mockLocalDataSource;
  late CommerceRepoImpl repoImpl;

  setUp(() {
    mockLocalDataSource = MockCommerceLocalDataSource();
    repoImpl = CommerceRepoImpl(localDataSource: mockLocalDataSource);
  });

  group('getCategories', () {
    test(
      'returns SuccessResponce with mapped CategoryEntity list on success',
      () async {
        // Arrange
        when(mockLocalDataSource.getCategories()).thenAnswer(
          (_) async => SuccessResponce<List<CategoryDto>>(
            CommerceFixtures.tCategoryDtos,
          ),
        );

        // Act
        final result = await repoImpl.getCategories();

        // Assert
        expect(result, isA<SuccessResponce<List<CategoryEntity>>>());
        expect(
          (result as SuccessResponce<List<CategoryEntity>>).data,
          equals(CommerceFixtures.tCategories),
        );
        verify(mockLocalDataSource.getCategories()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test('throws ErrorResponce when data source returns an error', () async {
      // Arrange
      when(mockLocalDataSource.getCategories()).thenAnswer(
        (_) async => ErrorResponce<List<CategoryDto>>(Exception('db error')),
      );

      // Act & Assert
      // Note: CommerceRepoImpl throws `ErrorResponce(...)` without a type
      // argument, so the runtime type is ErrorResponce<dynamic>.
      await expectLater(
        repoImpl.getCategories(),
        throwsA(isA<ErrorResponce<dynamic>>()),
      );
      verify(mockLocalDataSource.getCategories()).called(1);
    });
  });

  group('getBestSeller', () {
    test(
      'returns SuccessResponce with mapped BestSellerEntity list on success',
      () async {
        // Arrange
        when(mockLocalDataSource.getBestSellers()).thenAnswer(
          (_) async => SuccessResponce<List<ProductDto>>(
            CommerceFixtures.tBestSellerDtos,
          ),
        );

        // Act
        final result = await repoImpl.getBestSeller();

        // Assert
        expect(result, isA<SuccessResponce<List<BestSellerEntity>>>());
        expect(
          (result as SuccessResponce<List<BestSellerEntity>>).data,
          equals(CommerceFixtures.tBestSellers),
        );
        verify(mockLocalDataSource.getBestSellers()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test('throws ErrorResponce when data source returns an error', () async {
      // Arrange
      when(mockLocalDataSource.getBestSellers()).thenAnswer(
        (_) async => ErrorResponce<List<ProductDto>>(Exception('db error')),
      );

      // Act & Assert
      await expectLater(
        repoImpl.getBestSeller(),
        throwsA(isA<ErrorResponce<dynamic>>()),
      );
      verify(mockLocalDataSource.getBestSellers()).called(1);
    });
  });

  group('getSection', () {
    test(
      'returns SuccessResponce with mapped SectionEntity list on success',
      () async {
        // Arrange
        final expectedEntities = CommerceFixtures.tSectionDtos
            .map((dto) => dto.toDomain())
            .toList();
        when(mockLocalDataSource.getSections()).thenAnswer(
          (_) async =>
              SuccessResponce<List<SectionDto>>(CommerceFixtures.tSectionDtos),
        );

        // Act
        final result = await repoImpl.getSection();

        // Assert
        expect(result, isA<SuccessResponce<List<SectionEntity>>>());
        final data =
            (result as SuccessResponce<List<SectionEntity>>).data;
        expect(data.length, expectedEntities.length);
        for (var i = 0; i < data.length; i++) {
          expect(data[i], equals(expectedEntities[i]));
        }
        verify(mockLocalDataSource.getSections()).called(1);
        verifyNoMoreInteractions(mockLocalDataSource);
      },
    );

    test('throws ErrorResponce when data source returns an error', () async {
      // Arrange
      when(mockLocalDataSource.getSections()).thenAnswer(
        (_) async => ErrorResponce<List<SectionDto>>(Exception('db error')),
      );

      // Act & Assert
      await expectLater(
        repoImpl.getSection(),
        throwsA(isA<ErrorResponce<dynamic>>()),
      );
      verify(mockLocalDataSource.getSections()).called(1);
    });

    test('rethrows the exception when the data source itself throws', () async {
      // Arrange
      when(mockLocalDataSource.getSections()).thenThrow(Exception('crash'));

      // Act & Assert
      await expectLater(repoImpl.getSection(), throwsA(isA<Exception>()));
      verify(mockLocalDataSource.getSections()).called(1);
    });
  });
}
