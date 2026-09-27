import 'package:flower_app/features/auth/api/data_source_impl/remote/remote_data_source_impl.dart';

import 'package:flower_app/features/auth/data/model/request/register_request/register_request.dart';
import 'package:flower_app/features/auth/data/model/responce/register_responce/register_response.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/auth_test_helpers.dart';

void main() {
  group('RemoteDataSourceImpl.register', () {
    test('returns success for a valid request', () async {
      final dataSource = RemoteDataSourceImpl(
        FakeAuthApiClient(
          registerResponse: RegisterResponse(
            isSuccess: true,
            errorCode: 200,
            message: 'Registration successful',
            data: true,
          ),
        ),
      );

      final response = await dataSource.register(
        RegisterRequest(
          fullName: 'John Doe',
          email: 'john@example.com',
          phoneNumber: '01012345678',
          gender: 1,
          password: 'P@ssw0rd',
          confirmPassword: 'P@ssw0rd',
        ),
      );

      expect(response.isSuccess, isTrue);
      expect(response.errorCode, 200);
      expect(response.message, 'Registration successful');
      expect(response.data, isTrue);
    });

    test('returns failure when the api throws', () async {
      final dataSource = RemoteDataSourceImpl(
        FakeAuthApiClient(
          registerResponse: RegisterResponse(
            isSuccess: false,
            errorCode: 400,
            message: 'Email already exists',
            data: false,
          ),
        ),
      );

      final response = await dataSource.register(
        RegisterRequest(
          fullName: 'John Doe',
          email: 'john@example.com',
          phoneNumber: '01012345678',
          gender: 1,
          password: 'P@ssw0rd',
          confirmPassword: 'P@ssw0rd',
        ),
      );

      expect(response.isSuccess, isFalse);
      expect(response.message, 'Email already exists');
    });

    test('parses fromJson round-trip for a valid payload', () {
      const validJson = <String, dynamic>{
        'firstName': 'John',
        'lastName': 'Doe',
        'email': 'john@example.com',
        'phoneNumber': '01012345678',
        'gender': 'Female',
        'password': 'P@ssw0rd',
        'confirmPassword': 'P@ssw0rd',
      };

      final request = RegisterRequest.fromJson(validJson);

      expect(request.fullName, 'John Doe');
      expect(request.toJson(), validJson);
    });
  });
}
