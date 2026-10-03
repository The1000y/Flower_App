import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:flower_app/features/profile/api/data_source_impl/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/model/request/change_password_request/change_password_request.dart';
import 'package:flower_app/features/profile/data/model/request/update_profile_request_dto.dart';
import 'package:flower_app/features/profile/data/model/response/change_password_response/change_password_response.dart';
import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileApiClient extends Mock implements ProfileApiClient {}

class FakeChangePasswordRequest extends Fake implements ChangePasswordRequest {}

void main() {
  late MockProfileApiClient mockClient;
  late ProfileRemoteDataSourceImpl dataSource;

  setUpAll(() {
    registerFallbackValue(FakeChangePasswordRequest());
  });

  setUp(() {
    mockClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockClient);
  });

  final dioError = DioException(requestOptions: RequestOptions(path: '/x'));

  group('getProfile', () {
    final dto = GetProfileResponseDto(
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '01000000000',
      gender: 'Male',
    );

    test('returns SuccessResponce holding the DTO from the client', () async {
      when(() => mockClient.getProfile()).thenAnswer((_) async => dto);

      final result = await dataSource.getProfile();

      expect(result, isA<SuccessResponce<GetProfileResponseDto>>());
      expect((result as SuccessResponce<GetProfileResponseDto>).data, same(dto));
    });

    test('returns ErrorResponce when the client throws DioException', () async {
      when(() => mockClient.getProfile()).thenThrow(dioError);

      final result = await dataSource.getProfile();

      expect(result, isA<ErrorResponce<GetProfileResponseDto>>());
      expect((result as ErrorResponce<GetProfileResponseDto>).error, same(dioError));
    });

    test('returns ErrorResponce when the client throws another error', () async {
      when(() => mockClient.getProfile()).thenThrow(StateError('boom'));

      final result = await dataSource.getProfile();

      expect(result, isA<ErrorResponce<GetProfileResponseDto>>());
      expect(
        (result as ErrorResponce<GetProfileResponseDto>).error.toString(),
        contains('boom'),
      );
    });
  });

  group('updateProfile', () {
    final requestDto = UpdateProfileRequestDto(
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '01000000000',
      gender: 'Male',
    );

    test('returns SuccessResponce and sends the DTO fields to the client', () async {
      when(() => mockClient.updateProfile(
        'John Doe',
        'john@example.com',
        '01000000000',
        'Male',
        null,
      )).thenAnswer((_) async {});

      final result = await dataSource.updateProfile(requestDto);

      expect(result, isA<SuccessResponce<void>>());
      verify(() => mockClient.updateProfile(
        'John Doe',
        'john@example.com',
        '01000000000',
        'Male',
        null,
      )).called(1);
    });

    test('returns ErrorResponce when the client throws DioException', () async {
      when(() => mockClient.updateProfile(
        'John Doe',
        'john@example.com',
        '01000000000',
        'Male',
        null,
      )).thenThrow(dioError);

      final result = await dataSource.updateProfile(requestDto);

      expect(result, isA<ErrorResponce<void>>());
      expect((result as ErrorResponce<void>).error, same(dioError));
    });

    test('returns ErrorResponce when the client throws another error', () async {
      when(() => mockClient.updateProfile(
        'John Doe',
        'john@example.com',
        '01000000000',
        'Male',
        null,
      )).thenThrow(StateError('boom'));

      final result = await dataSource.updateProfile(requestDto);

      expect(result, isA<ErrorResponce<void>>());
      expect((result as ErrorResponce<void>).error.toString(), contains('boom'));
    });
  });

  group('changePassword', () {
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

    test('returns SuccessResponce<ChangePasswordResponse> when client succeeds', () async {
      when(() => mockClient.changePassword(any())).thenAnswer((_) async => tResponse);

      final result = await dataSource.changePassword(tRequest);

      expect(result, isA<SuccessResponce<ChangePasswordResponse>>());
      expect((result as SuccessResponce<ChangePasswordResponse>).data, equals(tResponse));
      verify(() => mockClient.changePassword(tRequest)).called(1);
    });

    test('returns ErrorResponce<ChangePasswordResponse> when client throws', () async {
      when(() => mockClient.changePassword(any())).thenThrow(Exception('Network Exception'));

      final result = await dataSource.changePassword(tRequest);

      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      verify(() => mockClient.changePassword(tRequest)).called(1);
    });

    test('returns ErrorResponce<ChangePasswordResponse> when client throws DioException', () async {
      when(() => mockClient.changePassword(any())).thenThrow(dioError);

      final result = await dataSource.changePassword(tRequest);

      expect(result, isA<ErrorResponce<ChangePasswordResponse>>());
      expect((result as ErrorResponce<ChangePasswordResponse>).error, same(dioError));
    });
  });
}
