import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/best_seller_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/product_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/products_response_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/products_response/pagination_dto.dart';
import 'package:flower_app/features/commerce/data/repo_impl/best_seller_repo_impl.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'best_seller_repo_impl_test.mocks.dart';

@GenerateMocks([BestSellerLocalDataSource])
void main() {
  provideDummy<ProductsResponseDto>(
    ProductsResponseDto(
      isSuccess: true,
      message: '',
      errorCode: '',
      data: ProductListDataDto(
        items: [],
        pagination: PaginationDto(
          page: 1,
          pageSize: 10,
          totalCount: 0,
          totalPages: 1,
          hasNextPage: false,
          hasPreviousPage: false,
        ),
      ),
    ),
  );
  late BestSellerRepoImpl repository;
  late MockBestSellerLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockBestSellerLocalDataSource();
    repository = BestSellerRepoImpl(mockLocalDataSource);
  });

  final tProductDto = ProductDto(
    id: 1,
    name: 'Test',
    imageUrl: 'url',
    currency: 'USD',
    price: 100.0,
    status: 'active',
  );

  final tPaginationDto = PaginationDto(
    page: 1,
    pageSize: 10,
    totalCount: 1,
    totalPages: 1,
    hasNextPage: false,
    hasPreviousPage: false,
  );

  final tResponseDto = ProductsResponseDto(
    isSuccess: true,
    message: 'Success',
    errorCode: '0',
    data: ProductListDataDto(
      items: [tProductDto],
      pagination: tPaginationDto,
    ),
  );

  test('should return SuccessResponce with ProductEntity list when data source succeeds', () async {
    // arrange
    when(mockLocalDataSource.getBestSeller(page: anyNamed('page')))
        .thenAnswer((_) async => tResponseDto);

    // act
    final result = await repository.getBestSeller(page: 1);

    // assert
    expect(result, isA<SuccessResponce<List<ProductEntity>>>());
    final successResult = result as SuccessResponce<List<ProductEntity>>;
    expect(successResult.data.length, 1);
    expect(successResult.data.first.name, 'Test');
    verify(mockLocalDataSource.getBestSeller(page: 1));
  });

  test('should return ErrorResponce when data source isSuccess is false', () async {
    // arrange
    final failureResponse = ProductsResponseDto(
      isSuccess: false,
      message: 'Failed',
      errorCode: '400',
      data: ProductListDataDto(items: [], pagination: tPaginationDto),
    );
    when(mockLocalDataSource.getBestSeller(page: anyNamed('page')))
        .thenAnswer((_) async => failureResponse);

    // act
    final result = await repository.getBestSeller(page: 1);

    // assert
    expect(result, isA<ErrorResponce<List<ProductEntity>>>());
    final errorResult = result as ErrorResponce<List<ProductEntity>>;
    expect(errorResult.errorMessage, 'something went wrong, pls try again');
  });

  test('should return ErrorResponce when data source throws an exception', () async {
    // arrange
    when(mockLocalDataSource.getBestSeller(page: anyNamed('page')))
        .thenThrow(Exception('No Internet'));

    // act
    final result = await repository.getBestSeller(page: 1);

    // assert
    expect(result, isA<ErrorResponce<List<ProductEntity>>>());
  });
}
