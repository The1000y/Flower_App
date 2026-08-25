import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/product_details/product_details_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/product_details_repo.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_product_details_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_product_details_use_case_test.mocks.dart';

@GenerateMocks([ProductDetailsRepo])
void main() {
  provideDummy<BaseResponce<ProductDetailsEntity>>(
    ErrorResponce(Exception('dummy')),
  );
  late GetProductDetailsUseCase useCase;
  late MockProductDetailsRepo mockRepository;

  setUp(() {
    mockRepository = MockProductDetailsRepo();
    useCase = GetProductDetailsUseCase(mockRepository);
  });

  final tProductEntity = ProductDetailsEntity(
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

  test('should call getProductDetails from repository', () async {
    // arrange
    when(mockRepository.getProductDetails(any))
        .thenAnswer((_) async => SuccessResponce(tProductEntity));

    // act
    final result = await useCase.execute(1);

    // assert
    expect(result, isA<SuccessResponce<ProductDetailsEntity>>());
    expect((result as SuccessResponce).data, tProductEntity);
    verify(mockRepository.getProductDetails(1));
    verifyNoMoreInteractions(mockRepository);
  });
}
