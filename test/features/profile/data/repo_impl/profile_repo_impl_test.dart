import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/local_data_source/local_data_source.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

class MockProfileLocalDataSource extends Mock implements ProfileLocalDataSource {}

class FakeChangePasswordRequest extends Fake implements ChangePasswordRequest {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChangePasswordRequest());
  });

  late MockProfileRemoteDataSource mockRemoteDataSource;
  late MockProfileLocalDataSource mockLocalDataSource;
  late ProfileRepoImpl repoImpl;

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    mockLocalDataSource = MockProfileLocalDataSource();
    repoImpl = ProfileRepoImpl(mockRemoteDataSource, mockLocalDataSource);
  });

  final tResponse = ChangePasswordResponse(
    data: true,
    isSuccess: true,
    message: 'Password changed successfully',
    errorCode: 200,
  );

  group('ProfileRepoImpl', () {
    test('should delegate changePassword call to ProfileRemoteDataSource and return mapped SuccessResponce', () async {
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => SuccessResponce<ChangePasswordResponse>(tResponse));

      final result = await repoImpl.changePassword(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      );

      expect(result, isA<SuccessResponce<ChangePasswordEntity>>());
      expect((result as SuccessResponce<ChangePasswordEntity>).data, equals(tResponse.toEntity()));
      verify(() => mockRemoteDataSource.changePassword(any())).called(1);
    });

    test('should return ErrorResponce when ProfileRemoteDataSource.changePassword fails', () async {
      final tError = ErrorResponce<ChangePasswordResponse>(Exception('Remote error'));
      when(() => mockRemoteDataSource.changePassword(any())).thenAnswer((_) async => tError);

      final result = await repoImpl.changePassword(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      );

      expect(result, isA<ErrorResponce<ChangePasswordEntity>>());
      verify(() => mockRemoteDataSource.changePassword(any())).called(1);
    });
  });
}
