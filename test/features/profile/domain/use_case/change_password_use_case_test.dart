import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/domain/repo/profile_repo.dart';
import 'package:flower_app/features/profile/domain/use_case/change_password_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'change_password_use_case_test.mocks.dart';

@GenerateMocks([ProfileRepo])
void main() {
  provideDummy<BaseResponce<ChangePasswordResponse>>(
    ErrorResponce(Exception('dummy')),
  );

  late MockProfileRepo mockProfileRepo;
  late ChangePasswordUseCase useCase;

  setUp(() {
    mockProfileRepo = MockProfileRepo();
    useCase = ChangePasswordUseCase(mockProfileRepo);
  });

  final tValidRequest = ChangePasswordRequest(
    currentPassword: 'OldPassword123',
    newPassword: 'NewPassword123',
    confirmNewPassword: 'NewPassword123',
  );

  final tResponse = ChangePasswordResponse(
    data: true,
    isSuccess: true,
    message: 'Password changed successfully',
    errorCode: 200,
  );

  group('ChangePasswordUseCase', () {
    test('should return ErrorResponce when currentPassword is empty without calling repo', () async {
      // Arrange
      final request = ChangePasswordRequest(
        currentPassword: '   ',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'NewPassword123',
      );

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verifyZeroInteractions(mockProfileRepo);
    });

    test('should return ErrorResponce when newPassword is empty without calling repo', () async {
      // Arrange
      final request = ChangePasswordRequest(
        currentPassword: 'OldPassword123',
        newPassword: '',
        confirmNewPassword: '',
      );

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verifyZeroInteractions(mockProfileRepo);
    });

    test('should return ErrorResponce when newPassword != confirmNewPassword without calling repo', () async {
      // Arrange
      final request = ChangePasswordRequest(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmNewPassword: 'DifferentPassword123',
      );

      // Act
      final result = await useCase.call(request);

      // Assert
      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verifyZeroInteractions(mockProfileRepo);
    });

    test('should call ProfileRepo.changePassword and return SuccessResponce when validation passes', () async {
      // Arrange
      when(mockProfileRepo.changePassword(any))
          .thenAnswer((_) async => SuccessResponce<ChangePasswordResponse>(tResponse));

      // Act
      final result = await useCase.call(tValidRequest);

      // Assert
      expect(result, isA<SuccessResponce<ChangePasswordResponse>>());
      expect((result as SuccessResponce<ChangePasswordResponse>).data, equals(tResponse));
      verify(mockProfileRepo.changePassword(tValidRequest)).called(1);
      verifyNoMoreInteractions(mockProfileRepo);
    });

    test('should return ErrorResponce when ProfileRepo.changePassword fails', () async {
      // Arrange
      final tError = ErrorResponce<ChangePasswordResponse>(Exception('Network error'));
      when(mockProfileRepo.changePassword(any)).thenAnswer((_) async => tError);

      // Act
      final result = await useCase.call(tValidRequest);

      // Assert
      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verify(mockProfileRepo.changePassword(tValidRequest)).called(1);
    });
  });
}
