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

      final entity = request.toRegisterRequestEntity();

      expect(entity, isA<RegisterRequestEntity>());
      expect(entity.fullName, fullName);
      expect(entity.email, email);
      expect(entity.phoneNumber, phoneNumber);
      expect(entity.gender, gender);
      expect(entity.password, password);
      expect(entity.confirmPassword, confirmPassword);
    });
  test('fromEntity maps the entity fields to the DTO', () {
      final entity = RegisterRequestEntity(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        gender: gender,
        password: password,
        confirmPassword: confirmPassword,
      );

      final request = RegisterRequest.fromEntity(entity);

      expect(request.fullName, fullName);
      expect(request.email, email);
      expect(request.phoneNumber, phoneNumber);
      expect(request.gender, gender);
      expect(request.password, password);
      expect(request.confirmPassword, confirmPassword);
    });
  });
}