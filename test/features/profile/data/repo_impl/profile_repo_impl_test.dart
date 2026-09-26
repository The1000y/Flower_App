import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/data/data_source/remote_data_source/profile_remote_data_source.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/request/update_profile_request_dto.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';
import 'package:flower_app/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:flower_app/features/profile/domain/entities/change_password_entity.dart';
import 'package:flower_app/features/profile/domain/entities/profile_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileRemoteDataSource extends Mock implements ProfileRemoteDataSource {}

class FakeUpdateProfileRequestDto extends Fake implements UpdateProfileRequestDto {}

class FakeChangePasswordRequest extends Fake implements ChangePasswordRequest {}

void main() {
  late ProfileRepoImpl repo;
  late MockProfileRemoteDataSource mockRemoteDataSource;

  setUpAll(() {
    registerFallbackValue(FakeUpdateProfileRequestDto());
    registerFallbackValue(FakeChangePasswordRequest());
  });

  setUp(() {
    mockRemoteDataSource = MockProfileRemoteDataSource();
    repo = ProfileRepoImpl(mockRemoteDataSource);
  });

  group('getProfile', () {
    test('returns SuccessResponce<ProfileEntity> when data source succeeds', () async {
      final dto = GetProfileResponseDto(
        fullName: 'John Doe',
        email: 'john@example.com',
        phone: '01000000000',
        gender: 'Male',
      );
      when(() => mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => SuccessResponce(dto));

      final result = await repo.getProfile();

      expect(result, isA<SuccessResponce<ProfileEntity>>());
      final entity = (result as SuccessResponce<ProfileEntity>).data;
      expect(entity.firstName, 'John');
      expect(entity.lastName, 'Doe');
    });

    test('returns ErrorResponce when data source fails', () async {
      when(() => mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => ErrorResponce(Exception('Network error')));

      final result = await repo.getProfile();

      expect(result, isA<ErrorResponce<ProfileEntity>>());
    });
  });

  group('updateProfile', () {
    final entity = const ProfileEntity(
      firstName: 'Jane',
      lastName: 'Doe',
      email: 'jane@example.com',
      phoneNumber: '01000000000',
      gender: 'Female',
    );

    test('returns SuccessResponce<ProfileEntity> when data source succeeds', () async {
      final dto = GetProfileResponseDto(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        phone: '01000000000',
        gender: 'Female',
      );

      when(() => mockRemoteDataSource.updateProfile(any()))
          .thenAnswer((_) async => SuccessResponce<void>(null));
      when(() => mockRemoteDataSource.getProfile())
          .thenAnswer((_) async => SuccessResponce(dto));

      final result = await repo.updateProfile(entity);

      expect(result, isA<SuccessResponce<ProfileEntity>>());
      verify(() => mockRemoteDataSource.updateProfile(any())).called(1);
      verify(() => mockRemoteDataSource.getProfile()).called(1);
    });

    test('returns ErrorResponce when update data source fails', () async {
      when(() => mockRemoteDataSource.updateProfile(any()))
          .thenAnswer((_) async => ErrorResponce<void>(Exception('Update error')));

      final result = await repo.updateProfile(entity);

      expect(result, isA<ErrorResponce<ProfileEntity>>());
      verify(() => mockRemoteDataSource.updateProfile(any())).called(1);
      verifyNever(() => mockRemoteDataSource.getProfile());
    });
  });

  group('changePassword', () {
    final tResponse = ChangePasswordResponse(
      data: true,
      isSuccess: true,
      message: 'Password changed successfully',
      errorCode: 200,
    );

    test('delegates to the data source and returns mapped SuccessResponce', () async {
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => SuccessResponce<ChangePasswordResponse>(tResponse));

      final result = await repo.changePassword(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      );

      expect(result, isA<SuccessResponce<ChangePasswordEntity>>());
      expect((result as SuccessResponce<ChangePasswordEntity>).data, equals(tResponse.toEntity()));
      verify(() => mockRemoteDataSource.changePassword(any())).called(1);
    });

    test('returns ErrorResponce when the data source fails', () async {
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => ErrorResponce<ChangePasswordResponse>(Exception('Remote error')));

      final result = await repo.changePassword(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'NewPassword123',
      );

      expect(result, isA<ErrorResponce<ChangePasswordEntity>>());
      verify(() => mockRemoteDataSource.changePassword(any())).called(1);
    });

    test('sends the request with the field names the remote expects', () async {
      when(() => mockRemoteDataSource.changePassword(any()))
          .thenAnswer((_) async => SuccessResponce<ChangePasswordResponse>(tResponse));

      await repo.changePassword(
        currentPassword: 'OldPassword123',
        newPassword: 'NewPassword123',
        confirmPassword: 'Confirm123',
      );

      final captured = verify(() => mockRemoteDataSource.changePassword(captureAny())).captured.single
          as ChangePasswordRequest;
      expect(captured.currentPassword, 'OldPassword123');
      expect(captured.newPassword, 'NewPassword123');
      expect(captured.confirmNewPassword, 'Confirm123');
    });
  });
}
