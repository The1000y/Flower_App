import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:flower_app/features/profile/api/data_source_impl/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileApiClient extends Mock implements ProfileApiClient {}

class FakeChangePasswordRequest extends Fake implements ChangePasswordRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChangePasswordRequest());
  });

  late MockProfileApiClient mockApiClient;
  late ProfileRemoteDataSourceImpl dataSource;

  setUp(() {
    mockApiClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(Dio(), mockApiClient);
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
      when(() => mockApiClient.changePassword(any())).thenAnswer((_) async => tResponse);

      final result = await dataSource.changePassword(tRequest);

      expect(result, isA<SuccessResponce<ChangePasswordResponse>>());
      expect((result as SuccessResponce<ChangePasswordResponse>).data, equals(tResponse));
      verify(() => mockApiClient.changePassword(tRequest)).called(1);
    });

    test('should return ErrorResponce<ChangePasswordResponse> when ProfileApiClient throws exception', () async {
      final tException = Exception('Network Exception');
      when(() => mockApiClient.changePassword(any())).thenThrow(tException);

      final result = await dataSource.changePassword(tRequest);

      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verify(() => mockApiClient.changePassword(tRequest)).called(1);
    });
  });
}
