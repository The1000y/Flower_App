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
  late MockProfileApiClient mockClient;
  late ProfileRemoteDataSourceImpl dataSource;

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
}