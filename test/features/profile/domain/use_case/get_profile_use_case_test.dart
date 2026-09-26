import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/get_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late GetProfileUseCase useCase;
  late MockProfileRepo mockRepo;

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = GetProfileUseCase(mockRepo);
  });

  test('should call getProfile from the repository', () async {
    // Arrange
    final entity = const ProfileEntity(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phoneNumber: '01000000000',
      gender: 'Male',
    );
    when(() => mockRepo.getProfile())
        .thenAnswer((_) async => SuccessResponce(entity));

    // Act
    final result = await useCase();

    // Assert
    expect(result, isA<SuccessResponce<ProfileEntity>>());
    verify(() => mockRepo.getProfile()).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
