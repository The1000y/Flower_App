import 'package:flower_app/features/commerce/data/repo_impl/commerce_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/remote_data_source/commerce_remote_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/occasion_response/occasion_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/pagination_entity.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

class MockCommerceRemoteDataSource extends Mock
    implements CommerceRemoteDataSource {}

void main() {
  late MockCommerceRemoteDataSource mockRemoteDataSource;
  late CommerceRepoImpl commerceRepo;

  setUp(() {
    mockRemoteDataSource = MockCommerceRemoteDataSource();
    commerceRepo = CommerceRepoImpl(mockRemoteDataSource);
  });

  group('getOccasions', () {
    test(
      'should return List<OccasionEntity> when remote data source succeeds',
      () async {
        // Arrange
        final occasionDto = OccasionDto(
          id: 1,
          name: 'Birthday',
          imageUrl: 'https://example.com/birthday.png',
        );

        when(() => mockRemoteDataSource.getOccasions()).thenAnswer(
          (_) async => SuccessResponce<List<OccasionDto>>([occasionDto]),
        );

        // Act
        final result = await commerceRepo.getOccasions();

        // Assert
        expect(result, isA<List<OccasionEntity>>());
        expect(result.length, 1);
        expect(result.first.id, 1);
        expect(result.first.name, 'Birthday');
        expect(result.first.imageUrl, 'https://example.com/birthday.png');
        verify(() => mockRemoteDataSource.getOccasions()).called(1);
      },
    );

    test('should throw ErrorResponce when remote data source fails', () async {
      // Arrange
      final exception = Exception('Failed to get occasions');
      when(() => mockRemoteDataSource.getOccasions()).thenAnswer(
        (_) async => ErrorResponce<List<OccasionDto>>(exception),
      );

      // Act & Assert
      expect(
        () async => await commerceRepo.getOccasions(),
        throwsA(isA<ErrorResponce>()),
      );
      verify(() => mockRemoteDataSource.getOccasions()).called(1);
    });
  });

  group('getProducts', () {
    test(
      'should return PaginatedProducts when remote data source succeeds',
      () async {
        // Arrange
        final productDto = ProductDto(
          id: 1,
          name: 'Red Rose',
          imageUrl: 'https://example.com/rose.png',
          currency: 'EGP',
          price: 250,
          originalPrice: 300,
          discountPercentage: 16.67,
          status: 'Available',
        );

        final paginationDto = PaginationDto(
          page: 1,
          pageSize: 10,
          totalPages: 1,
          totalCount: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        );

        final responseDto = ProductsResponseDto(
          data: ProductListDataDto(
            items: [productDto],
            pagination: paginationDto,
          ),
          isSuccess: true,
          message: 'Success',
          errorCode: '',
        );

        when(() => mockRemoteDataSource.getProducts(1, page: 1)).thenAnswer(
          (_) async => SuccessResponce<ProductsResponseDto>(responseDto),
        );

        // Act
        final result = await commerceRepo.getProducts(1, page: 1);

        // Assert
        expect(result, isA<PaginatedProducts>());
        expect(result.items.length, 1);
        expect(result.items.first.id, 1);
        expect(result.items.first.name, 'Red Rose');
        expect(result.items.first.price, 250);
        expect(result.pagination.page, 1);
        verify(() => mockRemoteDataSource.getProducts(1, page: 1)).called(1);
      },
    );

    test('should throw ErrorResponce when remote data source fails', () async {
      // Arrange
      final exception = Exception('Failed to get products');
      when(() => mockRemoteDataSource.getProducts(1, page: 1)).thenAnswer(
        (_) async => ErrorResponce<ProductsResponseDto>(exception),
      );

      // Act & Assert
      expect(
        () async => await commerceRepo.getProducts(1, page: 1),
        throwsA(isA<ErrorResponce>()),
      );
      verify(() => mockRemoteDataSource.getProducts(1, page: 1)).called(1);
    });
  });
}
