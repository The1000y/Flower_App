import 'package:dio/dio.dart';
import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/data/data_source/remote_data_source/remote_data_source.dart';
import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:flower_app/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRemoteDataSource extends Mock implements RemoteDataSource {}

void main() {
  final entity = RegisterRequestEntity(
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '01012345678',
    gender: 1,
    password: 'P@ssw0rd',
    confirmPassword: 'P@ssw0rd',
  );

  late MockRemoteDataSource remoteDataSource;
  late AuthRepoImpl repo;

  setUpAll(() {
    registerFallbackValue(entity);
    registerFallbackValue(RegisterRequest());
  });

  setUp(() {
    remoteDataSource = MockRemoteDataSource();
    repo = AuthRepoImpl(remoteDataSource);
  });

  group('AuthRepoImpl.register', () {
    test('returns SuccessResponce when remote registers successfully', () async {
      final response = RegisterResponse(
        isSuccess: true,
        errorCode: 200,
        message: 'Registration successful',
        data: true,
      );
      when(() => remoteDataSource.register(any())).thenAnswer(
        (_) async => response,
      );

      final result = await repo.register(entity);

      expect(result, isA<SuccessResponce<RegisterEntity>>());
      final resultEntity = (result as SuccessResponce<RegisterEntity>).data;
      expect(resultEntity.isSuccess, isTrue);
      expect(resultEntity.errorCode, 200);
      expect(resultEntity.message, 'Registration successful');
      expect(resultEntity.data, isTrue);
      verify(() => remoteDataSource.register(any())).called(1);
    });

    test('returns ErrorResponce when remote registration fails', () async {
      final response = RegisterResponse(
        isSuccess: false,
        errorCode: 400,
        message: 'Invalid data',
        data: false,
      );
      when(() => remoteDataSource.register(any())).thenAnswer(
        (_) async => response,
      );

      final result = await repo.register(entity);

      expect(result, isA<ErrorResponce<RegisterEntity>>());
      expect(
        (result as ErrorResponce<RegisterEntity>).errorMessage,
        'something went wrong, pls try again',
      );
    });

    test(
      'returns ErrorResponce with fallback message when message is null',
      () async {
        final response = RegisterResponse(
          isSuccess: false,
          errorCode: 400,
          message: null,
          data: false,
        );
        when(() => remoteDataSource.register(any())).thenAnswer(
          (_) async => response,
        );

        final result = await repo.register(entity);

        expect(result, isA<ErrorResponce<RegisterEntity>>());
        expect(
          (result as ErrorResponce<RegisterEntity>).errorMessage,
          'something went wrong, pls try again',
        );
      },
    );

    test('returns ErrorResponce when remote throws a DioException', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(path: '/register'),
        type: DioExceptionType.connectionTimeout,
      );
      when(() => remoteDataSource.register(any())).thenThrow(dioException);

      final result = await repo.register(entity);

      expect(result, isA<ErrorResponce<RegisterEntity>>());
      expect(
        (result as ErrorResponce<RegisterEntity>).errorMessage,
        'connectionTimeout',
      );
    });

    test(
      'returns ErrorResponce when remote throws a generic exception',
      () async {
        when(() => remoteDataSource.register(any())).thenThrow(
          Exception('boom'),
        );

        final result = await repo.register(entity);

        expect(result, isA<ErrorResponce<RegisterEntity>>());
        expect(
          (result as ErrorResponce<RegisterEntity>).errorMessage,
          'something went wrong, pls try again',
        );
      },
    );
  });
}