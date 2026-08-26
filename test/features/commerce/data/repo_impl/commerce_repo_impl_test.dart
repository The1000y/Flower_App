    import 'package:flower_app/features/commerce/data/repo_impl/commerce_repo_impl.dart'
        show CommerceRepoImpl;
    import 'package:flutter_test/flutter_test.dart';
    import 'package:mocktail/mocktail.dart';

    import 'package:flower_app/config/base/base_responce.dart';
    import 'package:flower_app/features/commerce/data/data_source/local_data_source/commerce_local_data_source.dart';
    import 'package:flower_app/features/commerce/data/model/responce/categories_response/category_dto.dart';
    import 'package:flower_app/features/commerce/data/model/responce/categories_response/categories_response_dto.dart';
    import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
    import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
    import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
    import 'package:flower_app/features/commerce/domain/entities/categories/categories_entity.dart';
    import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';

    class MockCommerceLocalDataSource extends Mock
        implements CommerceLocalDataSource {}

    void main() {
      late MockCommerceLocalDataSource mockLocalDataSource;
      late CommerceRepoImpl commerceRepo;

      setUp(() {
        mockLocalDataSource = MockCommerceLocalDataSource();
        commerceRepo = CommerceRepoImpl(mockLocalDataSource);
      });

      group('getCategories', () {
        test(
          'should return SuccessResponce with mapped categories when local data source succeeds',
          () async {
            // Arrange
            final categoryDto = CategoryDto(
              id: 1,
              name: 'Roses',
              iconUrl: 'https://example.com/rose.png',
            );

            final responseDto = CategoriesResponseDto(
              data: [categoryDto],
              isSuccess: true,
              message: 'Success',
              errorCode: '',
            );

            when(() => mockLocalDataSource.getCategories()).thenAnswer(
              (_) async =>
                  SuccessResponce<List<CategoriesResponseDto>>([responseDto]),
            );

            // Act
            final result = await commerceRepo.getCategories();

            // Assert
            expect(result, isA<SuccessResponce<List<CategoryEntity>>>());

            final success = result as SuccessResponce<List<CategoryEntity>>;

            expect(success.data.length, 1);
            expect(success.data.first.id, 1);
            expect(success.data.first.name, 'Roses');
            expect(success.data.first.iconUrl, 'https://example.com/rose.png');

            verify(() => mockLocalDataSource.getCategories()).called(1);
          },
        );

        test('should return ErrorResponce when local data source fails', () async {
          // Arrange
          final exception = Exception('Failed to get categories');

          when(() => mockLocalDataSource.getCategories()).thenAnswer(
            (_) async => ErrorResponce<List<CategoriesResponseDto>>(exception),
          );

          // Act
          final result = await commerceRepo.getCategories();

          // Assert
          expect(result, isA<ErrorResponce<List<CategoryEntity>>>());

          final error = result as ErrorResponce<List<CategoryEntity>>;

          expect(error.error, same(exception));

          verify(() => mockLocalDataSource.getCategories()).called(1);
        });
      });

      group('getProducts', () {
        test(
          'should return SuccessResponce with mapped products when local data source succeeds',
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

            when(() => mockLocalDataSource.getProducts()).thenAnswer(
              (_) async => SuccessResponce<ProductsResponseDto>(responseDto),
            );

            // Act
            final result = await commerceRepo.getProducts();

            // Assert
            expect(result, isA<SuccessResponce<List<ProductEntity>>>());

            final success = result as SuccessResponce<List<ProductEntity>>;

            expect(success.data.length, 1);
            expect(success.data.first.id, 1);
            expect(success.data.first.name, 'Red Rose');
            expect(success.data.first.price, 250);
            expect(success.data.first.currency, 'EGP');

            verify(() => mockLocalDataSource.getProducts()).called(1);
          },
        );

        test('should return ErrorResponce when local data source fails', () async {
          // Arrange
          final exception = Exception('Failed to get products');

          when(
            () => mockLocalDataSource.getProducts(),
          ).thenAnswer((_) async => ErrorResponce<ProductsResponseDto>(exception));

          // Act
          final result = await commerceRepo.getProducts();

          // Assert
          expect(result, isA<ErrorResponce<List<ProductEntity>>>());

          final error = result as ErrorResponce<List<ProductEntity>>;

          expect(error.error, same(exception));

          verify(() => mockLocalDataSource.getProducts()).called(1);
        });
      });
    }
