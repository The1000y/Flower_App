import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/profile/api/client/profile_api_client.dart';
import 'package:flower_app/features/profile/api/data_source_impl/remote/profile_remote_data_source_impl.dart';
import 'package:flower_app/features/profile/data/model/request/update_profile_request_dto.dart';
import 'package:flower_app/features/profile/data/model/response/get_profile_response_dto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockProfileApiClient extends Mock implements ProfileApiClient {}

void main() {
  late ProfileRemoteDataSourceImpl dataSource;
  late MockProfileApiClient mockClient;

  setUp(() {
    mockClient = MockProfileApiClient();
    dataSource = ProfileRemoteDataSourceImpl(mockClient);
  });

  group('getProfile', () {
    test('returns SuccessResponce on valid response', () async {
      final dto = GetProfileResponseDto(fullName: 'John Doe');
      when(() => mockClient.getProfile()).thenAnswer((_) async => dto);

      final result = await dataSource.getProfile();
      expect(result, isA<SuccessResponce<GetProfileResponseDto>>());
    });

    test('returns ErrorResponce on DioException', () async {
      when(() => mockClient.getProfile()).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.getProfile();
      expect(result, isA<ErrorResponce<GetProfileResponseDto>>());
    });

    test('returns ErrorResponce on other Exception', () async {
      when(() => mockClient.getProfile()).thenThrow(Exception('Generic error'));

      final result = await dataSource.getProfile();
      expect(result, isA<ErrorResponce<GetProfileResponseDto>>());
    });
  });

  group('updateProfile', () {
    final requestDto = UpdateProfileRequestDto(
      fullName: 'John Doe',
      email: 'john@example.com',
      phone: '01000000000',
      gender: 'Male',
    );

    test('returns SuccessResponce on successful update', () async {
      when(() => mockClient.updateProfile(any(), any(), any(), any(), any()))
          .thenAnswer((_) async => Future.value());

      final result = await dataSource.updateProfile(requestDto);

      expect(result, isA<SuccessResponce<void>>());
      verify(() => mockClient.updateProfile(
            requestDto.fullName,
            requestDto.email,
            requestDto.phone,
            requestDto.gender,
            requestDto.photo,
          )).called(1);
    });

    test('returns ErrorResponce on DioException', () async {
      when(() => mockClient.updateProfile(any(), any(), any(), any(), any()))
          .thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final result = await dataSource.updateProfile(requestDto);
      expect(result, isA<ErrorResponce<void>>());
    });

    test('returns ErrorResponce on other Exception', () async {
      when(() => mockClient.updateProfile(any(), any(), any(), any(), any()))
          .thenThrow(Exception('Generic update error'));

      final result = await dataSource.updateProfile(requestDto);
      expect(result, isA<ErrorResponce<void>>());
    });
  });
}
