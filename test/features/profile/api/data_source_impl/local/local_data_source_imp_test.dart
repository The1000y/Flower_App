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
        when(() => mockStorage.getUser(any())).thenAnswer((_) async => jsonString);

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
        when(() => mockStorage.getUser(any())).thenAnswer((_) async => jsonString);

        final result = await dataSource.getProfile();

        final success = result as SuccessResponce<UserDto>;
        expect(success.data.id, 42);
        expect(success.data.fullName, 'Ahmed Ali');
        expect(success.data.photoUrl, 'https://example.com/photo.jpg');
      });
    });

    group('getProfile - Errors', () {
      test('returns ErrorResponce when storage returns null', () async {
        when(() => mockStorage.getUser(any())).thenAnswer((_) async => null);

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when storage returns empty string', () async {
        when(() => mockStorage.getUser(any())).thenAnswer((_) async => '');

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when JSON is malformed', () async {
        when(() => mockStorage.getUser(any()))
            .thenAnswer((_) async => 'not_valid_json{{{');

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });

      test('returns ErrorResponce when storage throws', () async {
        when(() => mockStorage.getUser(any()))
            .thenThrow(Exception('Storage failure'));

        final result = await dataSource.getProfile();

        expect(result, isA<ErrorResponce<UserDto>>());
      });
    });
  });
}
