import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/products/product_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/best_seller_repo.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_best_seller_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_best_seller_use_case_test.mocks.dart';

@GenerateMocks([BestSellerRepo])
void main() {
  provideDummy<BaseResponce<List<ProductEntity>>>(SuccessResponce([]));
  late GetBestSellerUseCase useCase;
  late MockBestSellerRepo mockRepo;

  setUp(() {
    mockRepo = MockBestSellerRepo();
    useCase = GetBestSellerUseCase(mockRepo);
  });

  final tProducts = [
    ProductEntity(
      id: 1,
      name: 'Test Product',
      imageUrl: 'url',
      currency: 'USD',
      price: 100.0,
      status: 'active',
    ),
  ];

  test('should call getBestSeller from repository', () async {
    // arrange
    when(mockRepo.getBestSeller(page: anyNamed('page')))
        .thenAnswer((_) async => SuccessResponce(tProducts));

    // act
    final result = await useCase.execute(page: 1);

    // assert
    expect(result, isA<SuccessResponce<List<ProductEntity>>>());
    verify(mockRepo.getBestSeller(page: 1));
    verifyNoMoreInteractions(mockRepo);
  });

  test('should return ErrorResponce when repository fails', () async {
    // arrange
    final tException = Exception('error');
    when(mockRepo.getBestSeller(page: anyNamed('page')))
        .thenAnswer((_) async => ErrorResponce(tException));

    // act
    final result = await useCase.execute(page: 1);

    // assert
    expect(result, isA<ErrorResponce<List<ProductEntity>>>());
    verify(mockRepo.getBestSeller(page: 1));
  });
}
