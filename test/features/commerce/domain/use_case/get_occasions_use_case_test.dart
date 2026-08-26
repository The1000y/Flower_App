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

  test('should call getOccasions on repository and return list of occasions', () async {
    // Arrange
    final tOccasions = [OccasionEntity(id: 1, name: 'Birthday', imageUrl: 'url')];
    when(() => mockCommerceRepo.getOccasions()).thenAnswer((_) async => tOccasions);

    // Act
    final result = await getOccasionsUseCase.execute();

    // Assert
    expect(result, tOccasions);
    verify(() => mockCommerceRepo.getOccasions()).called(1);
    verifyNoMoreInteractions(mockCommerceRepo);
  });
}
