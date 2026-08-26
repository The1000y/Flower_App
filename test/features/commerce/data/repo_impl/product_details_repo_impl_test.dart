import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/data/data_source/local_data_source/product_details_local_data_source.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_dto.dart';
import 'package:flower_app/features/commerce/data/model/responce/product_details_response/product_details_response_dto.dart';
import 'package:flower_app/features/commerce/data/repo_impl/product_details_repo_impl.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'product_details_repo_impl_test.mocks.dart';

@GenerateMocks([ProductDetailsLocalDataSource])
void main() {
  provideDummy<BaseResponce<ProductDetailsResponseDto>>(
    ErrorResponce(Exception('dummy')),
  );
  late ProductDetailsRepoImpl repository;
  late MockProductDetailsLocalDataSource mockLocalDataSource;

  setUp(() {
    mockLocalDataSource = MockProductDetailsLocalDataSource();
    repository = ProductDetailsRepoImpl(mockLocalDataSource);
  });

  final tProductDto = ProductDetailsDto(
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

  final tResponseDto = ProductDetailsResponseDto(
    data: tProductDto,
    isSuccess: true,
    message: '',
    errorCode: '',
  );

  test('should return SuccessResponce with data when local data source is successful', () async {
    // arrange
    when(mockLocalDataSource.getProductDetails(any))
        .thenAnswer((_) async => SuccessResponce(tResponseDto));

    // act
    final result = await repository.getProductDetails(1);

    // assert
    expect(result, isA<SuccessResponce<ProductDetailsEntity>>());
    verify(mockLocalDataSource.getProductDetails(1));
  });

  test('should return ErrorResponce when local data source fails', () async {
    // arrange
    final tException = Exception('error');
    when(mockLocalDataSource.getProductDetails(any))
        .thenAnswer((_) async => ErrorResponce(tException));

    // act
    final result = await repository.getProductDetails(1);

    // assert
    expect(result, isA<ErrorResponce<ProductDetailsEntity>>());
    expect((result as ErrorResponce).error, tException);
  });
}
