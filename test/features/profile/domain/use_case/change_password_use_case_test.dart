import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/change_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRepo extends Mock implements ProfileRepo {}

void main() {
  late MockProfileRepo mockProfileRepo;
  late ChangePasswordUseCase useCase;

  setUp(() {
    mockProfileRepo = MockProfileRepo();
    useCase = ChangePasswordUseCase(mockProfileRepo);
  });

  const tEntity = ChangePasswordEntity(
    data: true,
    isSuccess: true,
    message: 'Password changed successfully',
    errorCode: 200,
  );

  group('ChangePasswordUseCase', () {
    test('should call ProfileRepo.changePassword and return SuccessResponce when repo succeeds', () async {
      when(() => mockProfileRepo.changePassword(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmPassword: 'NewPassword123',
          )).thenAnswer((_) async => SuccessResponce<ChangePasswordEntity>(tEntity));

      final result = await useCase.call(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      expect(result, isA<SuccessResponce<ChangePasswordEntity>>());
      expect((result as SuccessResponce<ChangePasswordEntity>).data, equals(tEntity));
      verify(() => mockProfileRepo.changePassword(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmPassword: 'NewPassword123',
          )).called(1);
      verifyNoMoreInteractions(mockProfileRepo);
    });

    test('should return ErrorResponce when ProfileRepo.changePassword fails', () async {
      final tError = ErrorResponce<ChangePasswordEntity>(Exception('Network error'));
      when(() => mockProfileRepo.changePassword(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmPassword: 'NewPassword123',
          )).thenAnswer((_) async => tError);

      final result = await useCase.call(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      expect(result, isA<ErrorResponce<ChangePasswordEntity>>());
      verify(() => mockProfileRepo.changePassword(
            currentPassword: 'OldPassword123',
            newPassword: 'NewPassword123',
            confirmPassword: 'NewPassword123',
          )).called(1);
    });
  });
}
