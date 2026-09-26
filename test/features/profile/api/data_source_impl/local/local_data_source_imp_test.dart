import 'dart:convert';

import 'package:flower_app/config/base/base_responce.dart';
import 'package:flower_app/features/auth/api/service/secure_storage.dart';
import 'package:flower_app/features/auth/data/model/user_dto.dart';
import 'package:flower_app/features/profile/api/data_source_impl/local/local_data_source_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockSecureStorageService mockStorage;
  late ProfileLocalDataSourceImp dataSource;

  final validUserDto = UserDto(
    id: 1,
    fullName: 'Nour Mohamed',
    email: 'nour@example.com',
    phoneNumber: '+201234567890',
    gender: 'female',
    role: 'user',
    status: 'active',
  );

  setUp(() {
    mockStorage = MockSecureStorageService();
    dataSource = ProfileLocalDataSourceImp(mockStorage);
  });

  group('ProfileLocalDataSourceImp', () {
    group('getProfile - Success', () {
      test('returns SuccessResponce<UserDto> when valid JSON stored', () async {
        final jsonString = jsonEncode(validUserDto.toJson());
        when(() => mockStorage.getUser()).thenAnswer((_) async => jsonString);

        final result = await dataSource.getProfile();

        expect(result, isA<SuccessResponce<UserDto>>());
        final success = result as SuccessResponce<UserDto>;
        expect(success.data.id, 1);
        expect(success.data.fullName, 'Nour Mohamed');
        expect(success.data.email, 'nour@example.com');
      });

      test('maps all fields correctly from JSON', () async {
        final jsonString = jsonEncode({
          'id': 42,
          'fullName': 'Ahmed Ali',
          'email': 'ahmed@test.com',
          'phoneNumber': '+201112223334',
          'gender': 'male',
          'role': 'admin',
          'photoUrl': 'https://example.com/photo.jpg',
          'status': 'active',
        });
        when(() => mockStorage.getUser()).thenAnswer((_) async => jsonString);

        final result = await dataSource.getProfile();

        final success = result as SuccessResponce<UserDto>;
        expect(success.data.id, 42);
        expect(success.data.fullName, 'Ahmed Ali');
        expect(success.data.photoUrl, 'https://example.com/photo.jpg');
      });
    });

    group('getProfile - Errors', () {
      test('returns ErrorResponce when storage returns null', () async {
        when(() => mockStorage.getUser()).thenAnswer((_) async => null);

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when storage returns empty string', () async {
        when(() => mockStorage.getUser()).thenAnswer((_) async => '');

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when JSON is malformed', () async {
        when(
          () => mockStorage.getUser(),
        ).thenAnswer((_) async => 'not_valid_json{{{');

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when storage throws', () async {
        when(
          () => mockStorage.getUser(),
        ).thenThrow(Exception('Storage failure'));

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when the stored JSON is a list', () async {
        when(() => mockStorage.getUser()).thenAnswer((_) async => '[1, 2, 3]');

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when a field has the wrong type', () async {
        when(() => mockStorage.getUser()).thenAnswer(
          (_) async => jsonEncode({'id': 'not-a-number', 'fullName': 'Nour'}),
        );

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test(
        'tolerates a payload with unknown/missing optional fields',
        () async {
          // Required fields are present; `photoUrl` is explicitly null and
          // `extra` is an unknown key the model must ignore.
          when(() => mockStorage.getUser()).thenAnswer(
            (_) async => jsonEncode({
              'id': 7,
              'fullName': 'Nour Mohamed',
              'email': 'nour@example.com',
              'phoneNumber': '+201234567890',
              'gender': 'female',
              'role': 'user',
              'status': 'active',
              'photoUrl': null,
              'extra': 'unknown',
            }),
          );

          final result = await dataSource.getProfile();

          expect(result, isA<SuccessResponce<UserDto>>());
          final dto = (result as SuccessResponce<UserDto>).data;
          expect(dto.photoUrl, isNull);
          expect(dto.id, 7);
          expect(dto.fullName, 'Nour Mohamed');
          expect(dto.email, 'nour@example.com');
          expect(dto.phoneNumber, '+201234567890');
          expect(dto.gender, 'female');
          expect(dto.role, 'user');
          expect(dto.status, 'active');
        },
      );

      test('defaults every missing field to null in the DTO', () async {
        when(
          () => mockStorage.getUser(),
        ).thenAnswer((_) async => jsonEncode({'unrelated': 'value'}));

        final result = await dataSource.getProfile();

        expect(result, isA<SuccessResponce<UserDto>>());
        final dto = (result as SuccessResponce<UserDto>).data;
        expect(dto.id, isNull);
        expect(dto.fullName, isNull);
        expect(dto.email, isNull);
        expect(dto.photoUrl, isNull);

        // The repository is what applies the fallbacks, so it must not throw.
        expect(dto.toUserEntity().id, 0);
        expect(dto.toUserEntity().fullName, '');
      });

      test('does not throw when the stored JSON is corrupted', () async {
        when(
          () => mockStorage.getUser(),
        ).thenAnswer((_) async => '{"fullName": "Nour"');

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });
    });
  });
}
