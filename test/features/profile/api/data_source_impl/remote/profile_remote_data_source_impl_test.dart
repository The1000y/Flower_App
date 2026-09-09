import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:flower_app/features/profile/api/data_source_impl/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'profile_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ProfileApiClient])
void main() {
  late MockProfileApiClient mockApiClient;
  late ProfileRemoteDataSourceImpl dataSourceImpl;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    dataSourceImpl = ProfileRemoteDataSourceImpl(mockApiClient);
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

  group('ProfileRemoteDataSourceImpl', () {
    test('should return SuccessResponce<ChangePasswordResponse> when ProfileApiClient succeeds', () async {
      // Arrange
      when(mockApiClient.changePassword(any)).thenAnswer((_) async => tResponse);

      // Act
      final result = await dataSourceImpl.changePassword(tRequest);

      // Assert
      expect(result, isA<SuccessResponce<ChangePasswordResponse>>());
      expect((result as SuccessResponce<ChangePasswordResponse>).data, equals(tResponse));
      verify(mockApiClient.changePassword(tRequest)).called(1);
    });

    test('should catch Exception and return ErrorResponce when ProfileApiClient throws Exception', () async {
      // Arrange
      when(mockApiClient.changePassword(any)).thenThrow(Exception('API Error'));

      // Act
      final result = await dataSourceImpl.changePassword(tRequest);

      // Assert
      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verify(mockApiClient.changePassword(tRequest)).called(1);
    });
  });
}
