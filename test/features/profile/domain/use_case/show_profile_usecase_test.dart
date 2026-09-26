import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/domain/entities/login_entity/user_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/show_profile_usecase.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo mockRepo;
  late ShowProfileUsecase usecase;

  const userEntity = UserEntity(
    id: 1,
    fullName: 'Nour Mohamed',
    email: 'nour@example.com',
    phoneNumber: '+201234567890',
    gender: 'female',
    role: 'user',
    status: 'active',
  );

  setUp(() {
    mockRepo = MockProfileRepo();
    usecase = ShowProfileUsecase(mockRepo);
  });

  group('ShowProfileUsecase', () {
    test('returns SuccessResponce from repo on success', () async {
      when(
        () => mockRepo.getProfile(),
      ).thenAnswer((_) async => SuccessResponce(userEntity));

      final result = await usecase.getProfile();

      expect(result, isA<SuccessResponce<UserEntity>>());
      final success = result as SuccessResponce<UserEntity>;
      expect(success.data.id, 1);
      expect(success.data.fullName, 'Nour Mohamed');
      verify(() => mockRepo.getProfile()).called(1);
    });

    test('returns ErrorResponce from repo on failure', () async {
      when(() => mockRepo.getProfile()).thenAnswer(
        (_) async =>
            ErrorResponce<UserEntity>(Exception('Profile not available')),
      );

      final result = await usecase.getProfile();

      expect(result, isA<ErrorResponce<UserEntity>>());
      verify(() => mockRepo.getProfile()).called(1);
    });

    test('delegates directly to repo without modification', () async {
      final response = SuccessResponce(userEntity);
      when(() => mockRepo.getProfile()).thenAnswer((_) async => response);

      final result = await usecase.getProfile();

      expect(result, same(response));
    });

    test('calls repo exactly once', () async {
      when(
        () => mockRepo.getProfile(),
      ).thenAnswer((_) async => SuccessResponce(userEntity));

      await usecase.getProfile();

      verify(() => mockRepo.getProfile()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });
  });
}
