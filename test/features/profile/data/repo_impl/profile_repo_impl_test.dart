import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_repo_impl_test.mocks.dart';

@GenerateMocks([ProfileRemoteDataSource])
void main() {
  provideDummy<BaseResponce<ChangePasswordResponse>>(
    ErrorResponce(Exception('dummy')),
  );

  late MockProfileRemoteDataSource mockRemoteDataSource;
  late ProfileRepoImpl repoImpl;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repoImpl = ProfileRepoImpl(mockRemoteDataSource);
  });

  final tRequest = ChangePasswordRequest(
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

  group('ProfileRepoImpl', () {
    test('should delegate changePassword call to ProfileRemoteDataSource and return SuccessResponce', () async {
      // Arrange
      when(mockRemoteDataSource.changePassword(any))
          .thenAnswer((_) async => SuccessResponce<ChangePasswordResponse>(tResponse));

      // Act
      final result = await repoImpl.changePassword(tRequest);

      // Assert
      expect(result, isA<SuccessResponce<ChangePasswordResponse>>());
      expect((result as SuccessResponce<ChangePasswordResponse>).data, equals(tResponse));
      verify(mockRemoteDataSource.changePassword(tRequest)).called(1);
    });

    test('should return ErrorResponce when ProfileRemoteDataSource.changePassword fails', () async {
      // Arrange
      final tError = ErrorResponce<ChangePasswordResponse>(Exception('Remote error'));
      when(mockRemoteDataSource.changePassword(any)).thenAnswer((_) async => tError);

      // Act
      final result = await repoImpl.changePassword(tRequest);

      // Assert
      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verify(mockRemoteDataSource.changePassword(tRequest)).called(1);
    });
  });
}
