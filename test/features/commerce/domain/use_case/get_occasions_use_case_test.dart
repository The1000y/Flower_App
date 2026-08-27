import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/commerce/domain/entities/occasion/occasion_entity.dart';
import 'package:flower_app/features/commerce/domain/repo/commerce_repo.dart';
import 'package:flower_app/features/commerce/domain/use_case/get_occasions_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCommerceRepo extends Mock implements CommerceRepo {}

void main() {
  late MockCommerceRepo mockCommerceRepo;
  late GetOccasionsUseCase getOccasionsUseCase;

  setUp(() {
    mockCommerceRepo = MockCommerceRepo();
    getOccasionsUseCase = GetOccasionsUseCase(mockCommerceRepo);
  });

  test('should call getOccasions on repository and return SuccessResponce with list of occasions', () async {
    final tOccasions = [OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'url')];
    when(() => mockCommerceRepo.getOccasions())
        .thenAnswer((_) async => SuccessResponce<List<OccasionEntity>>(tOccasions));

    final result = await getOccasionsUseCase.execute();

    expect(result, isA<SuccessResponce<List<OccasionEntity>>>());
    expect((result as SuccessResponce<List<OccasionEntity>>).data, tOccasions);
    verify(() => mockCommerceRepo.getOccasions()).called(1);
    verifyNoMoreInteractions(mockCommerceRepo);
  });

  test('should propagate ErrorResponce when repository fails', () async {
    final exception = Exception('Failed to get occasions');
    when(() => mockCommerceRepo.getOccasions())
        .thenAnswer((_) async => ErrorResponce<List<OccasionEntity>>(exception));

    final result = await getOccasionsUseCase.execute();

    expect(result, isA<ErrorResponce<List<OccasionEntity>>>());
    verify(() => mockCommerceRepo.getOccasions()).called(1);
    verifyNoMoreInteractions(mockCommerceRepo);
  });
}