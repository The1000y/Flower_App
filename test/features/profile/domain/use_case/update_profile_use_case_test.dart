import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/update_profile_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late UpdateProfileUseCase useCase;
  late MockProfileRepo mockRepo;

  setUp(() {
    mockRepo = MockProfileRepo();
    useCase = UpdateProfileUseCase(mockRepo);
    registerFallbackValue(const ProfileEntity(
      firstName: '',
      lastName: '',
      email: '',
      phoneNumber: '',
      gender: '',
    ));
  });

  test('should call updateProfile from the repository', () async {
    // Arrange
    final entity = const ProfileEntity(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phoneNumber: '01000000000',
      gender: 'Male',
    );
    when(() => mockRepo.updateProfile(any()))
        .thenAnswer((_) async => SuccessResponce(entity));

    // Act
    final result = await useCase(entity);

    // Assert
    expect(result, isA<SuccessResponce<ProfileEntity>>());
    verify(() => mockRepo.updateProfile(entity)).called(1);
    verifyNoMoreInteractions(mockRepo);
  });
}
