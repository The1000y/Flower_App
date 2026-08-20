import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const json = <String, dynamic>{
    'isSuccess': true,
    'errorCode': 200,
    'message': 'Registration successful',
    'data': true,
  };

  group('RegisterResponse', () {
    test('toJson returns the expected map', () {
      final response = RegisterResponse(
        isSuccess: true,
        errorCode: 200,
        message: 'Registration successful',
        data: true,
      );

      expect(response.toJson(), json);
    });

    test('fromJson parses the map into a response', () {
      final response = RegisterResponse.fromJson(json);

      expect(response.isSuccess, isTrue);
      expect(response.errorCode, 200);
      expect(response.message, 'Registration successful');
      expect(response.data, isTrue);
    });

    test('fromJson handles null values', () {
      const emptyJson = <String, dynamic>{
        'isSuccess': null,
        'errorCode': null,
        'message': null,
        'data': null,
      };

      final response = RegisterResponse.fromJson(emptyJson);

      expect(response.isSuccess, isNull);
      expect(response.errorCode, isNull);
      expect(response.message, isNull);
      expect(response.data, isNull);
    });

    test('toJson round-trips through fromJson', () {
      final response = RegisterResponse.fromJson(json);

      expect(response.toJson(), json);
    });

    test('toRegisterEntity maps fields to the entity', () {
      final response = RegisterResponse.fromJson(json);

      final entity = response.toRegisterEntity();

      expect(entity, isA<RegisterEntity>());
      expect(entity.isSuccess, isTrue);
      expect(entity.errorCode, 200);
      expect(entity.message, 'Registration successful');
      expect(entity.data, isTrue);
    });

    test('toRegisterEntity falls back to defaults for null fields', () {
      final response = RegisterResponse();

      final entity = response.toRegisterEntity();

      expect(entity.isSuccess, isFalse);
      expect(entity.errorCode, 0);
      expect(entity.message, 'entity null');
      expect(entity.data, isFalse);
    });
  });
}