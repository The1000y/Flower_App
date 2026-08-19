import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/domain/entities/register_entity/register_request_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const fullName = 'John Doe';
  const email = 'john@example.com';
  const phoneNumber = '01012345678';
  const gender = 1;
  const password = 'P@ssw0rd';
  const confirmPassword = 'P@ssw0rd';

  const json = <String, dynamic>{
    'fullName': fullName,
    'email': email,
    'phoneNumber': phoneNumber,
    'gender': gender,
    'password': password,
    'confirmPassword': confirmPassword,
  };

  group('RegisterRequest', () {
    test('toJson returns the expected map', () {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        password: password,
        confirmPassword: confirmPassword,
      );

      expect(request.toJson(), json);
    });

    test('fromJson parses the map into a request', () {
      final request = RegisterRequest.fromJson(json);

      expect(request.fullName, fullName);
      expect(request.email, email);
      expect(request.phoneNumber, phoneNumber);
      expect(request.gender, gender);
      expect(request.password, password);
      expect(request.confirmPassword, confirmPassword);
    });

    test('fromJson handles null values', () {
      const emptyJson = <String, dynamic>{
        'fullName': null,
        'email': null,
        'phoneNumber': null,
        'gender': null,
        'password': null,
        'confirmPassword': null,
      };

      final request = RegisterRequest.fromJson(emptyJson);

      expect(request.fullName, isNull);
      expect(request.email, isNull);
      expect(request.phoneNumber, isNull);
      expect(request.gender, isNull);
      expect(request.password, isNull);
      expect(request.confirmPassword, isNull);
    });

    test('toJson round-trips through fromJson', () {
      final request = RegisterRequest.fromJson(json);

      expect(request.toJson(), json);
    });

    test('toRegisterEntityRequest maps fields to the entity', () {
      final request = RegisterRequest(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        password: password,
        confirmPassword: confirmPassword,
      );

      final entity = request.toregisterentityrequest();

      expect(entity, isA<RegisterRequestEntity>());
      expect(entity.fullName, fullName);
      expect(entity.email, email);
      expect(entity.phoneNumber, phoneNumber);
      expect(entity.gender, gender);
      expect(entity.password, password);
      expect(entity.confirmPassword, confirmPassword);
    });

    test('toRegisterEntityRequest falls back to defaults for null fields', () {
      final request = RegisterRequest();

      final entity = request.toregisterentityrequest();

      expect(entity.fullName, isEmpty);
      expect(entity.email, isEmpty);
      expect(entity.phoneNumber, isEmpty);
      expect(entity.gender, 0);
      expect(entity.password, isEmpty);
      expect(entity.confirmPassword, isEmpty);
    });
  });
}